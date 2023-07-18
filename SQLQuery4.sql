-- 1
SELECT * FROM orders

-- 2
SELECT * FROM orders
WHERE ShipCountry IN ('Germany', 'Mexico', 'Brazil')

-- 3
SELECT distinct ShipCity FROM orders
WHERE ShipCountry = 'Germany'

-- 4 (1)
SELECT * FROM orders
where OrderDate >= '1996-07-01' AND OrderDate < '1996-08-01'

-- 4 (2)
SELECT * FROM orders
where Month(OrderDate) = 7 AND Year(OrderDate) = 1996

-- 5
SELECT upper(substring(companyName,1,10)) AS CompanyCode FROM Customers

-- 6
SELECT * FROM Orders o
JOIN Customers c on o.CustomerID=c.CustomerID
where Country = 'France'

-- 7
SELECT distinct ShipCountry FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE Country = 'Germany'

-- 8
SELECT o.* FROM Orders o
JOIN Customers c on o.CustomerID = c.CustomerID
WHERE country != shipcountry

-- 9
SELECT * FROM Customers c
WHERE NOT EXISTS (SELECT *
FROM Orders o WHERE c.CustomerID = o.CustomerID)

-- 10
SELECT * FROM Customers c
WHERE NOT EXISTS (SELECT * FROM
Orders o WHERE o.CustomerID=c.CustomerID
AND EXISTS(SELECT * FROM [Order Details] od join
Products p on p.ProductID = od.ProductID where od.OrderID = o.OrderID
and p.ProductName='Chocolade'
))

-- 11
select * from Customers c where exists (select * from
orders o join [order details] od on od.orderid=o.orderid
join products p on p.productid=od.productid where
p.productname='Scottish Longbreads' and
o.customerid=c.customerid)

-- 12
select * from Orders o 
where exists(select * from [order details] od 
join Products p on od.ProductID = p.ProductID
where ProductName='Scottish Longbreads' AND o.OrderID = od.OrderID) AND
NOT EXISTS (select * from [order details] od 
join Products p on od.ProductID = p.ProductID
where ProductName='Chocolade' AND o.OrderID = od.OrderID)

-- 13
select FirstName, LastName
from Employees e 
where exists
(select * from orders o
where customerid='ALFKI' and
e.EmployeeID=o.EmployeeID)

-- 14
select firstname, lastname, companyname, orderdate,
(case when od.orderid is null then 0 else 1 end) as status
from employees e
left join orders o on o.employeeid=e.employeeid
left join [order details] od on o.orderid=od.orderid and
od.productid=(select productid from products where
productname='Chocolade')
left join customers c on c.customerID=o.customerid

-- 15
select p.productname, o.shipcountry, o.orderid, year(orderdate) as rok,
month(orderdate) as miesiac, orderdate from customers c join orders o on
o.customerid=c.customerid
join [order details] od on od.orderid=o.orderid
join products p on od.productid=p.ProductID
where c.country='Germany' and p.productname like '[c-s]%' order by
orderdate desc