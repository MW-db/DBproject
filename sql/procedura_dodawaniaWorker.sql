CREATE PROCEDURE registerWorker(IN pass VARCHAR(40), IN firstName VARCHAR(40),
                                IN surName VARCHAR(40), IN pesel VARCHAR(11),
                                IN phone VARCHAR(9), IN salary FLOAT, IN startContract DATETIME,
                                IN endContract DATETIME)
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

    If (salary > 4000 OR salary < 1500) THEN
      SIGNAL SQLSTATE '01000';
    END IF;

    INSERT INTO Workers(Login, Password, Name, Surname, PESEL, Phone, Salary, ContractFrom, ContractTo)
      VALUES (CONCAT(SUBSTRING(firstName, -5), SUBSTRING(surName, -5), SUBSTRING(pesel, -3)),
              pass, firstName, surName, pesel, phone, salary, startContract, endContract);
  END;