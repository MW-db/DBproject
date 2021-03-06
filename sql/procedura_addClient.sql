CREATE PROCEDURE registerClient(IN login VARCHAR(30), IN pass VARCHAR(40), IN firstName VARCHAR(40),
                                IN surName VARCHAR(40), IN comapnyName VARCHAR(50), IN phoneNum VARCHAR(9),
                                IN adress VARCHAR(255))
  BEGIN
    IF EXISTS(SELECT * FROM Clients WHERE Login = login) THEN
      SIGNAL SQLSTATE '02000';
    END IF;

    IF phoneNum NOT LIKE("_________") THEN
      SIGNAL SQLSTATE '01000';
    END IF;

    INSERT INTO Clients(Login, Password, Name, Surname, Company, Phone, Adress, Wallet)
    VALUES (login, pass, firstName, surName, comapnyName, phoneNum, adress, 0.0);

    INSERT INTO Log(Date, User, Operation, Table_name, Column_name, Old_value, New_value, STATUS)
      VALUES ((SELECT currentDate FROM tempDate), "Server", "addClient", "Clients", "", "", login, "SUCCESS");

  END;