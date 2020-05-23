/*Activating the library created in first section*/
libname libref '/home/ektasg0';

/*factor analysis*/
proc factor data=libref.electronic_order priors=max rotate=varimax nfactors=2;
   run;
  
   
proc factor data=libref.fishdata priors=smc rotate=varimax nfactors=2;
   run;
   
   
/*Scatterplot*/
Goptions reset=all;
proc gplot data= sashelp.cars;
 plot horsepower*invoice=type;
run;
quit;

/*Line Plot*/
symbol1 interpol=JOIN;
proc gplot data= sashelp.cars;
 plot horsepower*invoice=type;
run;
quit;

Goptions reset=all;
proc gplot data= libref.electronic_order;
 plot sales*quantity=profit;
run;
quit;

symbol1 interpol=JOIN;
proc gplot data= libref.electronic_order;
where order_priority eq 'High';
 plot sales*quantity=profit;
run;
quit;






/*Gchart - block chart*/
proc gchart data=sashelp.cars;
block type / sumvar=invoice;
run;
quit;

/*Gchart - horizontal bar*/
proc gchart data=sashelp.cars;
hbar type / sumvar=invoice;
run;
quit;

/*Gchart - vertical bar*/
proc gchart data=sashelp.cars;
vbar type / sumvar=invoice;
run;
quit;

proc gchart data=sashelp.cars;
vbar3d type / sumvar=invoice;
run;
quit;

/*Gchart -pie chart*/
proc gchart data=sashelp.cars;
pie type / sumvar=invoice;
run;
quit;

proc gchart data=sashelp.cars;
pie3d type / sumvar=invoice;
run;
quit;

/*Gchart -Star Chart*/
proc gchart data=sashelp.cars;
star type / sumvar=invoice;
run;
quit;

/*boxplot*/
proc sort data= LIBREF.electronic_order;
	BY quantity;
run;

/*The INSET statement produces an inset of overall summary statistics. 
The keywords listed before the slash (/) request the minimum, mean, maximum, and 
standard deviation computed over all days. 
The POS=TM option places the inset in the top margin of the plot.*/
proc boxplot data=libref.electronic_order;
   plot sales*quantity;
   inset min mean max stddev /
      header = 'Overall Statistics'
      pos    = tm;
run;

proc boxplot data=libref.electronic_order;
   plot sales*quantity /
   boxstyle = schematic
      horizontal;
   inset min mean max stddev /
      header = 'Overall Statistics'
      pos    = tm;
run;



