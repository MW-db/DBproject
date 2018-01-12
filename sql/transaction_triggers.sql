CREATE TRIGGER TransactionUpdate
  AFTER UPDATE
  ON Transactions
  FOR EACH ROW
  BEGIN
  IF NEW.Status="Paid" OR NEW.Status="Declined" THEN
    UPDATE Clients
      SET Clients.Wallet = Clients.Wallet - NEW.TotalPrice
      WHERE Clients.ClientID=NEW.ClientID;
    ELSEIF NEW.Status="Waiting" THEN
      UPDATE Clients
      SET Clients.Wallet = Clients.Wallet + NEW.TotalPrice
      WHERE Clients.ClientID=NEW.ClientID;
  END IF;
    END;




CREATE TRIGGER TransactionNew
  AFTER INSERT
  ON Transactions
  FOR EACH ROW
  BEGIN
  UPDATE Clients
      SET Clients.Wallet = Clients.Wallet + NEW.TotalPrice
      WHERE Clients.ClientID=NEW.ClientID;
    END;
