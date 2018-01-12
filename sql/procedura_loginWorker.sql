CREATE PROCEDURE loginWorker(IN login VARCHAR(30), IN passwrod VARCHAR(40))
  BEGIN
    IF NOT EXISTS(SELECT * FROM Workers WHERE Login=login AND Password=passwrod) THEN
      SIGNAL SQLSTATE '03000';
    END IF;

    SELECT * FROM Workers WHERE Login=login;
    INSERT INTO Log(Date, User, Operation, Table_name, Column_name, Old_value, New_value, STATUS)
      VALUES ((SELECT currentDate FROM tempDate), login, "LoginClient", "", "", "", "", "SUCCESS");

  END;

