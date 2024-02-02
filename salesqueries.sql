-- create database sales_data
create database sales_data;

-- set sales_data as default database
use sales_data;

-- create table catefories
CREATE TABLE Categories
(      
    CategoryID INTEGER PRIMARY KEY AUTO_INCREMENT,
    CategoryName VARCHAR(25),
    Description VARCHAR(255)
);
 
 -- create table customers
 CREATE TABLE Customers
(      
    CustomerID INTEGER PRIMARY KEY AUTO_INCREMENT,
    CustomerName VARCHAR(50),
    ContactName VARCHAR(50),
    Address VARCHAR(50),
    City VARCHAR(20),
    PostalCode VARCHAR(10),
    Country VARCHAR(15)
);

-- create table employees
CREATE TABLE Employees
(
    EmployeeID INTEGER PRIMARY KEY AUTO_INCREMENT,
    LastName VARCHAR(15),
    FirstName VARCHAR(15),
    BirthDate DATETIME,
    Photo VARCHAR(25),
    Notes VARCHAR(1024)
);

-- create table shippers
CREATE TABLE Shippers(
    ShipperID INTEGER PRIMARY KEY AUTO_INCREMENT,
    ShipperName VARCHAR(25),
    Phone VARCHAR(15)
);

-- create table suppliers
CREATE TABLE Suppliers(
    SupplierID INTEGER PRIMARY KEY AUTO_INCREMENT,
    SupplierName VARCHAR(50),
    ContactName VARCHAR(50),
    Address VARCHAR(50),
    City VARCHAR(20),
    PostalCode VARCHAR(10),
    Country VARCHAR(15),
    Phone VARCHAR(15)
);

-- create table products
CREATE TABLE Products(
    ProductID INTEGER PRIMARY KEY AUTO_INCREMENT,
    ProductName VARCHAR(50),
    SupplierID INTEGER,
    CategoryID INTEGER,
    Unit VARCHAR(25),
    Price NUMERIC,
	FOREIGN KEY (CategoryID) REFERENCES Categories (CategoryID),
	FOREIGN KEY (SupplierID) REFERENCES Suppliers (SupplierID)
);

-- create table orders
CREATE TABLE Orders(
    OrderID INTEGER PRIMARY KEY AUTO_INCREMENT,
    CustomerID INTEGER,
    EmployeeID INTEGER,
    OrderDate DATETIME,
    ShipperID INTEGER,
    FOREIGN KEY (EmployeeID) REFERENCES Employees (EmployeeID),
    FOREIGN KEY (CustomerID) REFERENCES Customers (CustomerID),
    FOREIGN KEY (ShipperID) REFERENCES Shippers (ShipperID)
);

-- create table orderdetails
CREATE TABLE OrderDetails(
    OrderDetailID INTEGER PRIMARY KEY AUTO_INCREMENT,
    OrderID INTEGER,
    ProductID INTEGER,
    Quantity INTEGER,
	FOREIGN KEY (OrderID) REFERENCES Orders (OrderID),
	FOREIGN KEY (ProductID) REFERENCES Products (ProductID)
);

-- Retrieve all customer information from the Customers table.
select *from customers;

-- List all product categories from the Categories table.
select 
	distinct categoryname as product_categories 
from categories
order by product_categories asc;

-- Count the total number of orders in the Orders table.
select 
	count(*) as total_orders 	
from orders;

-- Find the total number of products in the Products table.
select
	distinct count(productname) as total_products 
 from products;

-- Show the names and prices of all products from the Products table.
select 
		distinct productname,price
from products
order by price;

-- Retrieve customer names and addresses for customers in the 'USA' from the Customers table.
select 
	customername,address
from customers
where country='USA'
order by customername;

-- Display the top 5 products with the highest prices from the Products table.
select 
	productname,price
from products
order by price desc
limit 5;

-- calculate total sales
select 
	sum(price*quantity) as total_sales
from products
join orderdetails 
on products.productid=orderdetails.ProductID;

-- Calculate the average price of products in each category.
select 
	c.categoryname,avg(p.price) avg_price_per_product
from categories c
join products p 
on c.categoryID=p.categoryID
group by c.CategoryName;

-- List customers who have placed more than 5 orders.
select 
	c.customername,c.CustomerID,count(*) as order_count
from customers c
join orders o
on o.CustomerID=c.customerid
group by customername,c.CustomerID
having order_count>=5;

-- determin the revenue for every month
select 
	year(oo.orderdate) as year,
    monthname(oo.orderdate) as month,
    sum(p.price*o.quantity) revenue
from products p
join orderdetails o
on p.productid=o.productid
join orders oo
on o.OrderID=oo.OrderID
group by year,month
order by year asc,field(month,'january','february','march','april','may','june','july','august','september','october','november','december');

-- Identify top 3 employees with the highest number of orders.
select 
	concat(e.firstname,' ',e.lastname) as employee_name,
	count(*) as total_orders
from employees e
join orders o
on e.EmployeeID=o.employeeid
group by employee_name
order by total_orders desc
limit 3;

-- Find the product category by popularity.
select 
	distinct c.categoryname,
    sum(od.quantity) as quantity_sold
from categories c
join products p
on c.CategoryID=p.CategoryID
join orderdetails od
on p.ProductID=od.ProductID
group by c.categoryname
order by quantity_sold desc;

-- Calculate the average order value.
select
	distinct count(*) as total_orders,
    avg(p.price) as average_order_value
from orderdetails od
join products p
on od.ProductID=p.ProductID;
    
 -- List customers who have not placed any orders   
select 
	c.customername from customers c
left join orders o
on c.CustomerID=o.CustomerID
where o.OrderID is null;

-- Revenue by each category.
select 
	 c.categoryname,sum(p.price*od.quantity) as sum
from categories c
join products p 
on c.CategoryID=p.CategoryID
join orderdetails od
on p.ProductID=od.ProductID
group by c.CategoryName;




