-- 4
-- a)
CREATE TABLE Pacjent(
	Id_pacjenta int NOT NULL,
	PESEL char(11) NOT NULL,
	CONSTRAINT PKC_Pacjent PRIMARY KEY(Id_pacjenta)
)

CREATE TABLE Wizyta(
	Id_wizyty int NOT NULL,
	Dawka decimal(8,2) NOT NULL,
	Data_wizyty datetime NOT NULL,
	Id_pacjenta int NOT NULL,
	CONSTRAINT PKC_Wizyta PRIMARY KEY(Id_wizyty),
	CONSTRAINT FKC_Wizyta_Pacjent FOREIGN KEY(Id_pacjenta)
	REFERENCES Pacjent (Id_pacjenta)
)

