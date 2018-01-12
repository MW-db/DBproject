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

CREATE PROCEDURE registerClient(IN login VARCHAR(30), IN pass VARCHAR(40), IN firstName VARCHAR(40),
                                IN surName VARCHAR(40), IN comapnyName VARCHAR(50), IN phoneNum VARCHAR(9),
                                IN adress VARCHAR(255))
  BEGIN
    IF EXISTS(SELECT * FROM Clients WHERE Login = login) THEN
      SIGNAL SQLSTATE '02000';
    END IF;

    IF phoneNum NOT LIKE("_________") THEN
      SIGNAL SQLSTATE '01000';
    END IF;

    INSERT INTO Clients(Login, Password, Name, Surname, Company, Phone, Adress, Wallet)
    VALUES (login, pass, firstName, surName, comapnyName, phoneNum, adress, 0.0);

    INSERT INTO Log(Date, User, Operation, Table_name, Column_name, Old_value, New_value, STATUS)
      VALUES ((SELECT currentDate FROM tempDate), "Server", "addClient", "Clients", "", "", login, "SUCCESS");

  END;

CREATE PROCEDURE registerWorker(IN pass VARCHAR(40), IN firstName VARCHAR(40),
                                IN surName VARCHAR(40), IN pesel VARCHAR(11),
                                IN phone VARCHAR(9), IN salary INT, IN startContract DATETIME,
                                IN endContract DATETIME)
  BEGIN
    IF pesel NOT LIKE("___________") THEN
      SIGNAL SQLSTATE '01000';
    END IF;

    IF EXISTS( SELECT * FROM Workers WHERE PESEL = pesel) THEN
      SIGNAL SQLSTATE '02000';
    END IF;

    IF (startContract > endContract)THEN
      SIGNAL SQLSTATE '01000';
    END IF;

    If (salary > 120 OR salary < 80) THEN
      SIGNAL SQLSTATE '01000';
    END IF;

    INSERT INTO Workers(Login, Password, Name, Surname, PESEL, Phone, Salary, ContractFrom, ContractTo)
      VALUES (CONCAT(SUBSTRING(firstName, -5), SUBSTRING(surName, -5), SUBSTRING(pesel, -3)),
              pass, firstName, surName, pesel, phone, salary, startContract, endContract);
    INSERT INTO Log(Date, User, Operation, Table_name, Column_name, Old_value, New_value, STATUS)
      VALUES ((SELECT currentDate FROM tempDate), "Server", "addWorker", "Workers", "", "", CONCAT(SUBSTRING(firstName, -5), SUBSTRING(surName, -5),
                                                                      SUBSTRING(pesel, -3)), "SUCCESS");
  END;

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

CREATE PROCEDURE loginClient(IN login VARCHAR(30), IN passwrod VARCHAR(40))
  BEGIN
    IF NOT EXISTS(SELECT *
                  FROM Clients
                  WHERE Login = login AND Password = passwrod)
    THEN
      SIGNAL SQLSTATE '03000';
    END IF;

    SELECT *
    FROM Clients
    WHERE Login = login;

    INSERT INTO LOG(Date, User, Operation, Table_name, Column_name, Old_value, New_value, STATUS)
    VALUES ((SELECT currentDate FROM tempDate), login, "ClientLogin", "", "", "", "", "Success");

  END;

CREATE PROCEDURE loginWorker(IN login VARCHAR(30), IN passwrod VARCHAR(40))
  BEGIN
    IF NOT EXISTS(SELECT * FROM Workers WHERE Login=login AND Password=passwrod) THEN
      SIGNAL SQLSTATE '03000';
    END IF;

    SELECT * FROM Workers WHERE Login=login;
    INSERT INTO Log(Date, User, Operation, Table_name, Column_name, Old_value, New_value, STATUS)
      VALUES ((SELECT currentDate FROM tempDate), login, "LoginClient", "", "", "", "", "SUCCESS");

  END;

