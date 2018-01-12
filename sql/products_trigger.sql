CREATE TRIGGER ProductsOnUpdate
  AFTER UPDATE
  ON Products
  FOR EACH ROW
  BEGIN
    IF NEW.Type="Food" THEN
      UPDATE Storage
        SET Storage.Food_usage = Storage.Food_usage +(NEW.Amount - OLD.Amount);
    ELSEIF  NEW.Type="Drink" THEN
      UPDATE Storage
        SET Storage.Drinks_usage = Storage.Drinks_usage +(NEW.Amount - OLD.Amount);
    ELSE
      UPDATE Storage
        SET Storage.Others_usage = Storage.Others_usage +(NEW.Amount - OLD.Amount);
    END IF;

    UPDATE Storage
     SET  Storage.Capacity_usage = Storage.Capacity_usage +(NEW.Amount - OLD.Amount);
    END;

CREATE TRIGGER ProductsOnInsert
  AFTER INSERT
  ON Products
  FOR EACH ROW
  BEGIN
  IF NEW.Type="Food" THEN
      UPDATE Storage
        SET Storage.Food_usage = Storage.Food_usage + NEW.Amount;
    ELSEIF  NEW.Type="Drink" THEN
      UPDATE Storage
        SET Storage.Drinks_usage = Storage.Drinks_usage + NEW.Amount;
    ELSE
      UPDATE Storage
        SET Storage.Others_usage = Storage.Others_usage + NEW.Amount;
    END IF;

    UPDATE Storage
    SET Storage.Capacity_usage = Storage.Capacity_usage + NEW.Amount;
    END;

;

CREATE TRIGGER SalesInsert
  BEFORE INSERT ON Sales
  FOR EACH ROW
    IF NEW.Date_to < NEW.Date_from THEN
      SIGNAL SQLSTATE '08000';
    END IF;

;
