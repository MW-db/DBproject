CREATE PROCEDURE  addSale(IN prodID INT, IN price INT, IN start DATE, IN end DATE, IN name VARCHAR(70))
  BEGIN
  
    IF NOT EXISTS(SELECT * FROM Products WHERE ProductID=prodID) THEN
        SIGNAL SQLSTATE '01300';
    END IF;
  
    IF(price < (SELECT Price FROM Products WHERE ProductID=prodID)) THEN
      SIGNAL SQLSTATE '01300';
    END IF;

    INSERT INTO Sales(Name, Date_from, Date_to, ProductID, Price) VALUES (name, start, end, prodID, price);

  END;