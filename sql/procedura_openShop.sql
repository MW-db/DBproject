DELIMITER $$
CREATE PROCEDURE openShop()
BEGIN
  INSERT INTO Balance(Date, Fee, Income, Balance)
        VALUES ('2018-01-01', 0, 10000, 10000);
  INSERT INTO Storage(Capacity, Food_capacity, Drinks_capacity, Other_capacity, Capacity_usage, Food_usage, Drinks_usage, Others_usage)
        VALUES (500, 200, 200, 100, 0, 0, 0, 0);

  INSERT INTO Products(Amount, Price, Name, Expiration_date, Type)
        VALUES (0, 6, "bread", '2018-01-07', "Food");
  INSERT INTO Products(Amount, Price, Name, Expiration_date, Type)
        VALUES (0, 4, "roll", '2018-01-07', "Food");
  INSERT INTO Products(Amount, Price, Name, Expiration_date, Type)
        VALUES (0, 4, "yoghurt", '2018-01-07', "Food");
  INSERT INTO Products(Amount, Price, Name, Expiration_date, Type)
        VALUES (0, 8, "cheese", '2018-01-07', "Food");
  INSERT INTO Products(Amount, Price, Name, Expiration_date, Type)
        VALUES (0, 6, "ham", '2018-01-07', "Food");
  INSERT INTO Products(Amount, Price, Name, Expiration_date, Type)
        VALUES (0, 12, "butter", '2018-01-07', "Food");
  INSERT INTO Products(Amount, Price, Name, Expiration_date, Type)
        VALUES (0, 4, "candy bar", '2018-01-07', "Food");
  INSERT INTO Products(Amount, Price, Name, Expiration_date, Type)
        VALUES (0, 8, "sugar", '2018-01-07', "Food");
  INSERT INTO Products(Amount, Price, Name, Expiration_date, Type)
        VALUES (0, 8, "flour", '2018-01-07', "Food");

  INSERT INTO Products(Amount, Price, Name, Expiration_date, Type)
        VALUES (0, 4, "water", '2018-01-14', "Drink");
  INSERT INTO Products(Amount, Price, Name, Expiration_date, Type)
        VALUES (0, 6, "orange juice", '2018-01-14', "Drink");
  INSERT INTO Products(Amount, Price, Name, Expiration_date, Type)
        VALUES (0, 6, "apple juice", '2018-01-14', "Drink");
  INSERT INTO Products(Amount, Price, Name, Expiration_date, Type)
        VALUES (0, 8, "coca cola", '2018-01-14', "Drink");
  INSERT INTO Products(Amount, Price, Name, Expiration_date, Type)
        VALUES (0, 14, "energy drink", '2018-01-14', "Drink");
  INSERT INTO Products(Amount, Price, Name, Expiration_date, Type)
        VALUES (0, 8, "pepsi", '2018-01-14', "Drink");
  INSERT INTO Products(Amount, Price, Name, Expiration_date, Type)
        VALUES (0, 6, "multifruit drink", '2018-01-14', "Drink");

  INSERT INTO Products(Amount, Price, Name, Expiration_date, Type)
        VALUES (0, 2, "matches", '2018-01-21', "Other");
  INSERT INTO Products(Amount, Price, Name, Expiration_date, Type)
        VALUES (0, 6, "battery", '2018-01-21', "Other");
  INSERT INTO Products(Amount, Price, Name, Expiration_date, Type)
        VALUES (0, 26, "painkillers", '2018-01-21', "Other");
  INSERT INTO Products(Amount, Price, Name, Expiration_date, Type)
        VALUES (0, 16, "soap", '2018-01-21', "Other");
  INSERT INTO Products(Amount, Price, Name, Expiration_date, Type)
        VALUES (0, 4, "bag", '2018-01-21', "Other");
  INSERT INTO Products(Amount, Price, Name, Expiration_date, Type)
        VALUES (0, 4, "wipes", '2018-01-21', "Other");
  INSERT INTO Products(Amount, Price, Name, Expiration_date, Type)
        VALUES (0, 6, "pen", '2018-01-21', "Other");
  INSERT INTO Products(Amount, Price, Name, Expiration_date, Type)
        VALUES (0, 8, "paper", '2018-01-21', "Other");

END$$
DELIMITER ;