CREATE TRIGGER DeleteEndSalesAndWorkers
AFTER UPDATE ON tempDate
FOR EACH ROW
  BEGIN
    DELETE FROM Sales WHERE Sales.Date_to=NEW.currentDate;
    DELETE FROM Workers WHERE Workers.ContractTo=NEW.currentDate;
   END;
