-- MySQL dump 10.16  Distrib 10.2.12-MariaDB, for osx10.13 (x86_64)
--
-- Host: localhost    Database: supershop
-- ------------------------------------------------------
-- Server version	10.2.12-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Balance`
--

DROP TABLE IF EXISTS `Balance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Balance` (
  `Date` date NOT NULL,
  `Status` enum('Paid','Unpaid','Received','Canceled') DEFAULT NULL,
  `DeliveryID` int(11) DEFAULT NULL,
  `WorkerID` int(11) DEFAULT NULL,
  `TransactionID` int(11) DEFAULT NULL,
  `Fee` int(11) NOT NULL,
  `Income` int(11) DEFAULT NULL,
  `Expense` int(11) DEFAULT NULL,
  `Balance` int(11) NOT NULL,
  KEY `WorkerID` (`WorkerID`),
  KEY `TransactionID` (`TransactionID`),
  KEY `DeliveryID` (`DeliveryID`),
  CONSTRAINT `balance_ibfk_1` FOREIGN KEY (`WorkerID`) REFERENCES `Workers` (`WorkerID`),
  CONSTRAINT `balance_ibfk_2` FOREIGN KEY (`TransactionID`) REFERENCES `Transactions` (`TransactionID`),
  CONSTRAINT `balance_ibfk_3` FOREIGN KEY (`DeliveryID`) REFERENCES `Delivery` (`DeliveryID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Balance`
--

LOCK TABLES `Balance` WRITE;
/*!40000 ALTER TABLE `Balance` DISABLE KEYS */;
/*!40000 ALTER TABLE `Balance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Clients`
--

DROP TABLE IF EXISTS `Clients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Clients` (
  `ClientID` int(11) NOT NULL AUTO_INCREMENT,
  `Login` varchar(30) NOT NULL,
  `Password` varchar(40) NOT NULL,
  `Name` varchar(40) NOT NULL,
  `Surname` varchar(40) NOT NULL,
  `Company` varchar(50) DEFAULT NULL,
  `Phone` varchar(9) NOT NULL,
  `Adress` varchar(255) NOT NULL,
  `Wallet` int(11) NOT NULL,
  PRIMARY KEY (`ClientID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Clients`
--

LOCK TABLES `Clients` WRITE;
/*!40000 ALTER TABLE `Clients` DISABLE KEYS */;
/*!40000 ALTER TABLE `Clients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Delivery`
--

DROP TABLE IF EXISTS `Delivery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Delivery` (
  `DeliveryID` int(11) NOT NULL AUTO_INCREMENT,
  `Order_date` date NOT NULL,
  `Receiving_date` date NOT NULL,
  `Status` enum('Created','Ordered','Received') DEFAULT NULL,
  PRIMARY KEY (`DeliveryID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Delivery`
--

LOCK TABLES `Delivery` WRITE;
/*!40000 ALTER TABLE `Delivery` DISABLE KEYS */;
/*!40000 ALTER TABLE `Delivery` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `History`
--

DROP TABLE IF EXISTS `History`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `History` (
  `ClientID` int(11) NOT NULL,
  `ProductID` int(11) NOT NULL,
  `Quantity` int(11) NOT NULL,
  `Price` int(11) NOT NULL,
  `Data` date NOT NULL,
  KEY `ClientID` (`ClientID`),
  KEY `ProductID` (`ProductID`),
  CONSTRAINT `history_ibfk_1` FOREIGN KEY (`ClientID`) REFERENCES `Clients` (`ClientID`),
  CONSTRAINT `history_ibfk_2` FOREIGN KEY (`ProductID`) REFERENCES `Products` (`ProductID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `History`
--

