CREATE PROCEDURE deleteTransaction(IN transaID INT)
  BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE product INT;
    DECLARE size INT;

    DECLARE curs CURSOR FOR (SELECT itemInTransaction.productID, itemInTransaction.amount FROM itemInTransaction
                            WHERE itemInTransaction.transactionID=transaID);
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN curs;
    
    IF EXISTS(SELECT * FROM Transactions WHERE TransactionID=transaID AND Status="Waiting") THEN 

    read_loop: LOOP
      FETCH curs INTO product, size;
      IF done THEN
        LEAVE read_loop;
      END IF;

      UPDATE Products
        SET Products.Amount = Products.Amount + size
        WHERE Products.ProductID = product;

      DELETE FROM itemInTransaction
      WHERE itemInTransaction.transactionID = transaID
            AND itemInTransaction.productID = product;

    END LOOP;

    UPDATE Transactions
      SET Transactions.Status = "Declined"
      WHERE Transactions.TransactionID = transaID;

    COMMIT ;
    END IF ;

  END;

