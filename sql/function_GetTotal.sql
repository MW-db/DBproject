CREATE FUNCTION GetTotal(id INT) RETURNS FLOAT
  BEGIN
    IF EXISTS(SELECT S.Price FROM Products
              JOIN Sales S ON Products.ProductID = S.ProductID
              WHERE Products.ProductID=ID) THEN
      RETURN (SELECT S.Price FROM Products
              JOIN Sales S ON Products.ProductID = S.ProductID
              WHERE Products.ProductID=ID
              LIMIT 1);
    END IF;

    RETURN (SELECT Price FROM Products WHERE ProductID=id LIMIT 1);
  END;