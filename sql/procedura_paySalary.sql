CREATE PROCEDURE paySalary()
  BEGIN
  DECLARE end INT DEFAULT 0;
  DECLARE done INT DEFAULT 0;
  DECLARE curDate DATE;
  DECLARE curExpense INT DEFAULT 0;
  DECLARE curWorkerID INT DEFAULT 0;
  DECLARE prevBalance INT;
  DECLARE cur CURSOR FOR (SELECT Date, Expense, WorkerID FROM Balance WHERE Status = "Unpaid" AND WorkerID IS NOT NULL);
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET end = 1;

  OPEN cur;
  SET prevBalance = (SELECT Balance FROM Balance ORDER BY BalanceID DESC LIMIT 1);

  SET autocommit = 0;
  START TRANSACTION;
    payLoop: LOOP
      FETCH cur INTO curDate, curExpense, curWorkerID;
      IF (end = 1) THEN
        SET done = 1;
        LEAVE payLoop;
      END IF;
      IF (curExpense > prevBalance) THEN
        ROLLBACK;
        SELECT 'NOT ENOUGH MONEY' AS MESSAGE;
        INSERT INTO LOG(Date, User, Operation, Table_name, Column_name, Old_value, New_value, STATUS) VALUES
          ((SELECT currentDate FROM tempDate), "Admin", "PaySalary", "Balance", "", "", "", "FAILED");
        LEAVE payLoop;
      END IF;
      SET prevBalance = prevBalance - curExpense;
      UPDATE Balance SET Status = "Paid", Balance = prevBalance
        WHERE WorkerID = curWorkerID AND Date = curDate AND Status = "Unpaid";
    END LOOP;
  IF (done = 1) THEN
    INSERT INTO LOG(Date, User, Operation, Table_name, Column_name, Old_value, New_value, STATUS) VALUES
          ((SELECT currentDate FROM tempDate), "Admin", "PaySalary", "Balance", "", "", "", "SUCCESS");
    COMMIT;
  END IF;
  CLOSE cur;
    COMMIT ;
END;

