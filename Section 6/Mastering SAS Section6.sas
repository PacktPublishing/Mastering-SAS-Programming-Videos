/*  Activating the library created in first section*/
libname libref '/home/ektasg0';

/*Simple linear regression model */
proc reg data=libref.electronic_order;
model sales=profit;
run;

/*Multiple linear regression model */
proc reg data=libref.electronic_order;
model sales=profit quantity ;
run;

/* importing Regression dataset */
FILENAME REFFILE '/home/ektasg0/regression data.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=LIBREF.REGRESSION;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=LIBREF.REGRESSION; RUN;

/*Model Building  - slope is parameter estimate in the parameter estimates table*/
proc reg data=LIBREF.REGRESSION alpha=0.05 plots(only)=(diagnostics residuals 
        observedbypredicted);
model 'selling price'n='local selling price in hundred o'n 
        'number of bathrooms'n 'area of the site'n 'size of the living space'n 
        'number of garages'n 'number of rooms'n 'number of bedrooms'n 'age in years'n 
        'construction type'n /;
    output out=WORK.Reg_stats p=p_ lcl=lcl_ ucl=ucl_ rstudent = r ;
    run;

/* 1) size of the living space is the significant variable since p value is less than 0.05
2) slope is 13.01668 for this significant variable.
3) positively related.
4) rsquare value is 94% so it meand 94% of the selling price of the house is explained 
by size of the living spcae significant variable. */

/* to remove the outliers obs from data : there is only one obs which is having outlier
as in log there are 27 obs instead of 28 so it means one is deleted  */
data work.reg_stats1;
set work.reg_stats;
if abs(r) > 2 then delete;
run;




/* IMPORT REMISSION FILE  */

FILENAME REFFILE '/home/ektasg0/Remission.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=LIBREF.REMISSION;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=LIBREF.REMISSION; RUN;

/* logistic regression */
proc logistic data=LIBREF.REMISSION;
model Remiss(event='1')=Cell Smear Infil Li Blast Temp / link=logit technique =fisher;
output out=WORK.Logistic_stats predicted=pred_ lower=lcl_ upper=ucl_ / 
alpha=0.05;
run;

/* 1) Li is significant variable since its p value <0.05
2) Slope of Li is 0.7056
3)  1 unit increase in Li increases the log odds of remiss by 0.7056
4) C STATISTIC  = 93%. It is greater that 70% so it is considered as Good model. 
(c value is in the last table) */