CREATE PROCEDURE deleteTransaction(IN transaID INT)
  BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE product INT;
    DECLARE size INT;

    DECLARE curs CURSOR FOR (SELECT itemInTransaction.productID, itemInTransaction.amount FROM itemInTransaction
                            WHERE itemInTransaction.transactionID=transID);
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN curs;


    read_loop: LOOP
      FETCH curs INTO product, size;
      IF done THEN
        LEAVE read_loop;
      END IF;

      UPDATE Products
        SET Products.Amount = Products.Amount + size
        WHERE Products.ProductID = product;

      DELETE FROM itemInTransaction
      WHERE itemInTransaction.transactionID = transID
            AND itemInTransaction.productID = product;

    END LOOP;

    DELETE FROM Transactions WHERE Transactions.TransactionID=transID;

  END;