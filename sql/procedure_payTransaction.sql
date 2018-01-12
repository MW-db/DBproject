CREATE PROCEDURE payTransaction(IN transaID INT)
  BEGIN
    DECLARE prevBalance INT DEFAULT 0;
    DECLARE earn INT DEFAULT 0;

    IF EXISTS(SELECT * FROM Transactions WHERE TransactionID=transaID AND Status="Waiting") THEN
    UPDATE Transactions
      SET Transactions.Status = "Paid"
    WHERE Transactions.TransactionID=transaID;

     SET prevBalance = (SELECT Balance FROM Balance ORDER BY Date DESC LIMIT 1);
      SET earn = (SELECT TotalPrice FROM Transactions WHERE TransactionID = transaID);
      INSERT INTO Balance(Date, Status, TransactionID, Income, Balance) VALUES 
        (NOW(), "Paid", transaID, earn, (prevBalance + earn));

      COMMIT ;
    END IF ;

  END;

