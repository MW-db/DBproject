DELIMITER $$
CREATE PROCEDURE nextDay(IN date DATE)
  BEGIN
    DECLARE end INT DEFAULT 0;
    DECLARE done INT DEFAULT 0;
    DECLARE curDate DATE;
    DECLARE curExpense INT DEFAULT 0;
    DECLARE prevBalance INT;
    DECLARE cur CURSOR FOR SELECT Date, Expense FROM balance WHERE Status = "Unpaid" AND WorkerID IS NULL;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET end = 1;

    CALL removeExpirationProducts(date);
    CALL setSalaryToPay(date);
    CALL paySalary();

    OPEN cur;
    SELECT prevBalance = Balance FROM balance ORDER BY Date DESC LIMIT 1;

    SET AUTOCOMMIT = 0;
    START TRANSACTION;

      payLoop: LOOP
        FETCH cur INTO curDate, curExpense;
        IF (end = 1) THEN
          SET done = 1;
          LEAVE payLoop;
        END IF;
        IF (curExpense > prevBalance) THEN
          ROLLBACK;
          SELECT 'NOT ENOUGH MONEY' AS MESSAGE;
          LEAVE payLoop;
        END IF;
        SET prevBalance = prevBalance - curExpense;
        UPDATE balance SET Status = "Paid", Balance = prevBalance - curExpense
          WHERE WorkerID IS NULL AND Date = curDate AND Status = "Unpaid";
      END LOOP;
    IF (done = 1) THEN
      COMMIT;
    END IF;
    CLOSE cur;
  END$$
DELIMITER ;