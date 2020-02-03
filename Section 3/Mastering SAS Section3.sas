/*  Activating the library created in first section*/
libname libref '/home/ektasg0';

/* to get all automatic system generated variables */
%put _automatic_;


/*Automatic variables */
proc print data = libref.Electronic_order;
where Order_Priority = 'High';
title "status of product orders as of &sysday &sysdate &systime";
run;

/*User Defined Macro Variables */
%LET Order = 'High';
proc print data = libref.Electronic_order;
where Order_Priority = &Order;
TITLE "Sales as of &SYSDAY &SYSDATE";
run;
%put _user_;
%put _ALL_;


/*Macro Functions*/
FILENAME REFFILE '/home/ektasg0/Ecommerce_Dataset.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=libref.Ecommerce;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=libref.Ecommerce; RUN;

options symbolgen;
%let DSN=libref.Ecommerce;
%let var=Sales Profit;
proc means data=&DSN;
title1 "%UPCASE(%SCAN(&VAR,1)) and %UPCASE(%SCAN(&VAR,2)) for %UPCASE(&DSN) channel";
title2 "prior to %sysfunc(year("&sysdate"d)) calendar year";
where year(order_date) <(%sysfunc(year("&sysdate"d)));
var &var;
class Ship_Mode;
run;




/*Macro Programs conditional , Iteartive and Parameter processing*/
%Macro Output(Sales_Amount=);
	%If &Sales_Amount >=200 %then %do;
		Proc Print data=libref.Electronic_order;
		where Sales = &Sales_Amount;
		Run;
	%End;
	%Else %do;
		proc Contents Data=libref.Electronic_order;
		Where Sales = &Sales_Amount;
		Run;
	%End;
%Mend;
%Output(Sales_amount=150);



/*MAcros SQL*/
proc sql noprint;
select distinct Region
into : Regions separated by ','
from libref.Ecommerce ;
quit;
%put Regions=&Regions;
