LOCK TABLES `History` WRITE;
/*!40000 ALTER TABLE `History` DISABLE KEYS */;
/*!40000 ALTER TABLE `History` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Log`
--

DROP TABLE IF EXISTS `Log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Log` (
  `Date` date NOT NULL,
  `User` varchar(25) DEFAULT NULL,
  `Operation` varchar(125) DEFAULT NULL,
  `Table_name` varchar(50) DEFAULT NULL,
  `Column_name` varchar(60) DEFAULT NULL,
  `Old_value` varchar(70) DEFAULT NULL,
  `New_value` varchar(70) DEFAULT NULL,
  `STATUS` varchar(70) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Log`
--

LOCK TABLES `Log` WRITE;
/*!40000 ALTER TABLE `Log` DISABLE KEYS */;
/*!40000 ALTER TABLE `Log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Products`
--

DROP TABLE IF EXISTS `Products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Products` (
  `ProductID` int(11) NOT NULL AUTO_INCREMENT,
  `Amount` int(11) NOT NULL,
  `Price` int(11) NOT NULL,
  `Name` varchar(50) DEFAULT NULL,
  `Expiration_date` date NOT NULL,
  `Type` enum('Food','Drink','Other') DEFAULT NULL,
  PRIMARY KEY (`ProductID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Products`
--

LOCK TABLES `Products` WRITE;
/*!40000 ALTER TABLE `Products` DISABLE KEYS */;
/*!40000 ALTER TABLE `Products` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER ProductsOnInsert
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
    END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER ProductsOnUpdate
  AFTER UPDATE ON Products
  FOR EACH ROW
  BEGIN
    IF NEW.Type="Food" THEN
      UPDATE Storage
        SET Storage.Food_usage = Storage.Food_usage +(NEW.Amount - OLD.Amount);
    ELSEIF  NEW.Type="Drink" THEN
      UPDATE Storage
        SET Storage.Food_usage = Storage.Drinks_usage +(NEW.Amount - OLD.Amount);
    ELSE
      UPDATE Storage
        SET Storage.Food_usage = Storage.Drinks_usage +(NEW.Amount - OLD.Amount);
    END IF;

    UPDATE Storage
     SET  Storage.Capacity_usage = Storage.Capacity_usage +(NEW.Amount - OLD.Amount);
    END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Sales`
--

DROP TABLE IF EXISTS `Sales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Sales` (
  `SaleID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `Date_from` date NOT NULL,
  `Date_to` date NOT NULL,
  `ProductID` int(11) NOT NULL,
  `Price` int(11) NOT NULL,
  PRIMARY KEY (`SaleID`),
  KEY `ProductID` (`ProductID`),
  CONSTRAINT `sales_ibfk_1` FOREIGN KEY (`ProductID`) REFERENCES `Products` (`ProductID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Sales`
--

LOCK TABLES `Sales` WRITE;
/*!40000 ALTER TABLE `Sales` DISABLE KEYS */;
/*!40000 ALTER TABLE `Sales` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER SalesInsert
  BEFORE INSERT ON Sales
  FOR EACH ROW
    IF NEW.Date_to < NEW.Date_from THEN
      SIGNAL SQLSTATE '08000';
    END IF */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Storage`
--

DROP TABLE IF EXISTS `Storage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Storage` (
  `Capacity` int(11) NOT NULL,
  `Food_capacity` int(11) NOT NULL,
  `Drinks_capacity` int(11) NOT NULL,
  `Other_capacity` int(11) NOT NULL,
  `Capacity_usage` int(11) NOT NULL,
  `Food_usage` int(11) NOT NULL,
  `Drinks_usage` int(11) NOT NULL,
  `Others_usage` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Storage`
--

