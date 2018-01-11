DELIMITER $$
CREATE PROCEDURE paySalary(IN date DATE)
BEGIN
  DECLARE end INT DEFAULT 0;
  DECLARE done INT DEFAULT 0;
  DECLARE sum INT DEFAULT 0;
  DECLARE curSalary INT DEFAULT 0;
  DECLARE prevBalance INT;
  DECLARE cur CURSOR FOR SELECT Salary FROM workers;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET end = 1;

  OPEN cur;

  SELECT prevBalance = Balance FROM balance ORDER BY Date DESC LIMIT 1;

  START TRANSACTION;
    payLoop: LOOP
      IF (sum > prevBalance) THEN
        ROLLBACK;
        SELECT 'NOT ENOUGH MONEY' AS MESSAGE;
        LEAVE payLoop;
      END IF;
      FETCH cur INTO curSalary;
      IF (end = 1) THEN
        SET done = 1;
        LEAVE payLoop;
      END IF;
      SET sum = sum + curSalary;
    END LOOP;
  IF (done = 1) THEN
    INSERT INTO balance(Date, Fee, Expense, Balance)
        VALUES (date, 0, sum, prevBalance - sum);
    COMMIT;
  END IF;
  CLOSE cur;
END$$
DELIMITER ;