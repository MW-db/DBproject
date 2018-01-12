CREATE PROCEDURE removeExpirationProducts(IN date DATE)
  BEGIN
    DECLARE end INT DEFAULT 0;
    DECLARE curAmount INT DEFAULT 0;
    DECLARE curPrice INT DEFAULT 0;
    DECLARE curProductID INT;
    DECLARE prevBalance INT;
    DECLARE sum INT DEFAULT 0;
    DECLARE cur CURSOR FOR (SELECT Amount, Price, ProductID FROM Products WHERE Expiration_date = date);
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET end = 1;

    OPEN cur;
    SET prevBalance = (SELECT Balance FROM Balance ORDER BY Date DESC LIMIT 1);

      removeExpirationLoop: LOOP
        FETCH cur INTO curAmount, curPrice, curProductID;
        SET prevBalance = (SELECT Balance FROM Balance ORDER BY Date DESC LIMIT 1);
        IF (end = 1) THEN
          LEAVE removeExpirationLoop;
        END IF;

        UPDATE Products SET Amount=0 WHERE ProductID=curProductID;
        SET sum = sum + (curAmount * curPrice);

        #INSERT INTO Balance(Date, Status, Fee, Expense, Balance)
        #VALUES (ADDDATE(date, INTERVAL 1 DAY), "Paid", 0, (curAmount * curPrice), prevBalance));
      END LOOP;


    IF sum > 0 THEN
    INSERT INTO Balance(Date, Status, Fee, Expense, Balance)
        VALUES (ADDDATE(date, INTERVAL 1 DAY), "Paid", 0, sum, prevBalance);
    END IF ;

    CLOSE cur;

    COMMIT ;
  END;

