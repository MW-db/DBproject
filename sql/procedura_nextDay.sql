DELIMITER $$
CREATE PROCEDURE nextDay()
  BEGIN
    DECLARE end INT DEFAULT 0;
    DECLARE done INT DEFAULT 0;
    DECLARE curDate DATE;
    DECLARE curExpense INT DEFAULT 0;
    DECLARE prevBalance INT;
    DECLARE cur CURSOR FOR SELECT Date, Expense FROM Balance WHERE Status = "Unpaid" AND WorkerID IS NULL;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET end = 1;

    SET curDate = (SELECT currentDate FROM tempDate);

    CALL removeExpirationProducts(curDate);
    CALL setSalaryToPay(curDate);
    CALL paySalary();

    OPEN cur;
    SET prevBalance = (SELECT Balance FROM Balance ORDER BY BalanceID DESC LIMIT 1);

    SET autocommit = 0;
    START TRANSACTION;

      payLoop: LOOP
        FETCH cur INTO curDate, curExpense;
        IF (end = 1) THEN
          SET done = 1;
          LEAVE payLoop;
        END IF;
        IF (curExpense > prevBalance) THEN
          #ROLLBACK;
          SELECT 'NOT ENOUGH MONEY' AS MESSAGE;
          LEAVE payLoop;
        END IF;
        SET prevBalance = prevBalance - curExpense;
        UPDATE Balance SET Status = "Paid", Balance = prevBalance - curExpense
          WHERE WorkerID IS NULL AND Status = "Unpaid";
      END LOOP;
    IF (done = 1) THEN
      UPDATE tempDate SET currentDate = ADDDATE(curDate, INTERVAL 1 DAY);
      COMMIT;
    END IF;
    CLOSE cur;

    INSERT INTO Log(Date, User, Operation, Table_name, Column_name, Old_value, New_value, STATUS) VALUES
      ((SELECT currentDate FROM tempDate), "Admin", "nextDay", "", "", "", "", "SUCESS");
    COMMIT ;
  END$$
DELIMITER ;