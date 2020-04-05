
/****************************************************************************
2_prg_ReadSAScatalog.sas
SAS Global Forum 2020, paper #4801, by Carole Jesse
Uses BASE SAS, SAS/ACCESS to PC Files

Obtain the SASGF2020 catalog at http://sasgfsessioncatalog.com/#/search/
and clicking the ‘Download all sessions in an Excel spreadsheet’.
The result is a single tab Excel file called SAScatalog.xlsx.
The data tab is called ‘Full Catalog’.
The data range (including header) is A2:AB695 (as of Feb 15, 2020, there are 693 data observations in the catalog).

&DataDir is a macro variable containing the path to the downloaded file:
%let DataDir = YourFilePath\;
****************************************************************************/
%let filenme1=SASCatalog.xlsx;  

* PROC IMPORT (SAS/ACCESS to PC Files) using Tabname$Range syntax;
PROC IMPORT OUT= work.SASCat 
            DATAFILE= "&DataDir.&filenme1" 
            DBMS=XLSX REPLACE
;
RANGE="Full Catalog$A2:AB695";
GETNAMES=YES;
RUN;

* PROC SQL (although data step will work too), select cols, cleanup names;
PROC SQL;
create table work.SASCatalog as
select
'Session Title'n as Title ,
Description as Abstract ,
'Session Type'n as Type ,
Topic ,
Industry ,
'Primary Product'n as PrimaryProduct , 
'Job Role'n as JobRole ,
'Skill Level'n as SkillLevel , 
Day ,
'Start Time'n as StartTime ,
'End Time'n as EndTime ,
Room ,
'Primary Speaker First Name'n as SPKR_Fname ,
'Primary Speaker Last Name'n as SPKR_Lname ,
'Primary Speaker Company'n as SPKR_Company ,
'Primary Speaker Job Role'n as SPKR_JobRole
from work.SAScat
;
quit;

PROC CONTENTS data=work.SASCatalog order=varnum ;
run;
* temporal components Day, StartTime, EndTime are character;

/*********************/
/**** End Program ****/
/*********************/
