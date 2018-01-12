CREATE PROCEDURE cancelDelivery(IN NdeliveryID INT)
  BEGIN
    DECLARE productFromCursorID INT;
    DECLARE Namount INT;
    DECLARE payment INT DEFAULT 0;
    DECLARE priceOfProduct INT;
    DECLARE prevBalance INT;
    DECLARE end INT DEFAULT 0;
    DECLARE done INT DEFAULT 0;
    DECLARE cur CURSOR FOR SELECT ProductID, Amount FROM itemsindelivery WHERE DeliveryID = NdeliveryID;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET end = 1;

    IF EXISTS(SELECT * FROM Delivery WHERE DeliveryID=NdeliveryID AND Status="Created") THEN
      OPEN cur;
       deliveryLoop: LOOP
          FETCH cur INTO productFromCursorID, Namount;
          IF (end = 1) THEN
            SET done = 1;
            LEAVE deliveryLoop;
          END IF;

            SET priceOfProduct = (SELECT Price FROM Products WHERE productFromCursorID = ProductID);
            SET payment = payment + (Namount * priceOfProduct);

        END LOOP;

      SET prevBalance = (SELECT Balance FROM Balance ORDER BY BalanceID DESC LIMIT 1);
      IF (done = 1) THEN
        INSERT INTO Balance(Date, Status, DeliveryID, Fee, Expense, Balance)
          VALUES ((SELECT Receiving_date FROM Delivery WHERE NdeliveryID = DeliveryID),
                  "Canceled", NdeliveryID, 100, payment, prevBalance - payment - 100);
      END IF;

      DELETE FROM itemsindelivery WHERE DeliveryID = NdeliveryID;
      UPDATE Delivery SET Status="Canceled" WHERE DeliveryID = NdeliveryID;

      INSERT INTO LOG(Date, User, Operation, Table_name, Column_name, Old_value, New_value, STATUS) VALUES
        ((SELECT currentDate FROM tempDate), "Worker", "cancelDelivery", "Delivery", "", NdeliveryID, "", "SUCCESS");

      CLOSE cur;
      END IF ;

    COMMIT ;
  END;

