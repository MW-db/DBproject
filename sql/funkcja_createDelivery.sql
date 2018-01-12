CREATE FUNCTION createDelivery(receivingDate DATE)
  RETURNS INT
  BEGIN
    DECLARE orderDate DATE;
    SET orderDate = (SELECT currentDate FROM tempDate);
    INSERT INTO Delivery(Order_date, Receiving_date, Status)
      VALUES (orderDate, receivingDate, "Created");
    INSERT INTO Log(Date, User, Operation, Table_name, Column_name, Old_value, New_value, STATUS) VALUES
      (orderDate, "Worker", "createDelivery", "Delivery", "", "", "", "SUCCESS");

    RETURN (SELECT DeliveryID
            FROM Delivery
            WHERE Order_date = orderDate
                  AND Receiving_date = receivingDate
                  AND Status = "Created");
  END;
