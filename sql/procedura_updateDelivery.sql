CREATE PROCEDURE updateDelivery(IN deliverID INT, IN NproductID INT, IN amount INT)
  BEGIN
    DECLARE productTypeUsage INT;
    DECLARE productTypeCapacity INT;
    DECLARE productType ENUM("Food", "Drink", "Other");

    SET productType = (SELECT Type
      FROM Products WHERE NproductID = ProductID);

    IF (productType="Food") THEN
      SET productTypeUsage = (SELECT Food_usage FROM Storage);
      SET productTypeCapacity = (SELECT Food_capacity FROM Storage);
    ELSEIF (productType="Drink") THEN
      SET productTypeUsage =(SELECT Drinks_usage FROM Storage);
      SET productTypeCapacity = (SELECT Drinks_capacity FROM Storage);
    ELSEIF (productType="Other") THEN
      SET productTypeUsage = (SELECT Others_usage FROM Storage);
      SET productTypeCapacity =(SELECT Other_capacity FROM Storage);
    END IF;

    IF ((productTypeCapacity - productTypeUsage) >= amount) THEN
      INSERT INTO itemsInDelivery(DeliveryID, ProductID, Amount)
      VALUES (deliverID, NproductID, amount);
      INSERT INTO LOG(Date, User, Operation, Table_name, Column_name, Old_value, New_value, STATUS) VALUES
      ((SELECT currentDate FROM tempDate), "Worker", "updateDelivery", "productsInDelivery", "", "", NproductID, "SUCCESS");
      ELSE
        INSERT INTO LOG(Date, User, Operation, Table_name, Column_name, Old_value, New_value, STATUS) VALUES
      ((SELECT currentDate FROM tempDate), "Worker", "updateDelivery", "productsInDelivery", "", "", NproductID, "FAILED");
    END IF;

    COMMIT ;
  END;

