##Calculate income function
CREATE FUNCTION calculateIncome() RETURNS FLOAT
  BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE total FLOAT;
    DECLARE actual FLOAT;

    DECLARE curs CURSOR FOR (SELECT Income FROM Balance);

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    SET total = 0.0;

    OPEN curs;

    read_loop : LOOP
      FETCH curs INTO actual;
      IF done THEN
        LEAVE read_loop;
      END IF;

      IF (actual IS NOT NULL ) THEN
        Set total = total + actual;
      END IF;

    END LOOP;

    RETURN total;

  END;
  
  ##Calculate expenses function
  CREATE FUNCTION calculateExpenses() RETURNS FLOAT
  BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE total FLOAT;
    DECLARE actual FLOAT;

    DECLARE curs CURSOR FOR (SELECT Expense FROM Balance);

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    SET total = 0.0;

    OPEN curs;

    read_loop : LOOP
      FETCH curs INTO actual;
      IF done THEN
        LEAVE read_loop;
      END IF;

      IF (actual IS NOT NULL ) THEN
        Set total = total + actual;
      END IF;

    END LOOP;

    RETURN total;

  END;
  
  
  ## calculate Balance function
  CREATE FUNCTION calculateBalance() RETURNS FLOAT
  BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE total FLOAT;
    DECLARE actual FLOAT;

    DECLARE curs CURSOR FOR (SELECT Balance FROM Balance);

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    SET total = 0.0;

    OPEN curs;

    read_loop : LOOP
      FETCH curs INTO actual;
      IF done THEN
        LEAVE read_loop;
      END IF;

      IF (actual IS NOT NULL ) THEN
        Set total = total + actual;
      END IF;

    END LOOP;

    RETURN total;

  END;
  
  ## function to calculate food storage
  CREATE FUNCTION calculateFoodStorage() RETURNS INT
  BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE total FLOAT;
    DECLARE actual FLOAT;

    DECLARE curs CURSOR FOR (SELECT Amount FROM Products
                            WHERE Type="Food");

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    SET total = 0.0;

    OPEN curs;

    read_loop : LOOP
      FETCH curs INTO actual;
      IF done THEN
        LEAVE read_loop;
      END IF;

      IF (actual IS NOT NULL ) THEN
        Set total = total + actual;
      END IF;

    END LOOP;

    RETURN total;

  END;
  
  ## function to calculate drink storage
  CREATE FUNCTION calculateDrinkStorage() RETURNS INT
  BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE total FLOAT;
    DECLARE actual FLOAT;

    DECLARE curs CURSOR FOR (SELECT Amount FROM Products
                            WHERE Type="Drink");

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    SET total = 0.0;

    OPEN curs;

    read_loop : LOOP
      FETCH curs INTO actual;
      IF done THEN
        LEAVE read_loop;
      END IF;

      IF (actual IS NOT NULL ) THEN
        Set total = total + actual;
      END IF;

    END LOOP;

    RETURN total;

  END;
  
  ##Function to calculate other storage
  
  CREATE FUNCTION calculateOtherStorage() RETURNS INT
  BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE total FLOAT;
    DECLARE actual FLOAT;

    DECLARE curs CURSOR FOR (SELECT Amount FROM Products
                            WHERE Type="Other");

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    SET total = 0.0;

    OPEN curs;

    read_loop : LOOP
      FETCH curs INTO actual;
      IF done THEN
        LEAVE read_loop;
      END IF;

      IF (actual IS NOT NULL ) THEN
        Set total = total + actual;
      END IF;

    END LOOP;

    RETURN total;

  END;