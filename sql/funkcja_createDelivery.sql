DELIMITER @
CREATE FUNCTION createDelivery (orderDate DATETIME, receivingDate DATETIME)
RETURNS INTEGER DETERMINISTIC
  BEGIN
    INSERT INTO delivery(Order_date, Receiving_date, Status)
      VALUES (orderDate, receivingDate, "Created");
    RETURN (SELECT DeliveryID
            FROM delivery
            WHERE Order_date = orderDate
                  AND Receiving_date = receivingDate
                  AND Status = "Created");
  END@
DELIMITER ;