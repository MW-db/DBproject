CREATE TRIGGER DeleteEndSales
  AFTER UPDATE
  ON tempDate
  FOR EACH ROW
  BEGIN
    DELETE * FROM Sales WHERE Sales.Date_to=NEW.currentDate;
   END;