DELIMITER $$
CREATE PROCEDURE nextDay()
  BEGIN
    DECLARE end INT DEFAULT 0;
    DECLARE done INT DEFAULT 0;
    DECLARE curDate DATE;
    DECLARE curExpense INT DEFAULT 0;
    DECLARE prevBalance INT;
    DECLARE cur CURSOR FOR SELECT Date, Expense FROM Balance WHERE Status = "Unpaid" AND WorkerID IS NULL;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET end = 1;

    SET curDate = (SELECT currentDate FROM tempDate);

    CALL removeExpirationProducts(curDate);
    CALL setSalaryToPay(curDate);
    CALL paySalary();

    OPEN cur;
    SET prevBalance = (SELECT Balance FROM Balance ORDER BY BalanceID DESC LIMIT 1);

    SET autocommit = 0;
    START TRANSACTION;

      payLoop: LOOP
        FETCH cur INTO curDate, curExpense;
        IF (end = 1) THEN
          SET done = 1;
          LEAVE payLoop;
        END IF;
        IF (curExpense > prevBalance) THEN
          #ROLLBACK;
          SELECT 'NOT ENOUGH MONEY' AS MESSAGE;
          LEAVE payLoop;
        END IF;
        SET prevBalance = prevBalance - curExpense;
        UPDATE Balance SET Status = "Paid", Balance = prevBalance - curExpense
          WHERE WorkerID IS NULL AND Status = "Unpaid";
      END LOOP;
    IF (done = 1) THEN
      UPDATE tempDate SET currentDate = ADDDATE(curDate, INTERVAL 1 DAY);
      COMMIT;
    END IF;
    CLOSE cur;

    INSERT INTO Log(Date, User, Operation, Table_name, Column_name, Old_value, New_value, STATUS) VALUES
      ((SELECT currentDate FROM tempDate), "Admin", "nextDay", "", "", "", "", "SUCESS");
    COMMIT ;
  END$$
DELIMITER ;

CREATE PROCEDURE paySalary()
  BEGIN
  DECLARE end INT DEFAULT 0;
  DECLARE done INT DEFAULT 0;
  DECLARE curDate DATE;
  DECLARE curExpense INT DEFAULT 0;
  DECLARE curWorkerID INT DEFAULT 0;
  DECLARE prevBalance INT;
  DECLARE cur CURSOR FOR (SELECT Date, Expense, WorkerID FROM Balance WHERE Status = "Unpaid" AND WorkerID IS NOT NULL);
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET end = 1;

  OPEN cur;
  SET prevBalance = (SELECT Balance FROM Balance ORDER BY BalanceID DESC LIMIT 1);

  SET autocommit = 0;
  START TRANSACTION;
    payLoop: LOOP
      FETCH cur INTO curDate, curExpense, curWorkerID;
      IF (end = 1) THEN
        SET done = 1;
        LEAVE payLoop;
      END IF;
      IF (curExpense > prevBalance) THEN
        ROLLBACK;
        SELECT 'NOT ENOUGH MONEY' AS MESSAGE;
        INSERT INTO LOG(Date, User, Operation, Table_name, Column_name, Old_value, New_value, STATUS) VALUES
          ((SELECT currentDate FROM tempDate), "Admin", "PaySalary", "Balance", "", "", "", "FAILED");
        LEAVE payLoop;
      END IF;
      SET prevBalance = prevBalance - curExpense;
      UPDATE Balance SET Status = "Paid", Balance = prevBalance
        WHERE WorkerID = curWorkerID AND Date = curDate AND Status = "Unpaid";
    END LOOP;
  IF (done = 1) THEN
    INSERT INTO LOG(Date, User, Operation, Table_name, Column_name, Old_value, New_value, STATUS) VALUES
          ((SELECT currentDate FROM tempDate), "Admin", "PaySalary", "Balance", "", "", "", "SUCCESS");
    COMMIT;
  END IF;
  CLOSE cur;
    COMMIT ;
END;

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