LOCK TABLES `Storage` WRITE;
/*!40000 ALTER TABLE `Storage` DISABLE KEYS */;
/*!40000 ALTER TABLE `Storage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Transactions`
--

DROP TABLE IF EXISTS `Transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Transactions` (
  `TransactionID` int(11) NOT NULL AUTO_INCREMENT,
  `Date` date NOT NULL,
  `ClientID` int(11) NOT NULL,
  `TotalPrice` int(11) NOT NULL,
  `NumberOfProducts` int(11) NOT NULL,
  `Status` enum('Waiting','Declined','Accepted','Paid') DEFAULT NULL,
  PRIMARY KEY (`TransactionID`),
  KEY `ClientID` (`ClientID`),
  CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`ClientID`) REFERENCES `Clients` (`ClientID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Transactions`
--

LOCK TABLES `Transactions` WRITE;
/*!40000 ALTER TABLE `Transactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `Transactions` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER TransactionNew
  AFTER INSERT ON Transactions
  FOR EACH ROW
    UPDATE Clients
      SET Clients.Wallet = Clients.Wallet + NEW.TotalPrice
      WHERE Clients.ClientID=NEW.ClientID */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER TransactionUpdate
  AFTER UPDATE ON Transactions
  FOR EACH ROW
  IF NEW.Status="Paid" OR NEW.Status="Declined" THEN
    UPDATE Clients
      SET Clients.Wallet = Clients.Wallet - NEW.TotalPrice
      WHERE Clients.ClientID=NEW.ClientID;
  END IF */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Workers`
--

DROP TABLE IF EXISTS `Workers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Workers` (
  `WorkerID` int(11) NOT NULL AUTO_INCREMENT,
  `Login` varchar(30) NOT NULL,
  `Password` varchar(40) NOT NULL,
  `Name` varchar(40) NOT NULL,
  `Surname` varchar(40) NOT NULL,
  `PESEL` varchar(11) NOT NULL,
  `Phone` varchar(9) NOT NULL,
  `Salary` int(11) NOT NULL,
  `ContractFrom` date NOT NULL,
  `ContractTo` date DEFAULT NULL,
  PRIMARY KEY (`WorkerID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Workers`
--

LOCK TABLES `Workers` WRITE;
/*!40000 ALTER TABLE `Workers` DISABLE KEYS */;
/*!40000 ALTER TABLE `Workers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `itemInTransaction`
--

DROP TABLE IF EXISTS `itemInTransaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itemInTransaction` (
  `transactionID` int(11) NOT NULL,
  `productID` int(11) NOT NULL,
  `amount` int(11) DEFAULT NULL,
  KEY `transactionID` (`transactionID`),
  KEY `productID` (`productID`),
  CONSTRAINT `itemintransaction_ibfk_1` FOREIGN KEY (`transactionID`) REFERENCES `Transactions` (`TransactionID`),
  CONSTRAINT `itemintransaction_ibfk_2` FOREIGN KEY (`productID`) REFERENCES `Products` (`ProductID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `itemInTransaction`
--

LOCK TABLES `itemInTransaction` WRITE;
/*!40000 ALTER TABLE `itemInTransaction` DISABLE KEYS */;
/*!40000 ALTER TABLE `itemInTransaction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `itemsInDelivery`
--

DROP TABLE IF EXISTS `itemsInDelivery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itemsInDelivery` (
  `DeliveryID` int(11) NOT NULL,
  `ProductID` int(11) NOT NULL,
  `Amount` int(11) NOT NULL,
  KEY `DeliveryID` (`DeliveryID`),
  KEY `ProductID` (`ProductID`),
  CONSTRAINT `itemsindelivery_ibfk_1` FOREIGN KEY (`DeliveryID`) REFERENCES `Delivery` (`DeliveryID`),
  CONSTRAINT `itemsindelivery_ibfk_2` FOREIGN KEY (`ProductID`) REFERENCES `Products` (`ProductID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `itemsInDelivery`
--

LOCK TABLES `itemsInDelivery` WRITE;
/*!40000 ALTER TABLE `itemsInDelivery` DISABLE KEYS */;
/*!40000 ALTER TABLE `itemsInDelivery` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tempCart`
--

DROP TABLE IF EXISTS `tempCart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tempCart` (
  `clientID` int(11) NOT NULL,
  `productID` int(11) NOT NULL,
  `pieces` int(11) NOT NULL,
  KEY `clientID` (`clientID`),
  KEY `productID` (`productID`),
  CONSTRAINT `tempcart_ibfk_1` FOREIGN KEY (`clientID`) REFERENCES `Clients` (`ClientID`),
  CONSTRAINT `tempcart_ibfk_2` FOREIGN KEY (`productID`) REFERENCES `Products` (`ProductID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tempCart`
--

LOCK TABLES `tempCart` WRITE;
/*!40000 ALTER TABLE `tempCart` DISABLE KEYS */;
/*!40000 ALTER TABLE `tempCart` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-01-12  2:35:52
