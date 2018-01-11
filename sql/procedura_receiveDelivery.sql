DELIMITER $$
CREATE PROCEDURE receiveDelivery(IN deliveryID INT)
  BEGIN
    DECLARE productTypeUsage INT;
    DECLARE productTypeCapacity INT;
    DECLARE productFromCursorID INT;
    DECLARE productType ENUM("Food", "Drink", "Other");
    DECLARE amount INT;

    DECLARE usageStorage INT;
    DECLARE capacityStorage INT;
    DECLARE payment INT DEFAULT 0;
    DECLARE priceOfProduct INT;
    DECLARE amountOfProduct INT;
    DECLARE prevBalance INT;

    DECLARE end INT DEFAULT 0;
    DECLARE done INT DEFAULT 0;
    DECLARE err INT DEFAULT 0;
    DECLARE cur CURSOR FOR SELECT ProductID, Amount FROM itemsindelivery WHERE DeliveryID = deliveryID;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET end = 1;

    SELECT usageStorage = Capacity_usage FROM storage;
    SELECT capacityStorage = Capacity FROM storage;

    OPEN cur;

    START TRANSACTION;
     deliveryLoop: LOOP
        IF (usageStorage > capacityStorage) THEN
          SELECT 'TOO MUCH PRODUCTS IN STORAGE' AS MESSAGE;
          #LEAVE deliveryLoop;
        END IF;
        FETCH cur INTO productFromCursorID, amount;
        IF (end = 1) THEN
          SET done = 1;
          LEAVE deliveryLoop;
        END IF;

        SELECT productType = Type
          FROM products WHERE productFromCursorID = ProductID;

       IF (productType="Food") THEN
          SELECT productTypeUsage = Food_capacity FROM storage;
          SELECT productTypeCapacity = Food_usage FROM storage;
          SELECT priceOfProduct = Price FROM products WHERE productFromCursorID = ProductID;
          SELECT amountOfProduct = Amount FROM products WHERE productFromCursorID = ProductID;

          IF (productTypeUsage + amount > productTypeCapacity) THEN
            SELECT 'TOO MUCH FOOD PRODUCTS IN STORAGE' AS MESSAGE;
            SET err = 1;
          END IF;

          SET payment = payment + ((amountOfProduct + amount) * priceOfProduct);
          UPDATE products SET Amount = amount, Expiration_date =
              (SELECT ADDDATE((SELECT Receiving_date FROM delivery WHERE deliveryID = DeliveryID), INTERVAL 7 DAY));

          SELECT usageStorage = Capacity_usage FROM storage;
          UPDATE storage SET Food_usage = productTypeUsage + amount - amountOfProduct;
          UPDATE storage SET Capacity_usage = usageStorage + amount - amountOfProduct;

        ELSEIF (productType="Drink") THEN
          SELECT productTypeUsage = Drinks_capacity FROM storage;
          SELECT productTypeCapacity = Drinks_usage FROM storage;
          SELECT priceOfProduct = Price FROM products WHERE productFromCursorID = ProductID;
          SELECT amountOfProduct = Amount FROM products WHERE productFromCursorID = ProductID;

          IF (productTypeUsage + amount > productTypeCapacity) THEN
            SELECT 'TOO MUCH DRINKS PRODUCTS IN STORAGE' AS MESSAGE;
            SET err = 1;
          END IF;

          SET payment = payment + ((amountOfProduct + amount) * priceOfProduct);
          UPDATE products SET Amount = amount, Expiration_date =
              (SELECT ADDDATE((SELECT Receiving_date FROM delivery WHERE deliveryID = DeliveryID), INTERVAL 14 DAY));

          SELECT usageStorage = Capacity_usage FROM storage;
          UPDATE storage SET Drinks_usage = productTypeUsage + amount - amountOfProduct;
          UPDATE storage SET Capacity_usage = usageStorage + amount - amountOfProduct;

        ELSEIF (productType="Other") THEN
          SELECT productTypeUsage = Other_capacity FROM storage;
          SELECT productTypeCapacity = Others_usage FROM storage;
          SELECT priceOfProduct = Price FROM products WHERE productFromCursorID = ProductID;
          SELECT amountOfProduct = Amount FROM products WHERE productFromCursorID = ProductID;

          IF (productTypeUsage + amount > productTypeCapacity) THEN
            SELECT 'TOO MUCH OTHER PRODUCTS IN STORAGE' AS MESSAGE;
            SET err = 1;
          END IF;

          SET payment = payment + ((amountOfProduct + amount) * priceOfProduct);
          UPDATE products SET Amount = amount, Expiration_date =
              (SELECT ADDDATE((SELECT Receiving_date FROM delivery WHERE deliveryID = DeliveryID), INTERVAL 21 DAY));

          SELECT usageStorage = Capacity_usage FROM storage;
          UPDATE storage SET Others_usage = productTypeUsage + amount - amountOfProduct;
          UPDATE storage SET Capacity_usage = usageStorage + amount - amountOfProduct;
       END IF;

      END LOOP;

    SELECT prevBalance = Balance FROM balance ORDER BY Date DESC LIMIT 1;
    IF (done = 1 AND err = 0) THEN
      INSERT INTO balance(Date, Status, DeliveryID, Fee, Expense, Balance)
        VALUES ((SELECT Receiving_date FROM delivery WHERE deliveryID = DeliveryID),
                "Received", deliveryID, 0, payment, prevBalance - payment);
      COMMIT;
    ELSE
      INSERT INTO balance(Date, Status, DeliveryID, Fee, Expense, Balance)
        VALUES ((SELECT Receiving_date FROM delivery WHERE deliveryID = DeliveryID),
                "Canceled", deliveryID, 100, payment, prevBalance - payment - 100);
      ROLLBACK;
    END IF;

    DELETE FROM itemsindelivery WHERE DeliveryID = deliveryID;
    DELETE FROM delivery WHERE DeliveryID = deliveryID;

    CLOSE cur;
  END$$
DELIMITER ;