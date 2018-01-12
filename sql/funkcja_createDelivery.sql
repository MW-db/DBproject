DELIMITER @
CREATE FUNCTION createDelivery (orderDate DATE, receivingDate DATE)
RETURNS INTEGER DETERMINISTIC
  BEGIN
    INSERT INTO delivery(Order_date, Receiving_date, Status)
      VALUES (orderDate, receivingDate, "Created");
    RETURN (SELECT DeliveryID
            FROM delivery
            WHERE Order_date = orderDate
                  AND Receiving_date = receivingDate
                  AND Status = "Created" ORDER BY DeliveryID DESC LIMIT 1);
  END@
DELIMITER ;