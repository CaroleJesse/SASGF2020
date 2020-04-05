/****************************************************************************
4_prg_RDBMSwAutomation.sas
SAS Global Forum 2020, paper #4801, by Carole Jesse
Uses Base SAS and SAS/ACCESS to ODBC for Oracle connection

Combine all the concepts against RDBMS
Add automation via automatic macro variable &SYSDATE9 and INTNX function
To:
Go against a RDBMS database where dates are stored as character, convert them
When the program runs it should automate getting 
the last 12 full calendar months of data, based on the SAS session date
****************************************************************************/
/* create macro vars &begdte9d and &enddte9d, for PROC SQL where clause */
%global begdte9d enddte9d;
data _null_;
DTstring="&sysdate9.";
DTvalue=INPUT(DTstring,anydtdte.);
/* NOTE: DTvalue is the SAS date numeric */
/* create macro var begdte9d, the first day of the first month in the window of 12 months*/
call SYMPUTX('begdte9d', CATS("'", PUT(INTNX('month', DTvalue, -12, 'begin'), DATE9.),"'d"));
/* create macro var enddte9d, the last day of the last month in the window of 12 months*/
call SYMPUTX('enddte9d', CATS("'", PUT(INTNX('month', DTvalue, -1, 'end'), DATE9.),"'d"));
run;
%put &begdte9d &enddte9d;

/* PROC SQL using Oracle connection with libref OraLib1 */
/* correct char dates as Oracle table is read */
/* calculate time between events */
PROC SQL;
create table work.TIDRQMST as
select 
REQUISITION_NBR as RNBR ,
REQUISITION_LINE as RLINE ,
/* char date conversions with INPUT */
INPUT(STATUS_DATE,YYMMDD8.) as STATUS_dte  format=MMDDYYs10. ,
INPUT(DATE_REQUESTED,YYMMDD8.) as REQUEST_dte  format=MMDDYYs10. ,
INPUT(NEED_DATE,YYMMDD8.) as NEED_dte  format=MMDDYYs10. ,
INPUT(SUGG_PO_DATE,YYMMDD8.) as SUGG_PO_dte  format=MMDDYYs10. ,
INPUT(REQUEST_APPROV_DT,YYMMDD8.) as APPROV_dte  format=MMDDYYs10. ,
/* time between events with INTCK */
INTCK('DAYS',calculated REQUEST_DTE, calculated NEED_DTE) as REQtoNEED_days ,
INTCK('DAYS',calculated REQUEST_DTE, calculated APPROV_DTE) as REQtoAPPR_days ,
INTCK('DAYS',calculated REQUEST_DTE, calculated SUGG_PO_DTE) as REQtoSUGGPO_days 

from OraLib1.tidrqmst
/* 12 full cal months, prior to SAS session &SYSDATE9 */
where &begdte9d <= calculated REQUEST_dte <= &enddte9d
;
quit;
/*********************/
/**** End Program ****/
/*********************/