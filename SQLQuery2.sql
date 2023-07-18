-- 10
select o.EmployeeID, COUNT(o.OrderID)
from Orders o
group by o.EmployeeID
having COUNT(o.OrderID) >
	(select count(*) from Orders)/(select count(*) from Employees) * 1.2

-- 11
select top 5 od.OrderID, Count(*)
from Orders o join [Order Details] od on o.OrderID=od.OrderID
group by od.OrderID
order by count(od.ProductID) desc

-- 12
select p.ProductID, p.ProductName, 
		sum(case when year(o.OrderDate)=1997 then od.Quantity else 0 end) r97,
		sum(case when year(o.OrderDate)=1996 then od.Quantity else 0 end) r96
from Orders o join [Order Details] od on o.OrderID=od.OrderID
	join Products p on od.ProductID=p.ProductID
group by p.ProductID, p.ProductName
having sum(case when year(o.OrderDate)=1997 then od.Quantity else 0 end) >
	sum(case when year(o.OrderDate)=1996 then od.Quantity else 0 end)

-- 14
create view OrdersTotal as (
	select
	year(OrderDate) as OrderYear, datepart(month, OrderDate) as OrderMonth,
	O.OrderId, O.CustomerID, Cust.CompanyName, Cust.Country as CustomerCountry, Cust.City AS
	CustomerCity,
	O.ShipCountry, O.ShipCity, OD.ProductID, P.ProductName, Cat.CategoryName, OD.UnitPrice,
	OD.Quantity, OD.UnitPrice * OD.Quantity as ProductValue
	from Orders O
	JOIN [Customers] Cust ON O.CustomerID = Cust.CustomerID
	JOIN [Order Details] OD ON OD.OrderID = O.OrderID
	JOIN [Products] P ON P.ProductID = OD.ProductID
	JOIN [Categories] Cat ON Cat.CategoryID = P.CategoryID
) ;

-- 15
select OrderID, ProductID, Quantity, ROW_NUMBER()
	over (order by quantity) as rn
from [Order Details] od

select OrderID, ProductID, Quantity, sum(Quantity)
	over (PARTITION by ProductID) as rn
from [Order Details] od

select OrderID, ProductID, Quantity, ROW_NUMBER()
	over (PARTITION by Quantity order by ProductID) as rn
from [Order Details] od

-- 15
select OrderID, ProductName, CategoryName, ProductValue,
	sum(ProductValue) over (partition by ProductName) as ProdTotalSale,
	sum(ProductValue) over (partition by CategoryName) as CategoryTotalSale
FROM Orders order by ProductName