
/****************************************************************************
3_prg_ConvertSAScatalog.sas
SAS Global Forum 2020, paper #4801, by Carole Jesse
Uses BASE SAS

Convert character forms of the variables to numeric SAS DATE, TIME, DATETIME
Create Calculated variables

NOTE: 
Input data work.SASCatalog is output from 2_prg_ReadSAScatalog.sas
****************************************************************************/

/* Use PROC SQL (although data step will work too): 
transform character variables to true numeric: utilize INPUT()
create new Variables and Calculations: utilize DHMS(), INTCK() */
PROC SQL;
create table work.SASCatalog2 as
select
Title ,
Type ,
Topic ,
Industry ,
PrimaryProduct ,
JobRole ,
SkillLevel ,

Day ,
/* Convert char Day to num SGF_DATE, use SAS format MMDDYYs10. */
INPUT(Day,ANYDTDTE10.) as SGF_DATE  format=MMDDYYs10. ,

StartTime ,
/* Convert char StartTime to num SGF_TIME_beg, use SAS format TIMEAMPM8. */
INPUT(StartTime,ANYDTTME8.) as SGF_TIME_beg  format=TIMEAMPM8. ,

EndTime ,
/* Convert char EndTime to num SGF_TIME_beg, use SAS format TIMEAMPM8. */
INPUT(EndTime,ANYDTTME8.) as SGF_TIME_end  format=TIMEAMPM8. ,

/* Use the SAS function DHMS() to combine SGF_DATE and SGF_TIME_beg into SGF_DATETIME
syntax to combine a legit SAS date with a legit SAS time is DHMS(SAS date, 0, 0, SAS time) */
DHMS(input(Day,ANYDTDTE10.),0,0,input(StartTime,ANYDTTME8.)) as SGF_DATETIME  format=DATETIME21. ,

/* ALTERNATE for SGF_DATETIME creation */
DHMS(calculated SGF_DATE,0,0,calculated SGF_TIME_beg) as SGF_DATETIME_alt  format=DATETIME21. ,

/* Use SAS function INTCK() to calculate Session Durations, w & wo the 10 minute Q&A window: 
syntax is  INTCK(interval <multiple> <.shift-index>, start-date, end-date, <'method'>) */
INTCK('MINUTE',calculated SGF_TIME_beg, calculated SGF_TIME_end)      as SESSN_DUR_wQA ,
INTCK('MINUTE',calculated SGF_TIME_beg, calculated SGF_TIME_end) - 10 as SESSN_DUR_woQA ,

/* Primary Speaker info */
SPKR_Fname ,
SPKR_Lname ,
SPKR_Company ,
SPKR_JobRole ,

/* grouper for the Speaker Company */
CASE WHEN substr(SPKR_Company,1,3) = 'SAS' then 'SAS'
      ELSE 'NotSAS' end as Company_grp format=$varying6.

from work.SAScatalog
;
quit;

/*********************/
/**** End Program ****/
/*********************/
/* analysis for the question:
How are the Breakout Session speakers split between SAS Employees versus non-SAS employees?
*/
ods noproctitle;
Title1 "SGF2020 Breakout Sessions, 30- versus 60-minute:";
Title2 "Speaker Split between SAS Employees versus notSAS Employees";
PROC FREQ data=work.SAScatalog2(where=(Type='Breakout Session'));
table SESSN_DUR_wQA*Company_grp/missing norow nocol nopercent;
run;
Title1;
Title2;
