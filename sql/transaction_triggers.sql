CREATE TRIGGER TransactionUpdate
  AFTER UPDATE ON Transactions
  FOR EACH ROW
  IF NEW.Status="Paid" OR NEW.Status="Declined" THEN
    UPDATE Clients
      SET Clients.Wallet = Clients.Wallet - NEW.TotalPrice
      WHERE Clients.ClientID=NEW.ClientID;
  END IF;
;
CREATE TRIGGER TransactionNew
  AFTER INSERT ON Transactions
  FOR EACH ROW
    UPDATE Clients
      SET Clients.Wallet = Clients.Wallet + NEW.TotalPrice
      WHERE Clients.ClientID=NEW.ClientID;
;
