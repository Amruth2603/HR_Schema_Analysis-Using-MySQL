
## SQL Revision Session - DAY 2


## Subquery and Window Functions :::::------------------------


# Subquery
# Sub Query / Inner Query
# Sub Query / Inner Query
# Sub query is a query which is nested in another query
# In MySQL it is called inner query
# It can be used along with the FROM and WHERE clause

## HR SCHEMA
-- Q1 -- select first_name,last_name whose department_name is accounting;
select * from employees;
select first_name,last_name from employees 
where department_id =  ( select department_id from departments
where department_name like 'accounting');

-- Q2 -- display the names of the employees who work in the department where neena works;
select first_name,last_name from employees where department_id = (select department_id from employees where 
first_name like 'neena');

-- Q3 -- display the name of the employees working in accounts and finance departments;
select first_name, last_name from employees 
where department_id = (select department_id from departments
where department_name in ("accounts","finance")); 	

-- Q4 -- to display the names of the employees whose salary is less than the salaries of
--  all the people working in department 60.
select first_name from employees where salary < (select sum(salary) from employees where department_id =60);

-- Q5 to list the names of the employees working in seattle. 
select first_name, last_name from employees where department_id in (select department_id from departments 
where location_id = (select location_id from locations where city like 'seattle'));

select first_name,last_name from employees 
join departments using(department_id)
join locations using(location_id)
where city like 'seattle';
-- Q6 to display the names of the employees who work in same department as 'gerald' and have the same designation as him:
select first_name,last_name from employees where department_id = (select department_id from employees where 
first_name like 'gerald') and job_id = (select job_id from jobs where job_title = (select job_title from 
jobs where job_id = (select job_id from employees where first_name like 'gerald')));



-------------------------------------------------------------------------------------------------------------------
# Windows functions - Over(), along with "partition by", "order by" and from clause ----------------------

# Classicmodels schema 
-- Q. Write a query to fetch the number of orders placed by each customer.
use classicmodels;
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
select o.*, 
    count(o.orderNumber) OVER(partition by o.customerNumber) as "Order Count", 
    sum(quantityOrdered * priceEach) over(partition by o.orderNumber) as Bill_Amount, 
	count(orderNumber) as Items, 
    sum(quantityOrdered * priceEach) Over(partition by CustomerNumber) as "Total_Orders_Value",
	min(quantityOrdered * priceEach) Over(partition by CustomerNumber) as "Min_Order_value",
	max(quantityOrdered * priceEach) Over(partition by CustomerNumber) as "Max_Order_value"
	from orders o 
    join orderdetails using(OrderNumber)
	group by orderNumber;




select o.*, 
    count(o.orderNumber) OVER(partition by o.customerNumber) as "Order Count", 
    sum(od.quantityOrdered * od.priceEach) over(partition by o.orderNumber) as Bill_Amount, 
	count(od.orderNumber) as Items, 
    sum(od.quantityOrdered * od.priceEach) Over(partition by CustomerNumber) as "Total_Orders_Value",
	min(od.quantityOrdered * od.priceEach) Over(partition by CustomerNumber) as "Min_Order_value",
	max(od.quantityOrdered * od.priceEach) Over(partition by CustomerNumber) as "Max_Order_value"
	from orders o, orderdetails od
	Where o.orderNumber = od.OrderNumber
	group by orderNumber
	order by customerNumber, OrderNumber;




-- Q. Write a query to fetch the creditlimit for each customer
/*
such as
	i. The customer number
	ii. The customer name
    iii. The credit limit for each customer with a credit limit greater than 0
    iv. The credit limits of the next and previous customers in the list ordered by credit limit
    v. The credit limits of the first and last customers in the ordered list

# Value functions lead(), lag(), first_value(), last_value()
*/ 

select 
	customerNumber, 
	CustomerName, 
    creditlimit, 
	lead(creditlimit) Over() as CL_Lead, 
	lag(creditlimit) Over() as CL_Lag, 
	first_value(creditlimit) over() as CL_First_value,
	last_value(creditlimit) over() as CL_Last_value
from customers 
where creditlimit > 0 
order by creditlimit;
 







-- Q. Write a query to retrieve order and order detail information, 
-- along with various aggregated metrics such as order count, bill amount, total order value, minimum and maximum order values, row count, 
-- and various ranking measures (order rank, dense rank, percent rank, cumulative distance, and percentile) 
-- for each customer and order, sorted by customer number and order date?
/*
such as 
	vii. "Row_Count": A unique row number within each customer's orders.
	viii. "Order_Rank": The rank of each order based on the bill amount.
	ix. "Order_Dense_Rank": The dense rank of each order based on the bill amount.
	x. "Order_Precent_Rank": The percent rank of each order based on the bill amount, relative to the customer number.
	xi. "Cumulative_distance": The cumulative distribution of the bill amount for each order.
	xii. "Order_Percentile": The order percentile using the NTILE function, with a single group in this case.
*/
select o.*,
row_number() over(order by ordernumber) as row_num,
rank() over(order by amount) as new_rank, 
dense_rank() over(order by amount),
percent_rank() over(partition by customernumber order by amount) as percent_ranks,
cume_dist() over(order by amount) as cum_dist,
ntile(1) over(order by amount) as bins
from orders as o 
join payments using(customernumber);



-- Q. Write a query to fetch a list of customers with their credit limits, 
-- along with their respective rank, dense rank, percent rank, and cumulative distribution, 
-- for customers with a credit limit greater than zero, ordered by credit limit?

use classicmodels;
select customername, creditlimit,
rank() over(order by creditlimit) as new_rank ,
dense_rank() over(order by creditlimit) as new_dense_rank,
percent_rank() over(order by  creditlimit) as new_percent_rank,
cume_dist() over(order by creditlimit) as new_cume_dist
from customers 
where creditlimit>0
order by creditlimit;




