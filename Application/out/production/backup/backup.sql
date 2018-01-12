-- MySQL dump 10.16  Distrib 10.1.25-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: supershop
-- ------------------------------------------------------
-- Server version	10.1.25-MariaDB-1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `supershop`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `supershop` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;

USE `supershop`;

--
-- Table structure for table `Balance`
--

DROP TABLE IF EXISTS `Balance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Balance` (
  `BalanceID` int(11) NOT NULL AUTO_INCREMENT,
  `Date` date NOT NULL,
  `Status` enum('Paid','Unpaid','Received','Canceled') DEFAULT NULL,
  `DeliveryID` int(11) DEFAULT NULL,
  `WorkerID` int(11) DEFAULT NULL,
  `TransactionID` int(11) DEFAULT NULL,
  `Fee` int(11) NOT NULL,
  `Income` int(11) DEFAULT NULL,
  `Expense` int(11) DEFAULT NULL,
  `Balance` int(11) NOT NULL,
  PRIMARY KEY (`BalanceID`),
  KEY `WorkerID` (`WorkerID`),
  KEY `TransactionID` (`TransactionID`),
  KEY `DeliveryID` (`DeliveryID`),
  CONSTRAINT `Balance_ibfk_1` FOREIGN KEY (`WorkerID`) REFERENCES `Workers` (`WorkerID`),
  CONSTRAINT `Balance_ibfk_2` FOREIGN KEY (`TransactionID`) REFERENCES `Transactions` (`TransactionID`),
  CONSTRAINT `Balance_ibfk_3` FOREIGN KEY (`DeliveryID`) REFERENCES `Delivery` (`DeliveryID`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Balance`
--

LOCK TABLES `Balance` WRITE;
/*!40000 ALTER TABLE `Balance` DISABLE KEYS */;
INSERT INTO `Balance` VALUES (1,'2018-01-01',NULL,NULL,NULL,NULL,0,10000,NULL,10000),(2,'2018-01-12','Paid',NULL,1,NULL,0,NULL,80,9920),(3,'2018-01-12','Paid',NULL,2,NULL,0,NULL,100,9820),(4,'2018-01-12','Paid',NULL,1,NULL,0,NULL,80,9740),(5,'2018-01-12','Paid',NULL,2,NULL,0,NULL,100,9640),(6,'2018-01-12','Paid',NULL,1,NULL,0,NULL,80,9560),(7,'2018-01-12','Paid',NULL,2,NULL,0,NULL,100,9460),(8,'2018-01-13','Paid',NULL,1,NULL,0,NULL,80,9380),(9,'2018-01-13','Paid',NULL,2,NULL,0,NULL,100,9280),(10,'2018-01-14','Paid',NULL,1,NULL,0,NULL,80,9200),(11,'2018-01-14','Paid',NULL,2,NULL,0,NULL,100,9100),(12,'2018-01-16','Paid',NULL,NULL,NULL,0,NULL,30,9100),(13,'2018-01-15','Paid',NULL,1,NULL,0,NULL,80,9020),(14,'2018-01-15','Paid',NULL,2,NULL,0,NULL,100,8920),(15,'2018-01-16','Paid',NULL,NULL,3,0,316,NULL,9416),(16,'2018-01-18','Received',1,NULL,NULL,0,NULL,180,9820);
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Clients`
--

LOCK TABLES `Clients` WRITE;
/*!40000 ALTER TABLE `Clients` DISABLE KEYS */;
INSERT INTO `Clients` VALUES (1,'dasd','das','das','dsa','dsad','123432654','ddasdfasfgg',0);
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
  `Status` enum('Created','Ordered','Received','Canceled') DEFAULT NULL,
  PRIMARY KEY (`DeliveryID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Delivery`
--

LOCK TABLES `Delivery` WRITE;
/*!40000 ALTER TABLE `Delivery` DISABLE KEYS */;
INSERT INTO `Delivery` VALUES (1,'2018-01-16','2018-01-18','Received');
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
  CONSTRAINT `History_ibfk_1` FOREIGN KEY (`ClientID`) REFERENCES `Clients` (`ClientID`),
  CONSTRAINT `History_ibfk_2` FOREIGN KEY (`ProductID`) REFERENCES `Products` (`ProductID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Log`
--

LOCK TABLES `Log` WRITE;
/*!40000 ALTER TABLE `Log` DISABLE KEYS */;
INSERT INTO `Log` VALUES ('2018-01-12','Admin','setSalaryToPay','Balance','','','','SUCESS'),('2018-01-12','Admin','setSalaryToPay','Balance','','','','SUCESS'),('2018-01-12','Admin','setSalaryToPay','Balance','','','','SUCESS'),('2018-01-12','Admin','PaySalary','Balance','','','','SUCCESS'),('2018-01-13','Admin','nextDay','','','','','SUCESS'),('2018-01-13','Admin','setSalaryToPay','Balance','','','','SUCESS'),('2018-01-13','Admin','PaySalary','Balance','','','','SUCCESS'),('2018-01-14','Admin','nextDay','','','','','SUCESS'),('2018-01-14','Admin','setSalaryToPay','Balance','','','','SUCESS'),('2018-01-14','Admin','PaySalary','Balance','','','','SUCCESS'),('2018-01-15','Admin','nextDay','','','','','SUCESS'),('2018-01-15','Admin','setSalaryToPay','Balance','','','','SUCESS'),('2018-01-15','Admin','PaySalary','Balance','','','','SUCCESS'),('2018-01-16','Admin','nextDay','','','','','SUCESS'),('2018-01-16','Worker','createDelivery','Delivery','','','','SUCCESS'),('2018-01-16','Worker','updateDelivery','productsInDelivery','','','1','FAILED'),('2018-01-16','Worker','updateDelivery','productsInDelivery','','','1','SUCCESS'),('2018-01-16','Worker','updateDelivery','productsInDelivery','','','11','SUCCESS'),('2018-01-16','Worker','ReceiveDelivery','Delivery','','','','SUCCESS'),('2018-01-16','Admin','PaySalary','Balance','','','','SUCCESS'),('2018-01-16','Admin','PaySalary','Balance','','','','SUCCESS'),('2018-01-16','Admin','PaySalary','Balance','','','','SUCCESS'),('2018-01-16','Admin','PaySalary','Balance','','','','SUCCESS'),('2018-01-16','Admin','PaySalary','Balance','','','','SUCCESS'),('2018-01-16','Admin','PaySalary','Balance','','','','SUCCESS'),('2018-01-16','Admin','PaySalary','Balance','','','','SUCCESS'),('2018-01-16','Admin','PaySalary','Balance','','','','SUCCESS'),('2018-01-16','Admin','PaySalary','Balance','','','','SUCCESS');
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
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Products`
--

LOCK TABLES `Products` WRITE;
/*!40000 ALTER TABLE `Products` DISABLE KEYS */;
INSERT INTO `Products` VALUES (1,10,6,'bread','2018-01-25','Food'),(2,2,4,'roll','2018-01-26','Food'),(3,15,4,'yoghurt','2018-01-31','Food'),(4,7,8,'cheese','2018-01-24','Food'),(5,0,6,'ham','2018-01-07','Food'),(6,0,12,'butter','2018-01-07','Food'),(7,0,4,'candy bar','2018-01-07','Food'),(8,0,8,'sugar','2018-01-07','Food'),(9,0,8,'flour','2018-01-07','Food'),(10,0,4,'water','2018-01-14','Drink'),(11,20,6,'orange juice','2018-02-01','Drink'),(12,13,6,'apple juice','2018-01-30','Drink'),(13,32,8,'coca cola','2018-01-31','Drink'),(14,0,14,'energy drink','2018-01-14','Drink'),(15,0,8,'pepsi','2018-01-14','Drink'),(16,0,6,'multifruit drink','2018-01-14','Drink'),(17,0,2,'matches','2018-01-21','Other'),(18,0,6,'battery','2018-01-21','Other'),(19,0,26,'painkillers','2018-01-21','Other'),(20,0,16,'soap','2018-01-21','Other'),(21,0,4,'bag','2018-01-21','Other'),(22,0,4,'wipes','2018-01-21','Other'),(23,0,6,'pen','2018-01-21','Other'),(24,10,8,'paper','2018-01-24','Other');
/*!40000 ALTER TABLE `Products` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
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
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER ProductsOnUpdate
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
  CONSTRAINT `Sales_ibfk_1` FOREIGN KEY (`ProductID`) REFERENCES `Products` (`ProductID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Sales`
--

LOCK TABLES `Sales` WRITE;
/*!40000 ALTER TABLE `Sales` DISABLE KEYS */;
INSERT INTO `Sales` VALUES (2,'Janusz deal','2018-01-04','2018-01-26',1,1);
/*!40000 ALTER TABLE `Sales` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Storage`
--

LOCK TABLES `Storage` WRITE;
/*!40000 ALTER TABLE `Storage` DISABLE KEYS */;
INSERT INTO `Storage` VALUES (500,200,200,100,109,34,50,10);
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
  CONSTRAINT `Transactions_ibfk_1` FOREIGN KEY (`ClientID`) REFERENCES `Clients` (`ClientID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Transactions`
--

LOCK TABLES `Transactions` WRITE;
/*!40000 ALTER TABLE `Transactions` DISABLE KEYS */;
INSERT INTO `Transactions` VALUES (2,'2018-01-12',1,0,0,'Waiting'),(3,'2018-01-12',1,316,41,'Paid');
/*!40000 ALTER TABLE `Transactions` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER TransactionNew
  AFTER INSERT
  ON Transactions
  FOR EACH ROW
  BEGIN
  UPDATE Clients
      SET Clients.Wallet = Clients.Wallet + NEW.TotalPrice
      WHERE Clients.ClientID=NEW.ClientID;
    END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER TransactionUpdate
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
    END */;;
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Workers`
--

LOCK TABLES `Workers` WRITE;
/*!40000 ALTER TABLE `Workers` DISABLE KEYS */;
INSERT INTO `Workers` VALUES (1,'asd','dsadsff','sdfsf','fsdfs','12345678901','123456789',80,'2018-01-04','2018-01-19'),(2,'gdsh','dsdfk','ffds','fdsgfd','09876543211','019283746',100,'2018-01-02','2018-01-26');
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
  CONSTRAINT `itemInTransaction_ibfk_1` FOREIGN KEY (`transactionID`) REFERENCES `Transactions` (`TransactionID`),
  CONSTRAINT `itemInTransaction_ibfk_2` FOREIGN KEY (`productID`) REFERENCES `Products` (`ProductID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `itemInTransaction`
--

LOCK TABLES `itemInTransaction` WRITE;
/*!40000 ALTER TABLE `itemInTransaction` DISABLE KEYS */;
INSERT INTO `itemInTransaction` VALUES (3,2,3),(3,4,5),(3,24,33);
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
  CONSTRAINT `itemsInDelivery_ibfk_1` FOREIGN KEY (`DeliveryID`) REFERENCES `Delivery` (`DeliveryID`),
  CONSTRAINT `itemsInDelivery_ibfk_2` FOREIGN KEY (`ProductID`) REFERENCES `Products` (`ProductID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
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
  CONSTRAINT `tempCart_ibfk_1` FOREIGN KEY (`clientID`) REFERENCES `Clients` (`ClientID`),
  CONSTRAINT `tempCart_ibfk_2` FOREIGN KEY (`productID`) REFERENCES `Products` (`ProductID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tempCart`
--

LOCK TABLES `tempCart` WRITE;
/*!40000 ALTER TABLE `tempCart` DISABLE KEYS */;
/*!40000 ALTER TABLE `tempCart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tempDate`
--

DROP TABLE IF EXISTS `tempDate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tempDate` (
  `currentDate` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tempDate`
--

LOCK TABLES `tempDate` WRITE;
/*!40000 ALTER TABLE `tempDate` DISABLE KEYS */;
INSERT INTO `tempDate` VALUES ('2018-01-16');
/*!40000 ALTER TABLE `tempDate` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER DeleteEndSalesAndWorkers
AFTER UPDATE ON tempDate
FOR EACH ROW
  BEGIN
    DELETE FROM Sales WHERE Sales.Date_to=NEW.currentDate;
    DELETE FROM Workers WHERE Workers.ContractTo=NEW.currentDate;
   END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-01-12 22:22:09
