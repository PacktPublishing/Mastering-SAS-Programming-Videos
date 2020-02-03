/*  Activating the library created in first section*/
libname libref '/home/ektasg0';

/*IMPORTING INDCITYINFO DATASET  */
FILENAME REFFILE '/home/ektasg0/indcityinfo.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=libref.indcityinfo;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=libref.indcityinfo; RUN;

/* RETREIVING DATA FROM SINGLE TABLE*/
PROC SQL;
select * from libref.indcityinfo;
quit;

proc sql;
title 'Cities of India';
select cityname from libref.indcityinfo;
quit;

proc sql;
title 'Cities of India';
select cityname, state from libref.indcityinfo;
quit;

proc sql;
title 'Cities of India';
select distinct state from libref.indcityinfo;
quit;

proc sql;
describe table libref.indcityinfo;
quit;

/*create new columns containing text or calculated values */
proc sql;
title 'Cities of India';
select 'population of' , cityname ,'is', population from libref.indcityinfo;
quit;

proc sql;
title 'Cities of India';
select 'population of' , cityname ,'in thousands', (population/1000) as roundoffpop from libref.indcityinfo;
quit;

/*Sorting  -Order by clause  */
proc sql;
title 'Cities of India';
select cityname, population from libref.indcityinfo 
order by population desc;
quit;

proc sql;
title 'Cities of India';
select * from libref.indcityinfo 
order by state , cityname;
quit;

/*Retreiving rows satisfying specific condition - Where clause*/
proc sql;
select * from libref.indcityinfo 
where state = 'UttarPradesh';
quit;

proc sql;
select * from libref.indcityinfo where population>=1000000 order by population desc;
quit;

/* Using Aggregate Functions */
proc sql;
select state, population, max(population) as maxpopulation from libref.indcityinfo 
order by population desc;
quit;

proc sql;
title 'percentage of state population in India';
select state, population,  (Population / sum(Population) * 100) as Percentage 
from libref.indcityinfo 
order by population desc;
quit;

proc sql;
   title 'Number of States in the Table';
   select count(distinct State) as Count from libref.indcityinfo;
quit;

/*Grouping Data - Group by */
proc sql;
select state, sum(population) as totalpop format=comma16. from libref.indcityinfo
where population>50000 group by state;
run;

/*having condition  */
proc sql;
title 'City of each state having max population';
select * from libref.indcityinfo group by state
having population = max(population);
run;

/*  CREATING A NEW TABLE */
proc sql;
create table newtable as 
select state, sum(population) as totalpop format=comma16. from libref.indcityinfo
where population>50000 group by state order by totalpop;
quit;

/* JOINS */
FILENAME REFFILE '/home/ektasg0/Electronic_Order.xlsx';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=libref.electronic_order;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=libref.electronic_order; RUN;

FILENAME REFFILE '/home/ektasg0/Electronic_Custinfo.xlsx';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=libref.electronic_custinfo;;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=libref.electronic_custinfo;; RUN;

/* INNER JOIN */
proc sql;
create table inner_join as
select * from libref.electronic_order as e , libref.electronic_custinfo as c
where e.order_id = c.order_id;
quit;

/* Inner join with only few preferred columns */
proc sql;
create table inner_join as
select c.customer_id, c.customer_name, e.order_id, e.order_date, e.ship_mode
 from libref.electronic_order as e , libref.electronic_custinfo as c
where e.order_id = c.order_id;
quit;

/* INNER JOIN using inner join and ON keywords*/
proc sql;
create table inner_join as
select * from libref.electronic_order as e inner join libref.electronic_custinfo as c
on e.order_id = c.order_id;
quit;

/* OUTER JOINS */
/* Left Outer Join */
proc sql;
create table left_join as
select * from libref.electronic_order as e left join libref.electronic_custinfo as c
on e.order_id = c.order_id;
quit;

/* Right Outer Join  */
proc sql;
create table right_join as
select * from libref.electronic_order as e right join libref.electronic_custinfo as c
on e.order_id = c.order_id;
quit;

/* Full Outer Join */
proc sql;
create table full_join as
select * from libref.electronic_order as e full join libref.electronic_custinfo as c
on e.order_id = c.order_id;
quit;

/*UNION  */
/* CREATING TWO TABLES ONE and TWO */
proc sql;
CREATE TABLE libref.one AS
SELECT name, age, height
FROM sashelp.class
WHERE age<14 and LENGTH(name)<6
ORDER BY age, RANUNI(1);
quit;

proc sql;
CREATE TABLE libref.two AS
SELECT name, weight, age
FROM sashelp.class
WHERE age<14 and LENGTH(name)>5
ORDER BY age, RANUNI(1)
; 
quit;

/*OUTER UNION  */
/*Common (that is, like-named) columns (NAME and AGE) have been aligned.
That is a consequence of the CORRESPONDING option. The mismatched columns (HEIGHT
and WEIGHT) also appear, with missing values for the cells which have no “ancestry” in the
source tables; that is characteristic of an OUTER UNION  */
proc sql;
CREATE TABLE concat AS
SELECT * FROM libref.one
OUTER UNION CORRESPONDING
SELECT * FROM libref.two
; 
quit;


