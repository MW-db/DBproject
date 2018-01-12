CREATE PROCEDURE setSalaryToPay(IN Ndate DATE)
  BEGIN
  DECLARE end INT DEFAULT 0;
  DECLARE done INT DEFAULT 0;
  DECLARE curSalary INT DEFAULT 0;
  DECLARE curWorkerID INT DEFAULT 0;
  DECLARE prevBalance INT;
  DECLARE cur CURSOR FOR SELECT Salary, WorkerID FROM Workers;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET end = 1;

  OPEN cur;
  SET prevBalance = (SELECT Balance FROM Balance ORDER BY Date DESC LIMIT 1);

    setPayLoop: LOOP
      FETCH cur INTO curSalary, curWorkerID;
      IF (end = 1) THEN
        SET done = 1;
        LEAVE setPayLoop;
      END IF;
      INSERT INTO Balance(Date, Status, WorkerID, Fee,  Expense, Balance)
        VALUES (Ndate, "Unpaid", curWorkerID, 0, curSalary, prevBalance);
    END LOOP;
  CLOSE cur;

  INSERT INTO Log(Date, User, Operation, Table_name, Column_name, Old_value, New_value, STATUS) VALUES
    (NOW(), "Admin", "setSalaryToPay", "Balance", "", "", "", "SUCESS");

    COMMIT ;

END;

