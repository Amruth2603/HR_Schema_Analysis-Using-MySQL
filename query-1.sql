USE classicmodels;

## Simple select statement ---------------------

SELECT * FROM employees; -- returns all the rows and columns of Employees table
SELECT firstName, lastName, Email FROM employees; -- returns only the named colums of Employees table
SELECT firstName AS 'First Name', LASTNAME AS 'Last Name', Email FROM employees; -- returns only the named colums of Employees table. Created an alias for field name
SELECT T1.firstName, T1.lastName FROM employees AS T1; -- creating an alias "T1" of the table. 

# Q. Display only the unique values from the column reportsto. (7 rows)
select distinct(reportsto) from employees;
# Q. Display the number of records in the employees table. 
select count(*) from employees;

## ORDER BY Clause ------------------------------

# Q. Display all the rows and columns of employees table, sort the records in increasing order based on Firstname. (23 rows)
select * from employees order by firstname;
# Q. Display all the records from employees table, sort the records in decreasing order based on officecode and increasing order based on reportsto (23 rows)
select * from employees order by officecode desc ,reportsto asc;

## Filtering data -------------------------------

# Q. Display all the records from employees table where officecode is 1. (6 rows)
select * from employees where officecode = 1;

# Q. Display the records where jobtitle belongs to the sales department. (19 rows)
select * from employees where jobTitle like '%sales%';

# Q. Display the records where jobtitle starts with letter 's' and ends with 'p' (17 rows)
select * from employees where jobtitle like "s%p";

# Q. Display the records where officeode must be greater than 1 and reportsto as '1102' (6 rows)
select * from employees where officecode >1 and reportsTo like '1102';

# Q. Display those records where officecode greater than 1 or reports as '1102' (17 rows)
select * from employees where officecode >1 or reportsTo like '1102';

# Order Table::-
# Q. Display the records from orders table where status is 'shipped' or 'In process' and sort the records in increasing order based on customer number. (309 rows)
select * from orders where status like 'shipped' or status like 'In process' order by customernumber;

# Q. Display the records where status must be 'shipped' or 'In process' and customernumber as 119. (4 rows)
select * from orders where customernumber = 119 and (status like 'shipped' or status like 'In process');

## Customers table::-
# Q. Display the records from customers table expect the records where the country is like 'France' and 'Norway' and creditlimit is lesser than 1000000 (23 rows)
select * from customers where country not in ('France' , 'Norway') and not creditLimit < 100000;

# Q. Display the records from employees table where officode is between 1 and 3.
select * from employees where officeCode between 1 and 3;

# Q. Display the empolyees records where officecode is missing.
select * from employees where officecode like '';
# Q. Display the customers details where country like 'Spain' and "Australia' sort
--  the records in increasing order and display only 5 rows starting from the second rows.
select * from customers where country in ('Spain','Australia') order by country limit 5 offset 1;

# Grouping Data ---------------------------
# GROPU BY is used to create summary rows by values of columns or expressions.
# Each group returns one row, thus reduces the number of rows in rowset.
# This is generally used along with aggregate functions list SUM, AVG, MAX, MIN and COUNT.
# This clause appears after the WHERE clause.

SELECT reportsTo FROM employees GROUP BY reportsTo; 

# Q. Display the count of orders against each customer from orders table. (98 rows)

select customername,count(ordernumber) as Total_Orders from orders as a
join customers as b using (customernumber) 
group by customername;

# Q. Display the count of orders against each customer and for each status from orders table where status is like 'shipped' and 'In process' (104 rows)
select customernumber,count(ordernumber) as Total_Orders, status from orders 
where status in ('Shipped','In Process')  group by customerNumber, status;
 
# Q. Display the count of orders against each customer and for each status from orders table where status is like 'shipped' and 'In process', also sort the customernumber in ascending order. (104 rows)
select customernumber,count(ordernumber) as Total_Orders, status from orders 
where status in ('Shipped','In Process')  group by customerNumber, status order by customerNumber; 


# HAVING Clause ----------------
# Generally used along with GROUP BY clause to filter rows retuned by a GROUP BY clause
# Can also use HAVING clause to specify a filter on the SELECT statement when used without a GROUP BY clause

SELECT * FROM employees HAVING officeCode = 1; -- use HAVING just like a WHERE clause

# Q. Display the sum of the amount as 'Total Payout' for each customer where 
-- sum of amount should be greater than 125000, also sort the sum of amount in decreasing order. (12 rows)

select customernumber,sum(priceeach) as Total_Payout from orderdetails 
 join orders using (ordernumber) group by customernumber having total_payout >125000 
 order by total_payout desc;

select customernumber,sum(amount) as Total_Payout from payments
group by customernumber having total_payout >125000 
order by total_payout desc;
## JOINING Tables. ----------------------------
# In RDBMS data, is stored in multiple related tables
# These tables are related via common keys (foreign keys)
# In order to fetch information from these tables joins are required to pull the data from these tables collectively
# A join a way of linking two tables using the value stored in the common columns of the tables

## INNER Join - It checks each row of first table against all the rows of the second table and returns a result when the common columns of both tables have same value
# Q. Display customername, checknumber, paymentdate, and amount from customers and payments tables. (273 rows)

select customername,checknumber,paymentdate , amount from customers 
join payments using (customernumber);

## LEFT Join - In a left join, table on the left returns all the rows and the table on right returns rows when the common columns of both tables have same value. NULL is returned for unmatching rows
# Q. Perform left join on the tables offices and employees.
select * from offices 
left join employees using (officecode);

## Right Join - In a right join, table on the right returns all the rows and the table on left returns rows when the common columns of both tables have same value. NULL is returned for unmatching rows
# Q. Perform right join on the tables customers and employees.
select * from customers as a 
right join employees as b on a.salesrepemployeenumber = b.employeeNumber;


## CROSS Join - 
# This returns a cartesian product of the two tables. If table#1 has m rows and table#2 has n rows, then the cross join will return m*n rows.
# If we apply a Where clause with cross join, then it works as an INNER join

select * from customers as a 
cross join employees as b on a.salesrepemployeenumber = b.employeeNumber;


## SELF Join
# A self join is done to either compare a row with another row or to compare the hierarchal data
# When a self join is done, the table is aliased so as to provide a distinction to the two references of a table

select * from offices as a 
join offices b;

SELECT a.employeenumber,a.firstname as manager, 
b.employeenumber,b.firstname as team FROM EMPLOYEES as a join 
employees as b
where b.reportsTo = a.employeenumber;
;
































































