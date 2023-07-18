-- 1
select productid, shipcountry, sum(quantity) as TotalQuantity
from orders o join [order details] od on o.OrderID=od.OrderID
where employeeid=2
group by productid, shipcountry
order by 1, 2

-- 2
select e.FirstName as EmployeeName, e.LastName as EmployeeSurname, sum(Quantity) as TotalQuantity
from orders o 
join [Order Details] od on o.OrderID=od.OrderID
join Employees e on e.EmployeeID = o.EmployeeID
where year(o.OrderDate)=1997 and od.productid=(select
productid from products where ProductName='Chocolade')
group by e.FirstName, e.LastName
having sum(Quantity)>=20

-- 3
select p.ProductID, AVG(od.Quantity * 1.0) AvgQuantity, count(od.Quantity) OrdersCount  
from orders o
	join [Order Details] od on o.OrderID = od.OrderID
	join Customers c on c.CustomerID = o.CustomerID
	join Products p on p.ProductID = od.ProductID
where c.Country='Italy'
group by p.ProductID
having avg(od.Quantity)>=20
order by OrdersCount desc

-- 4
select c.CompanyName, p.ProductName, o.OrderDate, sum(od.Quantity)
from Orders o
	join Customers c on c.CustomerID = o.CustomerID 
	join [Order Details] od on o.OrderID = od.OrderID
	join Products p on od.ProductID = p.ProductID
where c.City = 'berlin'
group by c.CompanyName, p.ProductName, o.OrderDate
order by 1, 2, 3

-- 5
select distinct p.ProductID, p.ProductName
from Products p
	join [Order Details] od on p.ProductID = od.ProductID
	join Orders o on od.OrderID = o.OrderID
where o.ShipCountry='france' and year(o.OrderDate) = 1998
order by p.ProductName

-- 6
select c.CustomerID
from Orders o 
	join Customers c on c.CustomerID = o.CustomerID
group by c.CustomerID
having count(c.CustomerID)>=2

except

select distinct c.CustomerID
from Orders o 
	join Customers c on c.CustomerID = o.CustomerID
	join [Order Details] od on od.OrderID = o.OrderID
where od.ProductID in(select productid from Products
	where ProductName like 'ravioli%')

-- 7
select c.CompanyName, od.OrderID, count(p.ProductID) ProductCount
from Orders o
	join Customers c on c.CustomerID = o.CustomerID
	join [Order Details] od on o.OrderID = od.OrderID
	join Products p on p.ProductID = od.ProductID
where c.Country='france'
group by c.CompanyName, od.OrderID
having count(p.ProductID) >= 4


-- 8
select c.CompanyName
from Orders o	
	join Customers c on o.CustomerID = c.CustomerID
group by c.CompanyName
having sum(case when o.ShipCountry='france' then 1 else 0 end) >=5
	and sum(case when o.ShipCountry='belgium' then 1 else 0 end) <= 2

-- 9
select od.ProductID, c.CompanyName, od.Quantity as maxq
from Orders o
	join [Order Details] od on o.OrderID = od.OrderID
	join Customers c on c.CustomerID = o.CustomerID
where od.Quantity >=
(select max(quantity)
	from [Order Details] k
	where k.ProductID = od.ProductID)

select c.CompanyName, zap.ProductName, zap.maxq
from (select p.ProductID, p.ProductName, max(od.Quantity) as maxq
	from Products p join [Order Details] od on od.ProductID=p.ProductID
	group by p.ProductID, p.ProductName) zap
	join [Order Details] od on zap.ProductID=od.ProductID and
		zap.maxq=od.Quantity
	join Orders o on od.OrderID=o.OrderID
	join Customers c on c.CustomerID = o.CustomerID
order by zap.ProductID

-- 10
select EmployeeID, count(OrderID) 
from Orders
group by EmployeeID
having Count(OrderID) >
			(select count(*) from orders)/(select count(*) from Employees) * 1.2 



