-- 1
select ProductID, ShipCountry, sum(od.Quantity) as TotalQuantity
from orders o join [Order Details] od on o.OrderID=od.OrderID
where o.EmployeeID=2
group by ProductID, ShipCountry 
order by 1, 2

-- 2
select e.EmployeeID, e.FirstName, sum(Quantity) ilosc
from orders o join [Order Details] od on o.OrderID=od.OrderID
	join Employees e on e.EmployeeID=o.EmployeeID
where year(o.OrderDate)=1997 and od.ProductID=(select ProductID 
	from Products
	where ProductName='Chocolade')
group by e.EmployeeID, e.FirstName
having sum(Quantity)>=20

-- 3
select p.ProductID, avg(od.Quantity*1.0) AvgQuantity, count(od.Quantity) OrdersCount
from Orders o 
	join [Order Details] od on o.OrderID=od.OrderID
	join Customers c on c.CustomerID=o.CustomerID
	join Products p on od.ProductID=p.ProductID
where c.Country='Italy'
group by p.ProductID
having avg(od.Quantity*1.0) >= 20
order by OrdersCount desc

-- 4
select c.CompanyName, p.ProductName, o.OrderDate, sum(od.Quantity)
from Customers c join Orders o on c.CustomerID = o.CustomerID
	join [Order Details] od on od.OrderID = o.OrderID
	join Products p on p.ProductID = od.ProductID
where c.City = 'Berlin'
group by c.CompanyName, p.ProductName, o.OrderDate
order by c.CompanyName, p.ProductName, o.OrderDate

-- 6
select distinct p.ProductID, p.ProductName
from Orders o join [Order Details] od on o.OrderID=od.OrderID join Products p on p.ProductID=od.ProductID
where o.ShipCountry='france' and year(o.OrderDate)=1998
order by p.ProductName

-- 7
select c.customerid
from Customers c join Orders o on o.CustomerID=c.CustomerID
group by c.CustomerID
having count(c.customerid)>=2

except 

select distinct c.customerid
from Customers c join Orders o on o.CustomerID=c.CustomerID
	join [Order Details] od on o.OrderID=od.OrderID
where od.ProductID in (select ProductID 
	from Products where ProductName like 'ravioli%')

select *
from Customers c
where not exists (select *
	from Orders o join [Order Details] od on o.OrderID=od.OrderID
		join Products p on od.ProductID=p.ProductID
	where o.CustomerID=c.CustomerID and p.ProductName like 'ravioli%')
	and 2 <= (select count(*) 
		from Orders o
		where o.CustomerID=c.CustomerID)

-- 7
select c.CompanyName, o.OrderID, count(*) productCount
from Orders o join [Order Details] od on o.OrderID=od.OrderID
	join Customers c on c.CustomerID=o.CustomerID
where c.Country='france'
group by c.companyname, o.orderid
having count(*)>=4

select * from [Order Details] where OrderID=10360

-- 8
select c.companyName
from Orders o join Customers c on o.CustomerID = c.CustomerID
group by c.CompanyName
having sum(case when o.shipCountry='france' then 1 else 0 end) >= 5
	and sum(case when o.shipCountry='belgium' then 1 else 0 end) <= 2

select c.companyName
from Orders o join Customers c on o.CustomerID = c.CustomerID
group by c.CompanyName, c.CustomerID
having sum(case when o.shipCountry='france' then 1 else 0 end) >= 5
	and sum(case when o.shipCountry='belgium' then 1 else 0 end) <= 2

select c.companyName
from Customers c
where exists(select *
	from Orders o 
	where c.CustomerID= o.CustomerID
	group by o.ShipCountry
	having sum(case when o.shipCountry='france' then 1 else 0 end) >= 5
		and sum(case when o.shipCountry='belgium' then 1 else 0 end) <= 2)

-- 9
select * from Products

select c.CompanyName, zap.ProductName, zap.maxq
from (select p.ProductID, p.ProductName, max(od.Quantity) as maxq
	from Products p join [Order Details] od on od.ProductID=p.ProductID
	group by p.ProductID, p.ProductName) zap 
	join [Order Details] od on zap.ProductID=od.ProductID and
		zap.maxq=od.Quantity
	join Orders o on od.OrderID=o.OrderID
	join Customers c on c.CustomerID=o.CustomerID
order by zap.ProductID

select od.ProductID, c.CompanyName, od.Quantity as maxq
from Orders o join [Order Details] od on o.OrderID=od.OrderID
	join Customers c on c.CustomerID=o.CustomerID
where od.Quantity >=
(select max(quantity)
	from [Order Details] k
	where k.ProductID=od.ProductID)