CREATE PROCEDURE setSalaryToPay(IN Ndate DATE)
  BEGIN
  DECLARE end INT DEFAULT 0;
  DECLARE done INT DEFAULT 0;
  DECLARE curSalary INT DEFAULT 0;
  DECLARE curWorkerID INT DEFAULT 0;
  DECLARE prevBalance INT;
  DECLARE cur CURSOR FOR SELECT Salary, WorkerID FROM Workers;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET end = 1;

  OPEN cur;
  SET prevBalance = (SELECT Balance FROM Balance ORDER BY BalanceID DESC LIMIT 1);

    setPayLoop: LOOP
      FETCH cur INTO curSalary, curWorkerID;
      IF (end = 1) THEN
        SET done = 1;
        LEAVE setPayLoop;
      END IF;
      INSERT INTO Balance(Date, Status, WorkerID, Fee,  Expense, Balance)
        VALUES (Ndate, "Unpaid", curWorkerID, 0, curSalary, prevBalance);
    END LOOP;
  CLOSE cur;

  INSERT INTO Log(Date, User, Operation, Table_name, Column_name, Old_value, New_value, STATUS) VALUES
    ((SELECT currentDate FROM tempDate), "Admin", "setSalaryToPay", "Balance", "", "", "", "SUCESS");

    COMMIT ;

END;

CREATE PROCEDURE updateDelivery(IN deliverID INT, IN NproductID INT, IN amount INT)
  BEGIN
    DECLARE productTypeUsage INT;
    DECLARE productTypeCapacity INT;
    DECLARE productType ENUM("Food", "Drink", "Other");

    SET productType = (SELECT Type
      FROM Products WHERE NproductID = ProductID);

    IF (productType="Food") THEN
      SET productTypeUsage = (SELECT Food_usage FROM Storage);
      SET productTypeCapacity = (SELECT Food_capacity FROM Storage);
    ELSEIF (productType="Drink") THEN
      SET productTypeUsage =(SELECT Drinks_usage FROM Storage);
      SET productTypeCapacity = (SELECT Drinks_capacity FROM Storage);
    ELSEIF (productType="Other") THEN
      SET productTypeUsage = (SELECT Others_usage FROM Storage);
      SET productTypeCapacity =(SELECT Other_capacity FROM Storage);
    END IF;

    IF ((productTypeCapacity - productTypeUsage) >= amount) THEN
      INSERT INTO itemsInDelivery(DeliveryID, ProductID, Amount)
      VALUES (deliverID, NproductID, amount);
      INSERT INTO Log(Date, User, Operation, Table_name, Column_name, Old_value, New_value, STATUS) VALUES
      ((SELECT currentDate FROM tempDate), "Worker", "updateDelivery", "productsInDelivery", "", "", NproductID, "SUCCESS");
      ELSE
        INSERT INTO Log(Date, User, Operation, Table_name, Column_name, Old_value, New_value, STATUS) VALUES
      ((SELECT currentDate FROM tempDate), "Worker", "updateDelivery", "productsInDelivery", "", "", NproductID, "FAILED");
    END IF;

    COMMIT ;
  END;

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


