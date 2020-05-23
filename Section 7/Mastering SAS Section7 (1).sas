/*  Activating the library created in first section*/
libname libref '/home/ektasg0';

/*TimeSeries - PROC TIMESERIES */
proc sort data= LIBREF.ECOMMERCE;
	BY customer_name order_date;
run;


PROC TIMESERIES DATA= LIBREF.ECOMMERCE
	OUT= Ecommerce_monthly;
	BY CUSTOMER_NAME;
	ID order_date INTERVAL=month accumulate=total;
	VAR Sales Profit;
Run;

/*Reading Date and DateTime Values */
%put today is %sysfunc(today());

Data informat;
Input date1 anydtdte20.;
Format date1 date10.;
Datalines;
01052020
010520
May20
;
Run;

PROC PRINT;
RUN;


Data format;
Set informat;
date = %sysfunc(today());
date_format1=date;
date_format2=date;
date_format3=date;
Format date_format1 monyy7. date_format2 date9. date_format3 WEEKDATX23.;
RUN;

PROC PRINT;
RUN;


/* ARIMA Model */
/* FORECAST ONLY WITH P AND Q , NO D  */
proc arima data = LIBREF.ELECTRONIC_ORDER;
identify var = Sales nlag = 24 ;
run;

/*Making Series Statiionary */
proc arima data = LIBREF.ELECTRONIC_ORDER;
identify var = Sales(1) nlag = 24 ;
run;

/*perform Estimation*/
proc arima data = LIBREF.ELECTRONIC_ORDER;
identify var = Sales(1) nlag = 23 ;
estimate p = 1 ;
run;

/* perform forecasting */
proc arima data = LIBREF.ELECTRONIC_ORDER;
identify var = Sales(1) nlag = 22 ;
estimate p = 1  q = 1;
forecast lead = 12 interval = month id = order_date out = results;
run;