/* UNION ALL -This yields the form of UNION which most closely resembles the OUTER UNION
CORRESPONDING.The data from the two AGE columns are properly combined in a single column, 
even though AGE is the second column in ONE and the third column in TWO. 
Each source also had an additional column (HEIGHT in ONE and WEIGHT in TWO), 
but these are shed by the UNION operator because their names do not match.
The ALL keyword prevents the UNION operator from eliminating duplicate row*/
proc sql;
CREATE TABLE unionallcorr AS
SELECT * FROM libref.one
UNION ALL CORRESPONDING
SELECT * FROM libref.two
; 
quit;

/* Eliminating corresponding -  the columns were aligned by position rather than by name; 
the second column in table TWO is WEIGHT and the third column is AGE. Here  the column naming 
was consistent whereas the column ordering was not.*/
proc sql;
CREATE TABLE unionall AS
SELECT * FROM libref.one
UNION ALL 
SELECT * FROM libref.two
; 
quit;

/*Fixing the above problem by selecting specfic columns  */
proc sql;
CREATE TABLE unionall AS
SELECT name, age
FROM libref.one
UNION ALL
SELECT name, age
FROM libref.two
; 
quit;

/* UNION*/
proc sql;
CREATE TABLE concat_union AS
SELECT name, age FROM libref.one
UNION 
SELECT name,age FROM libref.two
; 
quit;

/* INTERSECT - whereas the UNION operator accepts rows which appear in either
source, INTERSECT accepts only those rows which appear in both.*/
/* create table abc */
proc sql;
CREATE TABLE abc (variable char(2));
quit;

/* Insert rows in table abc */
proc sql;
insert into abc 
set variable = 'a'
set variable = 'a'
set variable = 'b'
set variable = 'b'
set variable = 'b'
set variable = 'c'
set variable = 'c';
quit;

/* create table ab */
proc sql;
CREATE TABLE ab (variable char(2));
quit;

/* Insert rows in table ab */
proc sql;
insert into ab 
set variable = 'a'
set variable = 'a'
set variable = 'a'
set variable = 'b'
set variable = 'b'
;
quit;

/* Intersect All - displays rows appearing in both with duplicates since ALL is mentioned */
proc sql;
CREATE TABLE intersectall AS
SELECT * FROM abc
INTERSECT ALL
SELECT * FROM ab
; 
quit;

/* Intersect - duplicates are removed. */
proc sql;
CREATE TABLE intersect AS
SELECT * FROM abc
INTERSECT
SELECT * FROM ab
; 
quit;

/* EXCEPT -EXCEPT’s accretion rule is to preserve rows which appear in the first operand
(SELECT clause), but not in the second.  */
proc sql;
CREATE TABLE exceptall AS
SELECT * FROM abc
EXCEPT ALL
SELECT * FROM ab
; 
quit;

/*Removing ALL - duplicates are removed  */
proc sql;
CREATE TABLE except AS
SELECT * FROM abc
EXCEPT 
SELECT * FROM ab
; 
quit;

/*VIEWS*/
/*Creating Views  */
proc sql;
   title 'Current Population and CrimeRate Information for States of India';
   create view stateinfo as
   select state,
          sum(population) as totpop  format=comma15. label='Total Population',
          sum(crimerate) as totcrimerate format=comma15. label='Total CrimeRate'
      from libref.indcityinfo
      group by state;

   select * from stateinfo;
   quit;

/*The DESCRIBE VIEW statement writes a description of the PROC SQL view to the SAS log.   */
proc sql;
   describe view stateinfo;
   quit;
   
/* IN-LINE VIEWS
An in-line view is a query that appears in the FROM clause. 
An in-line view produces a table internally that the outer query uses to select data. 
Unlike views that are created with the CREATE VIEW statement, in-line views are not 
assigned names and cannot be referenced in other queries or SAS procedures as if they were 
tables. An in-line view can be referenced only in the query in which it is defined.*/

proc sql;
   title 'States With Population LT Uttar Pradesh';
   select w.state,w.cityname, w.Population format=comma15., c.Totpop 
      from (select sum(population) as Totpop format=comma15.
	                 from libref.indcityinfo
			       where state = 'UttarPradesh') as c,
           libref.indcityinfo as w
	    where w.population lt c.Totpop and w.state not in('UttarPradesh')
	    group by w.state;
quit;

/*DICTIONARY -View a Summary of a DICTIONARY Table  */
proc sql; 
   describe table dictionary.indexes;
quit;
   
/* View a Subset of a DICTIONARY Table  */
 proc sql;
   title 'Subset of the DICTIONARY.INDEX View';
   title2 'Rows with Column Name equal to STATE';
   select * from dictionary.indexes
      where name = 'STATE';
quit;