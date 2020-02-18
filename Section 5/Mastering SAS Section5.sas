/*  Activating the library created in first section*/
libname libref '/home/ektasg0';

/*CLUSTER ANALYSIS -PROC CLUSTER*/
ods graphics on;
proc cluster data=SASHELP.CARS method=ward ccc pseudo PRINT=20 plots=den(height=rsq);
            var Wheelbase;
            id make;
run; 


/* Importing the dataset */
FILENAME REFFILE '/home/ektasg0/fish_data -training.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=libref.fishdata;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=libref.fishdata; RUN;

/* Variables with larger variances exert a larger influence in calculating the clusters.
In the Fish data set, the variables are not measured in the same units and cannot be
assumed to have equal variance. Therefore, it is necessary to standardize the variables
before performing the cluster analysis. */
proc standard data=libref.fishdata out=Stand mean=0 std=1;
var Height Length1 Width Weight ;
run;

/*cluster analysis -k-means clustering */
proc fastclus data=Stand out=clust
maxclusters=7 maxiter=100;
var Height Length1 Width Weight ;
run;


/* Decision tree Model  */
/* create the stage6 data set  */
data stage6;
format _STNAME_ $14. _STTYPE_ $2. _OUTCOM_ $20. _SUCC_ $14. ;
input _STNAME_ $ _STTYPE_ $ _OUTCOM_ & _SUCC_ $ ;
datalines;
Application     D   Approve loan            Payment
.               .   Deny loan               .
Payment         C   Pay off                 .
.               .   Default                 .
Investigation   D   Order investigation     Recommendation
.               .   Do not order            Application
Recommendation  C   Positive                Application
.               .   Negative                Application
;
run;

/* create the probin data set : Prob6 gives the probability distributions for
 the random events at the chance nodes */
 
 data Prob6;
length _GIVEN_ _EVENT1_ _EVENT2_ $16;
_EVENT1_='Pay off';   _EVENT2_='Default';
_PROB1_=664/700;      _PROB2_=1.0-_PROB1_;
output;
_GIVEN_='Pay off';
_EVENT1_='Positive';   _EVENT2_='Negative';
_PROB1_=570/664;       _PROB2_=1.0-_PROB1_;
output;
_GIVEN_='Default';
_EVENT1_='Positive';   _EVENT2_='Negative';
_PROB1_=6/26;          _PROB2_=1.0-_PROB1_;
output;

/* create the payoff dataset : give the payoff for various scenarios */
data Payoff6(drop=loan);
length _STATE_ _ACT_ $24;
loan=30000;
_ACT_='Deny loan';   _VALUE_=loan*0.08;   output;
_STATE_='Pay off';   _VALUE_=loan*0.08;   output;
_STATE_='Default';   _VALUE_=loan*0.08;   output;
_ACT_='Approve loan';
_STATE_='Pay off';   _VALUE_=loan*0.15;   output;
_STATE_='Default';   _VALUE_=-1.0*loan;   output;
run;


/* decision tree  */
/* -- define title                                  -- */
title 'Loan Grant Decision';
   /* -- PROC DTREE statements                         -- */
proc dtree
stagein=Stage6 probin=Prob6 payoffs=Payoff6
summary target=investigation nowarning;
 modify 'Order investigation' reward -500;
evaluate;
summary / target=Application;
treeplot / linka=1 linkb=2 
symbold=2 symbolc=1 symbole=3 compress name="dt4";
run;

/* result indicate it is optimal to do the following 
: The loan officer should order the credit investigation and approve the loan 
application if the investigator gives the applicant a positive recommendation. 
On the other hand, he should deny the application if a negative recommendation 
is given to the applicant.
 */
/* Furthermore, the loan officer should order a credit investigation if the cost for
 the investigation is less than   $3.725- $2.726 = $999  */
 
/*The LINKA=, LINKB=, SYMBOLD=, SYMBOLC=, and SYMBOLE= specifications in the
 TREEPLOT statement tell PROC DTREE how to use SYMBOL definitions to draw the 
 decision tree. */