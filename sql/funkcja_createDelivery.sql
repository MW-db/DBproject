DELIMITER @
CREATE FUNCTION createDelivery (orderDate DATE, receivingDate DATE)
RETURNS INTEGER DETERMINISTIC
  BEGIN
    INSERT INTO delivery(Order_date, Receiving_date, Status)
      VALUES (orderDate, receivingDate, "Created");
    INSERT INTO Log(Date, User, Operation, Table_name, Column_name, Old_value, New_value, STATUS) VALUES
      (NOW(), "Worker", "createDelivery", "Delivery", "", "", "", "SUCCESS");
    RETURN (SELECT DeliveryID
            FROM delivery
            WHERE Order_date = orderDate
                  AND Receiving_date = receivingDate
                  AND Status = "Created");
  END@
DELIMITER ;