CREATE PROCEDURE createTransaction(IN clientID INT)
  BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE price FLOAT;
    DECLARE transID INT;
    DECLARE desiredAmount INT;
    DECLARE availableAmount INT;
    DECLARE prodID INT;
    DECLARE totalProd INT;
    DECLARE totalPrice FLOAT;
    DECLARE finished BOOL;

    DECLARE curs CURSOR FOR (SELECT P.Amount, tempCart.productID, tempCart.pieces FROM tempCart
                            JOIN Products P ON tempCart.productID = P.ProductID
                            WHERE tempCart.clientID=clientID);
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    SET totalProd = 0;
    SET finished = TRUE ;
    SET totalPrice = 0;

    SET transID = (SELECT MAX(TransactionID) FROM Transactions);
    SET transID = transID + 1;

    IF transID IS NULL THEN
      SET transID = 1;
    END IF;

    OPEN curs;

    START TRANSACTION;
    SET autocommit=0;

    INSERT INTO Transactions(TransactionID, Date, ClientID, Status, totalPrice, NumberOfProducts) VALUES (transID, NOW(), clientID, "Waiting", 0.0, 0);

    read_loop: LOOP
      FETCH curs INTO availableAmount, prodID, desiredAmount;

      IF done THEN
        LEAVE read_loop;
      END IF;

      IF desiredAmount > availableAmount THEN
        ROLLBACK;
        SET finished = FALSE ;
        DELETE FROM Transactions WHERE TransactionID=transID;
        SELECT "Transaction Failed!";
        LEAVE read_loop;
      END IF;

      UPDATE Products
      Set Products.Amount = availableAmount - desiredAmount
      WHERE Products.ProductID = prodID;

      SET totalProd = totalProd + desiredAmount;

      SET price = GetTotal(prodID) * desiredAmount;
      SET totalPrice = totalPrice + price;

      INSERT INTO itemInTransaction(transactionID, productID, amount) VALUES (transID, prodID, desiredAmount);

    END LOOP;

    #wyczysc koszyk
    DELETE FROM tempCart WHERE tempCart.clientID=clientID;

    IF finished THEN
      UPDATE Transactions
        SET Transactions.NumberOfProducts = totalProd, Transactions.TotalPrice = totalPrice
        WHERE Transactions.TransactionID = transID;
    END IF;

    COMMIT;

  END;

CREATE PROCEDURE deleteTransaction(IN transaID INT)
  BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE product INT;
    DECLARE size INT;

    DECLARE curs CURSOR FOR (SELECT itemInTransaction.productID, itemInTransaction.amount FROM itemInTransaction
                            WHERE itemInTransaction.transactionID=transaID);
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN curs;
    
    IF EXISTS(SELECT * FROM Transactions WHERE TransactionID=transaID AND Status="Waiting") THEN 

    read_loop: LOOP
      FETCH curs INTO product, size;
      IF done THEN
        LEAVE read_loop;
      END IF;

      UPDATE Products
        SET Products.Amount = Products.Amount + size
        WHERE Products.ProductID = product;

      DELETE FROM itemInTransaction
      WHERE itemInTransaction.transactionID = transaID
            AND itemInTransaction.productID = product;

    END LOOP;

    UPDATE Transactions
      SET Transactions.Status = "Declined"
      WHERE Transactions.TransactionID = transaID;

    COMMIT ;
    END IF ;

  END;


CREATE PROCEDURE payTransaction(IN transaID INT)
  BEGIN
    DECLARE prevBalance INT DEFAULT 0;
    DECLARE earn INT DEFAULT 0;

    IF EXISTS(SELECT * FROM Transactions WHERE TransactionID=transaID AND Status="Waiting") THEN
    UPDATE Transactions
      SET Transactions.Status = "Paid"
    WHERE Transactions.TransactionID=transaID;

     SET prevBalance = (SELECT Balance FROM Balance ORDER BY Date DESC LIMIT 1);
      SET earn = (SELECT TotalPrice FROM Transactions WHERE TransactionID = transaID);
      INSERT INTO Balance(Date, Status, TransactionID, Income, Balance, Fee) VALUES
        ((SELECT currentDate FROM tempDate), "Paid", transaID, earn, (prevBalance + earn), 0);

      COMMIT ;
    END IF ;

    COMMIT ;

  END;


