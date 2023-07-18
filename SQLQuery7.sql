-- b)
select e.LastName
from Employees e
where not exists(select * from Orders o 
where (ShipCountry='Poland' OR ShipCountry='France') and e.EmployeeID=o.EmployeeID)
	and exists(select * from Orders k
		join [Order Details] od on k.OrderID=od.OrderID
		join Products p on p.ProductID = od.ProductID
	where p.ProductName like '%D%')
order by e.LastName

-- e)
Select e.EmployeeID, e.FirstName, e.LastName, sum(case when year(o.OrderDate)=1996 then 1 else 0 end) r96, sum(case when year(o.OrderDate)=1997 then 1 else 0 end) r97, sum(case when year(o.OrderDate)=1998 then 1 else 0 end) r98
from Employees e
	join Orders o on e.EmployeeID = o.EmployeeID
group by e.EmployeeID, e.FirstName, e.LastName
order by e.EmployeeID asc

-- d)
select top 2 e.EmployeeID, e.FirstName, e.LastName, e.BirthDate, count(o.OrderID) OrdersNumber
from Employees e
	join Orders o on e.EmployeeID = o.EmployeeID
where (month(o.OrderDate)=11 OR month(o.OrderDate)=12) and year(o.OrderDate)=1997
group by e.EmployeeID, e.FirstName, e.LastName, e.BirthDate
having 
	(select count(*) from Orders o where (month(o.OrderDate)=11 OR month(o.OrderDate)=12) and year(o.OrderDate)=1997 and e.EmployeeID = o.EmployeeID) > 
		(select count(*) from Orders o where (month(o.OrderDate)=11 OR month(o.OrderDate)=12) and year(o.OrderDate)=1998 and e.EmployeeID = o.EmployeeID)
order by e.BirthDate

