CREATE PROCEDURE registerWorker(IN pass VARCHAR(40), IN firstName VARCHAR(40),
                                IN surName VARCHAR(40), IN pesel VARCHAR(11),
                                IN phone VARCHAR(9), IN salary INT, IN startContract DATE,
                                IN endContract DATE)
  BEGIN
    IF pesel NOT LIKE("___________") THEN
      SIGNAL SQLSTATE '01000';
    END IF;

    IF EXISTS( SELECT * FROM Workers WHERE PESEL = pesel) THEN
      SIGNAL SQLSTATE '02000';
    END IF;

    IF (startContract > endContract)THEN
      SIGNAL SQLSTATE '01000';
    END IF;

    If (salary > 120 OR salary < 80) THEN
      SIGNAL SQLSTATE '01000';
    END IF;

    INSERT INTO Workers(Login, Password, Name, Surname, PESEL, Phone, Salary, ContractFrom, ContractTo)
      VALUES (CONCAT(SUBSTRING(firstName, -5), SUBSTRING(surName, -5), SUBSTRING(pesel, -3)),
              pass, firstName, surName, pesel, phone, salary, startContract, endContract);
    INSERT INTO Log(Date, User, Operation, Table_name, Column_name, Old_value, New_value, STATUS)
      VALUES ((SELECT currentDate FROM tempDate), "Server", "addWorker", "Workers", "", "", CONCAT(SUBSTRING(firstName, -5), SUBSTRING(surName, -5),
                                                                      SUBSTRING(pesel, -3)), "SUCCESS");
  END;