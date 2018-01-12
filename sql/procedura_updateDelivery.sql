CREATE PROCEDURE updateDelivery(IN deliverID INT, IN productID INT, IN amount INT)
  BEGIN
    DECLARE productTypeUsage INT;
    DECLARE productTypeCapacity INT;
    DECLARE productType ENUM("Food", "Drink", "Other");

    SELECT productType = Type
      FROM products WHERE productID = ProductID;

    IF (productType="Food") THEN
      SELECT productTypeUsage = Food_capacity FROM storage;
      SELECT productTypeCapacity = Food_usage FROM storage;
    ELSEIF (productType="Drink") THEN
      SELECT productTypeUsage = Drinks_capacity FROM storage;
      SELECT productTypeCapacity = Drinks_usage FROM storage;
    ELSEIF (productType="Other") THEN
      SELECT productTypeUsage = Other_capacity FROM storage;
      SELECT productTypeCapacity = Others_usage FROM storage;
    END IF;

    IF (productTypeCapacity - productTypeUsage >= amount) THEN
      INSERT INTO itemsindelivery(DeliveryID, ProductID, Amount)
      VALUES (deliverID, productID, amount);
      INSERT INTO LOG(Date, User, Operation, Table_name, Column_name, Old_value, New_value, STATUS) VALUES
      (NOW(), "Worker", "updateDelivery", "productsInDelivery", "", "", productID, "SUCCESS");
    END IF;

    INSERT INTO LOG(Date, User, Operation, Table_name, Column_name, Old_value, New_value, STATUS) VALUES
      (NOW(), "Worker", "updateDelivery", "productsInDelivery", "", "", productID, "FAILED");
  END;