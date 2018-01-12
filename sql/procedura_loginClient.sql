CREATE PROCEDURE loginClient(IN login VARCHAR(30), IN passwrod VARCHAR(40))
  BEGIN
    IF NOT EXISTS(SELECT *
                  FROM Clients
                  WHERE Login = login AND Password = passwrod)
    THEN
      SIGNAL SQLSTATE '03000';
    END IF;

    SELECT *
    FROM Clients
    WHERE Login = login;

    INSERT INTO LOG(Date, User, Operation, Table_name, Column_name, Old_value, New_value, STATUS)
    VALUES ((SELECT currentDate FROM tempDate), login, "ClientLogin", "", "", "", "", "Success");

  END;

