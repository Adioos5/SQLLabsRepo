-- 1
update Orders
set EmployeeID=4
where EmployeeID=1

-- 2
update [Order Details]
set Quantity = round(Quantity*0.8, 0)
where OrderID in (select orderID from Orders where OrderDate>'1997-05-15')
	and ProductID = (select ProductID from Products where ProductName='Ikura')
	
-- 3
declare @oid int
set @oid = (select top 1 OrderID
from Orders o
where CustomerID='alfki' and not exists(select *
	from [Order Details] od
	where o.OrderID=od.OrderID and ProductID = (select ProductID
		from Products where ProductName='chocolade')
	)
order by OrderDate desc
)
print @oid 
select @oid 

declare @pid int
set @pid = (select ProductID from Products where ProductName='Chocolade')

insert into [Order Details] values (@oid, @pid,0, 1, 0)

-- 4
-- Zrób sam

-- 5
delete from Customers 
where not exists ( select * 
	from Orders o 
	where o.CustomerID=Customers.CustomerID)

-- sc1

begin transaction

select *
into ArchivedOrders
from Orders
where OrderID=-1

alter table ArchivedOrders
add ArchiveDate datetime

drop table ArchivedOrders

select *, Getdate() as ArchiveDate
into ArchivedOrders
from Orders
where year(OrderDate)=1996

alter table ArchivedOrders
add constraint PK_archOrd primary key (OrderID)

alter table ArchivedOrders
add constraint FK_archOrd_Emp1 foreign key (EmployeeID) 
	references Customers(CustomerID)

alter table ArchivedOrders
add constraint FK_archOrd_Cust foreign key (CustomerID) 
	references Customers(CustomerID)

select *
into ArchivedOrderDetails
from [Order Details]
where OrderID in (select OrderID from ArchivedOrders)

delete from Orders
where year(OrderDate)=1996

delete from [Order Details]
where OrderID in (select OrderID from ArchivedOrders)

commit