CREATE PROCEDURE removeExpirationProducts(IN date DATE)
  BEGIN
    DECLARE end INT DEFAULT 0;
    DECLARE curAmount INT DEFAULT 0;
    DECLARE curPrice INT DEFAULT 0;
    DECLARE curProductID INT;
    DECLARE prevBalance INT;
    DECLARE sum INT DEFAULT 0;
    DECLARE cur CURSOR FOR (SELECT Amount, Price, ProductID FROM Products WHERE Expiration_date = date);
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET end = 1;

    OPEN cur;
    SET prevBalance = (SELECT Balance FROM Balance ORDER BY BalanceID DESC LIMIT 1);

      removeExpirationLoop: LOOP
        FETCH cur INTO curAmount, curPrice, curProductID;
        SET prevBalance = (SELECT Balance FROM Balance ORDER BY BalanceID DESC LIMIT 1);
        IF (end = 1) THEN
          LEAVE removeExpirationLoop;
        END IF;

        UPDATE Products SET Amount=0 WHERE ProductID=curProductID;
        SET sum = sum + (curAmount * curPrice);

        #INSERT INTO Balance(Date, Status, Fee, Expense, Balance)
        #VALUES (ADDDATE(date, INTERVAL 1 DAY), "Paid", 0, (curAmount * curPrice), prevBalance));
      END LOOP;


    IF sum > 0 THEN
    INSERT INTO Balance(Date, Status, Fee, Expense, Balance)
        VALUES (ADDDATE(date, INTERVAL 1 DAY), "Paid", 0, sum, prevBalance);
    END IF ;

    CLOSE cur;

    COMMIT ;
  END;

CREATE TRIGGER ProductsOnUpdate
  AFTER UPDATE
  ON Products
  FOR EACH ROW
  BEGIN
    IF NEW.Type="Food" THEN
      UPDATE Storage
        SET Storage.Food_usage = Storage.Food_usage +(NEW.Amount - OLD.Amount);
    ELSEIF  NEW.Type="Drink" THEN
      UPDATE Storage
        SET Storage.Drinks_usage = Storage.Drinks_usage +(NEW.Amount - OLD.Amount);
    ELSE
      UPDATE Storage
        SET Storage.Others_usage = Storage.Others_usage +(NEW.Amount - OLD.Amount);
    END IF;

    UPDATE Storage
     SET  Storage.Capacity_usage = Storage.Capacity_usage +(NEW.Amount - OLD.Amount);
    END;

CREATE TRIGGER ProductsOnInsert
  AFTER INSERT
  ON Products
  FOR EACH ROW
  BEGIN
  IF NEW.Type="Food" THEN
      UPDATE Storage
        SET Storage.Food_usage = Storage.Food_usage + NEW.Amount;
    ELSEIF  NEW.Type="Drink" THEN
      UPDATE Storage
        SET Storage.Drinks_usage = Storage.Drinks_usage + NEW.Amount;
    ELSE
      UPDATE Storage
        SET Storage.Others_usage = Storage.Others_usage + NEW.Amount;
    END IF;

    UPDATE Storage
    SET Storage.Capacity_usage = Storage.Capacity_usage + NEW.Amount;
    END;

;

CREATE TRIGGER SalesInsert
  BEFORE INSERT ON Sales
  FOR EACH ROW
    IF NEW.Date_to < NEW.Date_from THEN
      SIGNAL SQLSTATE '08000';
    END IF;

;


CREATE TRIGGER TransactionUpdate
  AFTER UPDATE
  ON Transactions
  FOR EACH ROW
  BEGIN
  IF NEW.Status="Paid" OR NEW.Status="Declined" THEN
    UPDATE Clients
      SET Clients.Wallet = Clients.Wallet - NEW.TotalPrice
      WHERE Clients.ClientID=NEW.ClientID;
    ELSEIF NEW.Status="Waiting" THEN
      UPDATE Clients
      SET Clients.Wallet = Clients.Wallet + NEW.TotalPrice
      WHERE Clients.ClientID=NEW.ClientID;
  END IF;
    END;




CREATE TRIGGER TransactionNew
  AFTER INSERT
  ON Transactions
  FOR EACH ROW
  BEGIN
  UPDATE Clients
      SET Clients.Wallet = Clients.Wallet + NEW.TotalPrice
      WHERE Clients.ClientID=NEW.ClientID;
    END;


CREATE TRIGGER DeleteEndSalesAndWorkers
AFTER UPDATE ON tempDate
FOR EACH ROW
  BEGIN
    DELETE FROM Sales WHERE Sales.Date_to=NEW.currentDate;
    DELETE FROM Workers WHERE Workers.ContractTo=NEW.currentDate;
   END;
