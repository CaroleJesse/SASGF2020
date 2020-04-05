
/****************************************************************************
1_prg_SASliterals.sas
SAS Global Forum 2020, paper #4801, by Carole Jesse
Uses BASE SAS 

Using the date/time of SASGF2020 paper #4801 to understand: 
SAS literals for date, time and datetime
SAS formats for date, time and datetime
****************************************************************************/

/* Create a dataset related to date/time of SASGF2020 paper #4801 */
/* DATA STEP 1 */
data work.SASGF2020_4801;
 Date='01APR2020'd;
 Time='10:00:00't; /* 24-hour clock! 10 PM would be 22:00:00 */
 DateTime='01APR2020:10:00:00'dt;
run;

ods output Position=work.DS1_contPosition;
PROC CONTENTS data=work.SASGF2020_4801 order=varnum;
    run;
ods output close;

title1 "DATA STEP 1: work.SASGF2020_4801";
title2 "PROC CONTENTS";
PROC PRINT data=work.DS1_contPosition(drop=Member) noobs;
run;
title1;
title2 "PROC PRINT";
PROC PRINT data=work.SASGF2020_4801 ;
run;
title2;


/* Create a dataset related to date/time of SASGF2020 paper #4801 */
/* Apply SAS F-ormats at data set creation */
/* DATA STEP 2 */
data work.SASGF2020_4801F;
  Date='01APR2020'd;
  Time='10:00:00't;
  DateTime='01APR2020:10:00:00'dt;
  format  Date YYMMDDp10.  Time TIMEAMPM8.  DateTime DATETIME19.;
run;
ods output Position=work.DS2_contPosition;
PROC CONTENTS data=work.SASGF2020_4801F order=varnum;
    run;
ods output close;

title1 "DATA STEP 2: work.SASGF2020_4801F";
title2 "PROC CONTENTS";
PROC PRINT data=work.DS2_contPosition(drop=Member) noobs;
run;
title1;
title2 "PROC PRINT";
PROC PRINT data=work.SASGF2020_4801F ;
run;
title2;
/*********************/
/**** End Program ****/
/*********************/