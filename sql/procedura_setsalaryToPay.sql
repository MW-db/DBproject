DELIMITER $$
CREATE PROCEDURE setSalaryToPay(IN date DATE)
BEGIN
  DECLARE end INT DEFAULT 0;
  DECLARE done INT DEFAULT 0;
  DECLARE curSalary INT DEFAULT 0;
  DECLARE curWorkerID INT DEFAULT 0;
  DECLARE prevBalance INT;
  DECLARE cur CURSOR FOR SELECT Salary, WorkerID FROM workers;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET end = 1;

  OPEN cur;
  SELECT prevBalance = Balance FROM balance ORDER BY Date DESC LIMIT 1;

    setPayLoop: LOOP
      FETCH cur INTO curSalary, curWorkerID;
      IF (end = 1) THEN
        SET done = 1;
        LEAVE setPayLoop;
      END IF;
      INSERT INTO balance(Date, Status, WorkerID, Fee,  Expense, Balance)
        VALUES (date, "Unpaid", curWorkerID, 0, curSalary, prevBalance);
    END LOOP;
  CLOSE cur;
END$$
DELIMITER ;