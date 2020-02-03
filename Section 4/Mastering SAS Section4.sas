/*  Activating the library created in first section*/
libname libref '/home/ektasg0';

/* INFERENTIAL STATISTIC IS YOUR HYPOTHESIS": TO TEST THE HYPOTHESIS USING SAS*/
DATA aging ;
input days name $ ;
datalines;
8 arun
6 sumit
;
run ;

/*Assume that h0 is mean no of days to deliver product is equal to 6  
here in the result, pvalue is greater than 0.05 so H0 will be accepted*/
proc ttest data = aging h0 = 6 alpha = 0.05;
var days ;
run;

/* USE CLASS AND VAR and output data genertaed in libref known as ecom_out  */
proc means data=libref.Ecommerce;
var sales profit ;
class ship_mode;
output out = libref.ecom_out sum=;
run;


/* ANOVA ANALYSIS : @@ - DOUBLE TRAILING USED TO READ THE SINGLE LINE IN MULTIPLE OBSERVATIONS  */
title ’Nitrogen Content of Red Clover Plants’;
data Clover;
input Strain $ Nitrogen @@;
datalines;
3DOK1 19.4 3DOK1 32.6 3DOK1 27.0 3DOK1 32.1 3DOK1 33.0
3DOK5 17.7 3DOK5 24.8 3DOK5 27.9 3DOK5 25.2 3DOK5 24.3
3DOK4 17.0 3DOK4 19.4 3DOK4 9.1 3DOK4 11.9 3DOK4 15.8
3DOK7 20.7 3DOK7 21.0 3DOK7 20.5 3DOK7 18.8 3DOK7 18.6
3DOK13 14.3 3DOK13 14.4 3DOK13 11.8 3DOK13 11.6 3DOK13 14.2
COMPOS 17.3 COMPOS 19.4 COMPOS 19.1 COMPOS 16.9 COMPOS 20.8
;
RUN;

proc anova;
class strain;
model nitrogen = strain;
run;

proc anova;
class strain;
model nitrogen = strain;
means strain/tukey;
run;


/*proc freq - tells about the number of observations for a particluar variable  */
proc sort data=libref.ecommerce;
by product;
run;

proc freq data=libref.ecommerce;
tables product;
run;

/*  proc univariate - it gives detailed statistics*/
proc univariate data=libref.ecommerce;
var sales;
run;

proc univariate data=libref.ecommerce;
var sales;
histogram sales/normal;
run;

/* proc correlation */
proc corr data=libref.ecommerce;
var sales profit;
run;

/* proc reg */
proc reg data=libref.ecommerce;
model sales=profit;
run;

