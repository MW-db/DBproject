CREATE PROCEDURE createTransaction(IN clientID INT)
  BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE price FLOAT;
    DECLARE transID INT;
    DECLARE desiredAmount INT;
    DECLARE availableAmount INT;
    DECLARE prodID INT;
    DECLARE totalProd INT;
    DECLARE totalPrice FLOAT;
    DECLARE finished BOOL;

    DECLARE curs CURSOR FOR (SELECT P.Amount, tempCart.productID, tempCart.pieces FROM tempCart
                            JOIN Products P ON tempCart.productID = P.ProductID
                            WHERE tempCart.clientID=clientID);
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    SET totalProd = 0;
    SET finished = TRUE ;
    SET totalPrice = 0;

    SET transID = (SELECT MAX(TransactionID) FROM Transactions);
    SET transID = transID + 1;

    IF transID IS NULL THEN
      SET transID = 1;
    END IF;

    OPEN curs;

    START TRANSACTION;
    SET autocommit=0;

    INSERT INTO Transactions(TransactionID, Date, ClientID, Status, totalPrice, NumberOfProducts) VALUES (transID, NOW(), clientID, "Waiting", 0.0, 0);

    read_loop: LOOP
      FETCH curs INTO availableAmount, prodID, desiredAmount;

      IF done THEN
        LEAVE read_loop;
      END IF;

      IF desiredAmount > availableAmount THEN
        ROLLBACK;
        SET finished = FALSE ;
        DELETE FROM Transactions WHERE TransactionID=transID;
        SELECT "Transaction Failed!";
        LEAVE read_loop;
      END IF;

      UPDATE Products
      Set Products.Amount = availableAmount - desiredAmount
      WHERE Products.ProductID = prodID;

      SET totalProd = totalProd + desiredAmount;

      SET price = GetTotal(prodID) * desiredAmount;
      SET totalPrice = totalPrice + price;

      INSERT INTO itemInTransaction(transactionID, productID, amount) VALUES (transID, prodID, desiredAmount);

    END LOOP;

    #wyczysc koszyk
    DELETE FROM tempCart WHERE tempCart.clientID=clientID;

    IF finished THEN
      UPDATE Transactions
        SET Transactions.NumberOfProducts = totalProd, Transactions.TotalPrice = totalPrice
        WHERE Transactions.TransactionID = transID;
    END IF;

    COMMIT;

  END;