Select * from Orders
Select * from Products

-- #1	Przypisanie wszystkich zam�wie� nadzorowanych
--		przez pracownika nr 1 pracownikowi nr 4
UPDATE Orders
set EmployeeID = 4
where EmployeeID = 1


-- #2	Dla wszystkich zam�wie� z�o�onych po 15/05/1997 dla
--		produktu Ikura nale�y zmniejszy� ilo��.
--		Ilo�� nale�y zmniejszy� o 20% i zaokr�gli� do najbli�szej liczby ca�kowitej

UPDATE [Order Details]
set Quantity = ROUND(0.8 * Quantity, 0)
where ProductID = (	select ProductID from Products p
					where p.ProductName = 'Ikura')
and OrderID in (	select OrderID from Orders
					where OrderDate > '1997-05-15')

-- #3	1. Znajd� identyfikator ostatniego zam�wienia z�o�onego przez
--		klienta ALFKI, kt�re nie obejmuje produktu Chocolade
--		2. Znajd� identyfikator produktu Chocolade
--		3. Dodaj Chocolade do listy produkt�w zam�wionych w ramach
--		tego zam�wienia, z ilo�ci� r�wn� 1

declare @oid int
set @oid = (	select top 1 OrderID from Orders o
				where CustomerID = 'ALFKI'
				and not exists (	select * from [Order Details] od
									where od.OrderID = o.OrderID
									and od.ProductID = (select ProductID from Products
													where ProductName = 'Chocolade'))
				order by OrderDate desc	)

print @oid

declare @pid int
set @pid = (	select ProductID from Products
				where ProductName = 'Chocolade')

print @pid

INSERT into [Order Details]
VALUES (@oid, @pid, 0, 1, 0)

select * from [Order Details]
where ProductID=@pid
and OrderID = @oid


-- #4	Dodaj produkt Chocolade do wszystkich zam�wie� z�o�onych
--		przez klienta ALFKI, kt�re jeszcze nie zawieraj� tego produktu

declare @pid2 int
set @pid2 = (	select ProductID from Products
				where ProductName = 'Chocolade')

INSERT INTO [Order Details]
SELECT OrderID, @pid2, 0, 1, 0 from Orders o
where CustomerID = 'ALFKI'
and not exists (	select * from [Order Details] od
					where od.OrderID = o.OrderID
					and od.ProductID = (select ProductID from Products
										where ProductName = 'Chocolade'))

select * from [Order Details]

-- #5	Usu� dane wszystkich kontrahent�w, kt�rzy nie z�o�yli
--		�adnych zam�wie�

DELETE from Customers
where not exists (	select * from Orders o
					where o.CustomerID = Customers.CustomerID)


-- #6
select SUM(Quantity) as ChocoladeQuantity from [Order Details] od
where OrderID in (	select OrderID from Orders o
					where YEAR(OrderDate) = 1997)
and ProductID = (	select ProductID from Products p
					where p.ProductName = 'Chocolade' )

declare @javaID int
set @javaID = 1 + (select MAX(ProductID) from Products)
print @javaID


begin transaction

	set IDENTITY_INSERT Products ON
	INSERT INTO Products (ProductID, ProductName, Discontinued)
	VALUES (@javaID, 'Programming in Java', 0)
	set IDENTITY_INSERT Products OFF
	
	UPDATE [Order Details]
	set Quantity = Quantity - 1
	where ProductID = (	select ProductID from Products p
						where p.ProductName = 'Chocolade' )
	and OrderID in (	select OrderID from Orders o 
						where YEAR(OrderDate) = 1997)

select SUM(Quantity) as ChocoladeQuantity from [Order Details] od
where OrderID in (	select OrderID from Orders o
					where YEAR(OrderDate) = 1997)
and ProductID = (	select ProductID from Products p
					where p.ProductName = 'Chocolade' )

rollback


drop table ArchivedOrderDetails
drop table ArchivedOrders


--SELECT *
--INTO ArchivedOrders
--FROM Orders
--WHERE OrderID = -1

--ALTER TABLE ArchivedOrders
--ADD ArchiveDate DATETIME

--DROP TABLE ArchivedOrders
	
begin transaction
	select *, GETDATE() as ArchiveDate into ArchivedOrders from Orders
	where YEAR(OrderDate) = 1996

	select * from ArchivedOrders

	ALTER TABLE ArchivedOrders
	ADD
	CONSTRAINT PK_ArchOrd PRIMARY KEY (OrderID),
	CONSTRAINT FK_ArchOrd_Customers FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
	CONSTRAINT FK_ArchOrd_Employees FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)

	select *, GETDATE() as ArchiveDate into ArchivedOrderDetails from [Order Details]
	where OrderID in ( select OrderID from ArchivedOrders )

	ALTER TABLE ArchivedOrderDetails
	ADD
	CONSTRAINT PK_AOD PRIMARY KEY (OrderID, ProductID),
	CONSTRAINT FK_AOD_Orders FOREIGN KEY (OrderID) REFERENCES ArchivedOrders(OrderID),
	CONSTRAINT FK_AOD_Products FOREIGN KEY (ProductID) REFERENCES Products(ProductID)

	DELETE FROM [Order Details]
	where OrderID in (select OrderID from ArchivedOrderDetails)

	DELETE FROM Orders
	where OrderID in (select OrderID from ArchivedOrders)

	select * from ArchivedOrders
	select * from ArchivedOrderDetails

rollback