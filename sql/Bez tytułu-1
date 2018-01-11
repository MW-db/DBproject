CREATE PROCEDURE payTransaction(IN transaID INT)
  BEGIN
    UPDATE Transactions
      SET Transactions.Status = "Paid"
    WHERE Transactions.TransactionID=transaID AND Transactions.Status="Accepted";

  END;