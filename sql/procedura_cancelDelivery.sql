DELIMITER $$
CREATE PROCEDURE cancelDelivery(IN deliveryID INT)
  BEGIN
    DECLARE productFromCursorID INT;
    DECLARE amount INT;
    DECLARE payment INT DEFAULT 0;
    DECLARE priceOfProduct INT;
    DECLARE prevBalance INT;
    DECLARE end INT DEFAULT 0;
    DECLARE done INT DEFAULT 0;
    DECLARE cur CURSOR FOR SELECT ProductID, Amount FROM itemsindelivery WHERE DeliveryID = deliveryID;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET end = 1;

    OPEN cur;
     deliveryLoop: LOOP
        FETCH cur INTO productFromCursorID, amount;
        IF (end = 1) THEN
          SET done = 1;
          LEAVE deliveryLoop;
        END IF;

          SELECT priceOfProduct = Price FROM products WHERE productFromCursorID = ProductID;
          SET payment = payment + (amount * priceOfProduct);

      END LOOP;

    SELECT prevBalance = Balance FROM balance ORDER BY Date DESC LIMIT 1;
    IF (done = 1) THEN
      INSERT INTO balance(Date, Status, DeliveryID, Fee, Expense, Balance)
        VALUES ((SELECT Receiving_date FROM delivery WHERE deliveryID = DeliveryID),
                "Canceled", deliveryID, 100, payment, prevBalance - payment - 100);
    END IF;

    DELETE FROM itemsindelivery WHERE DeliveryID = deliveryID;
    DELETE FROM delivery WHERE DeliveryID = deliveryID;

    INSERT INTO LOG(Date, User, Operation, Table_name, Column_name, Old_value, New_value, STATUS) VALUES
      (NOW(), "Worker", "cancelDelivery", "Delivery", "", deliveryID, "", "SUCCESS");

    CLOSE cur;
  END$$
DELIMITER ;