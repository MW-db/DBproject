CREATE PROCEDURE receiveDelivery(IN NdeliveryID INT)
  BEGIN
    DECLARE productTypeUsage INT;
    DECLARE productTypeCapacity INT;
    DECLARE productFromCursorID INT;
    DECLARE productType ENUM("Food", "Drink", "Other");
    DECLARE Namount INT;

    DECLARE usageStorage INT;
    DECLARE capacityStorage INT;
    DECLARE payment INT DEFAULT 0;
    DECLARE priceOfProduct INT;
    DECLARE amountOfProduct INT;
    DECLARE prevBalance INT;

    DECLARE Nend INT DEFAULT 0;
    DECLARE done INT DEFAULT 0;
    DECLARE err INT DEFAULT 0;
    DECLARE cur CURSOR FOR (SELECT ProductID, Amount FROM itemsInDelivery WHERE DeliveryID = NdeliveryID);
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET Nend = 1;

    SET usageStorage = (SELECT Capacity_usage FROM Storage);
    SET capacityStorage = (SELECT Capacity FROM Storage);


    IF EXISTS(SELECT * FROM Delivery WHERE DeliveryID=NdeliveryID AND Status="Created") THEN
      OPEN cur;

      SET autocommit = 0;
      START TRANSACTION;
       deliveryLoop: LOOP
          IF (usageStorage > capacityStorage) THEN
            SELECT 'TOO MUCH PRODUCTS IN STORAGE' AS MESSAGE;
            #LEAVE deliveryLoop;
          END IF;
          FETCH cur INTO productFromCursorID, Namount;
          IF (Nend = 1) THEN
            SET done = 1;
            LEAVE deliveryLoop;
          END IF;

          SET productType = (SELECT Type
            FROM Products WHERE productFromCursorID = ProductID);

         IF (productType="Food") THEN
            SET productTypeUsage = (SELECT Food_usage FROM Storage);
            SET productTypeCapacity = (SELECT Food_capacity FROM Storage);
            SET priceOfProduct = (SELECT Price FROM Products WHERE productFromCursorID = ProductID);
            SET amountOfProduct = (SELECT Amount FROM Products WHERE productFromCursorID = ProductID);

            IF (productTypeUsage + Namount > productTypeCapacity) THEN
              SELECT 'TOO MUCH FOOD PRODUCTS IN STORAGE' AS MESSAGE;
              SET err = 1;
            END IF;

            SET payment = payment + ((amountOfProduct + Namount) * priceOfProduct);
            UPDATE Products SET Amount = Amount + Namount, Expiration_date =
                (SELECT ADDDATE((SELECT Receiving_date FROM Delivery WHERE NdeliveryID = DeliveryID), INTERVAL 7 DAY))
                WHERE ProductID = productFromCursorID;

            SET usageStorage = (SELECT Capacity_usage FROM Storage);
            UPDATE Storage SET Food_usage = productTypeUsage + Namount - amountOfProduct;
            UPDATE Storage SET Capacity_usage = usageStorage + Namount - amountOfProduct;

          ELSEIF (productType="Drink") THEN
            SET productTypeUsage = (SELECT Drinks_usage FROM Storage);
            SET productTypeCapacity = (SELECT Drinks_capacity FROM Storage);
            SET priceOfProduct = (SELECT Price FROM Products WHERE productFromCursorID = ProductID);
            SET amountOfProduct = (SELECT Amount FROM Products WHERE productFromCursorID = ProductID);

            IF (productTypeUsage + Namount > productTypeCapacity) THEN
              SELECT 'TOO MUCH DRINKS PRODUCTS IN STORAGE' AS MESSAGE;
              SET err = 1;
            END IF;

            SET payment = payment + ((amountOfProduct + Namount) * priceOfProduct);
            UPDATE Products SET Amount = Amount + Namount, Expiration_date =
                (SELECT ADDDATE((SELECT Receiving_date FROM Delivery WHERE NdeliveryID = DeliveryID), INTERVAL 14 DAY))
                WHERE ProductID = productFromCursorID;

            SET usageStorage = (SELECT Capacity_usage FROM Storage);
            UPDATE Storage SET Drinks_usage = productTypeUsage + Namount - amountOfProduct;
            UPDATE Storage SET Capacity_usage = usageStorage + Namount - amountOfProduct;

          ELSEIF (productType="Other") THEN
            SET productTypeUsage = (SELECT Others_usage FROM Storage);
            SET productTypeCapacity = (SELECT Other_capacity FROM Storage);
            SET priceOfProduct = (SELECT Price FROM Products WHERE productFromCursorID = ProductID);
            SET amountOfProduct = (SELECT Amount FROM Products WHERE productFromCursorID = ProductID);

            IF (productTypeUsage + Namount > productTypeCapacity) THEN
              SELECT 'TOO MUCH OTHER PRODUCTS IN STORAGE' AS MESSAGE;
              SET err = 1;
            END IF;

            SET payment = payment + ((amountOfProduct + Namount) * priceOfProduct);
            UPDATE Products SET Amount = Amount + Namount, Expiration_date =
                (SELECT ADDDATE((SELECT Receiving_date FROM Delivery WHERE NdeliveryID = DeliveryID), INTERVAL 21 DAY))
                WHERE ProductID = productFromCursorID;

            SET usageStorage = (SELECT Capacity_usage FROM Storage);
            UPDATE Storage SET Others_usage = productTypeUsage + Namount - amountOfProduct;
            UPDATE Storage SET Capacity_usage = usageStorage + Namount - amountOfProduct;
         END IF;

        END LOOP;

      SET prevBalance = (SELECT Balance FROM Balance ORDER BY BalanceID DESC LIMIT 1);
      IF (done = 1 AND err = 0) THEN
        COMMIT;
        INSERT INTO Balance(Balance.Date, Status, DeliveryID, Fee, Expense, Balance)
          VALUES ((SELECT Receiving_date FROM Delivery WHERE NdeliveryID = DeliveryID),
                  "Received", NdeliveryID, 0, payment, (prevBalance - payment));

        UPDATE Delivery
          SET Status="Received"
          WHERE Delivery.DeliveryID=NdeliveryID;

        INSERT INTO Log(Date, User, Operation, Table_name, Column_name, Old_value, New_value, STATUS) VALUES
          ((SELECT currentDate FROM tempDate), "Worker", "ReceiveDelivery", "Delivery", "", "", "", "SUCCESS");
      ELSE
        ROLLBACK;
        INSERT INTO Balance(Date, Status, DeliveryID, Fee, Expense, Balance)
          VALUES ((SELECT Receiving_date FROM Delivery WHERE NdeliveryID = DeliveryID),
                  "Canceled", NdeliveryID, 100, payment, prevBalance - payment - 100);

        INSERT INTO Log(Date, User, Operation, Table_name, Column_name, Old_value, New_value, STATUS) VALUES
          ((SELECT currentDate FROM tempDate), "Worker", "ReceiveDelivery", "Delivery", "", "", "", "FAILED");
      END IF;

      DELETE FROM itemsInDelivery WHERE DeliveryID = NdeliveryID;
      #DELETE FROM Delivery WHERE DeliveryID = NdeliveryID;

      CLOSE cur;
      END IF ;
    COMMIT ;
  END;
