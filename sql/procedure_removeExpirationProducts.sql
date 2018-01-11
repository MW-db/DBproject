DELIMITER $$
CREATE PROCEDURE removeExpirationProducts(IN date DATE)
  BEGIN
    DECLARE end INT DEFAULT 0;
    DECLARE curAmount INT DEFAULT 0;
    DECLARE curPrice INT DEFAULT 0;
    DECLARE curProductID INT;
    DECLARE prevBalance INT;
    DECLARE cur CURSOR FOR SELECT Amount, Price, ProductID FROM products WHERE Expiration_date = date;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET end = 1;

    OPEN cur;
    SELECT prevBalance = Balance FROM balance ORDER BY Date DESC LIMIT 1;

      removeExpirationLoop: LOOP
        FETCH cur INTO curAmount, curPrice, curProductID;
        IF (end = 1) THEN
          LEAVE removeExpirationLoop;
        END IF;
        INSERT INTO balance(Date, Status, Fee, Expense, Balance)
        VALUES (ADDDATE(date, INTERVAL 1 DAY), "Unpaid", 0, (curAmount * curPrice), prevBalance);
      END LOOP;

    INSERT INTO balance(Date, Status, Fee, Expense, Balance)
        VALUES (ADDDATE(date, INTERVAL 1 DAY), "Unpaid", 75, 75, prevBalance);
    CLOSE cur;
  END$$
DELIMITER ;