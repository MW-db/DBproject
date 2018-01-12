-- MySQL dump 10.16  Distrib 10.2.9-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: supershopmanager
-- ------------------------------------------------------
-- Server version	10.2.9-MariaDB

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
-- Current Database: `supershopmanager`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `supershopmanager` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `supershopmanager`;

--
-- Table structure for table `balance`
--

DROP TABLE IF EXISTS `balance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `balance` (
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
  CONSTRAINT `balance_ibfk_1` FOREIGN KEY (`WorkerID`) REFERENCES `workers` (`WorkerID`),
  CONSTRAINT `balance_ibfk_2` FOREIGN KEY (`TransactionID`) REFERENCES `transactions` (`TransactionID`),
  CONSTRAINT `balance_ibfk_3` FOREIGN KEY (`DeliveryID`) REFERENCES `delivery` (`DeliveryID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `balance`
--

LOCK TABLES `balance` WRITE;
/*!40000 ALTER TABLE `balance` DISABLE KEYS */;
INSERT INTO `balance` VALUES ('2018-01-01',NULL,NULL,NULL,NULL,0,10000,NULL,10000),('2018-01-01',NULL,NULL,NULL,NULL,0,10000,NULL,10000);
/*!40000 ALTER TABLE `balance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clients`
--

DROP TABLE IF EXISTS `clients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `clients` (
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clients`
--

LOCK TABLES `clients` WRITE;
/*!40000 ALTER TABLE `clients` DISABLE KEYS */;
INSERT INTO `clients` VALUES (1,'qwerty','123456','abc','zxc','2018-01-07','123456789','abc 3/4',0);
/*!40000 ALTER TABLE `clients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `delivery`
--

DROP TABLE IF EXISTS `delivery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `delivery` (
  `DeliveryID` int(11) NOT NULL AUTO_INCREMENT,
  `Order_date` date NOT NULL,
  `Receiving_date` date NOT NULL,
  `Status` enum('Created','Ordered','Received') DEFAULT NULL,
  PRIMARY KEY (`DeliveryID`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `delivery`
--

LOCK TABLES `delivery` WRITE;
/*!40000 ALTER TABLE `delivery` DISABLE KEYS */;
INSERT INTO `delivery` VALUES (1,'2018-01-07','2018-01-08','Created'),(4,'2018-01-07','2018-01-09','Created'),(6,'2018-01-07','2018-01-09','Created'),(7,'2018-01-07','2018-01-09','Created');
/*!40000 ALTER TABLE `delivery` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `history`
--

DROP TABLE IF EXISTS `history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `history` (
  `ClientID` int(11) NOT NULL,
  `ProductID` int(11) NOT NULL,
  `Quantity` int(11) NOT NULL,
  `Price` int(11) NOT NULL,
  `Data` date NOT NULL,
  KEY `ClientID` (`ClientID`),
  KEY `ProductID` (`ProductID`),
  CONSTRAINT `history_ibfk_1` FOREIGN KEY (`ClientID`) REFERENCES `clients` (`ClientID`),
  CONSTRAINT `history_ibfk_2` FOREIGN KEY (`ProductID`) REFERENCES `products` (`ProductID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `history`
--

LOCK TABLES `history` WRITE;
/*!40000 ALTER TABLE `history` DISABLE KEYS */;
/*!40000 ALTER TABLE `history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `itemintransaction`
--

DROP TABLE IF EXISTS `itemintransaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itemintransaction` (
  `transactionID` int(11) NOT NULL,
  `productID` int(11) NOT NULL,
  KEY `transactionID` (`transactionID`),
  KEY `productID` (`productID`),
  CONSTRAINT `itemintransaction_ibfk_1` FOREIGN KEY (`transactionID`) REFERENCES `transactions` (`TransactionID`),
  CONSTRAINT `itemintransaction_ibfk_2` FOREIGN KEY (`productID`) REFERENCES `products` (`ProductID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `itemintransaction`
--

LOCK TABLES `itemintransaction` WRITE;
/*!40000 ALTER TABLE `itemintransaction` DISABLE KEYS */;
/*!40000 ALTER TABLE `itemintransaction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `itemsindelivery`
--

DROP TABLE IF EXISTS `itemsindelivery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itemsindelivery` (
  `DeliveryID` int(11) NOT NULL,
  `ProductID` int(11) NOT NULL,
  `Amount` int(11) NOT NULL,
  KEY `DeliveryID` (`DeliveryID`),
  KEY `ProductID` (`ProductID`),
  CONSTRAINT `itemsindelivery_ibfk_1` FOREIGN KEY (`DeliveryID`) REFERENCES `delivery` (`DeliveryID`),
  CONSTRAINT `itemsindelivery_ibfk_2` FOREIGN KEY (`ProductID`) REFERENCES `products` (`ProductID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `itemsindelivery`
--

LOCK TABLES `itemsindelivery` WRITE;
/*!40000 ALTER TABLE `itemsindelivery` DISABLE KEYS */;
/*!40000 ALTER TABLE `itemsindelivery` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log`
--

DROP TABLE IF EXISTS `log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log` (
  `Date` date NOT NULL,
  `User` varchar(25) DEFAULT NULL,
  `Operation` varchar(125) DEFAULT NULL,
  `Table_name` varchar(50) DEFAULT NULL,
  `Column_name` varchar(60) DEFAULT NULL,
  `Old_value` varchar(70) DEFAULT NULL,
  `New_value` varchar(70) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log`
--

LOCK TABLES `log` WRITE;
/*!40000 ALTER TABLE `log` DISABLE KEYS */;
/*!40000 ALTER TABLE `log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `products` (
  `ProductID` int(11) NOT NULL AUTO_INCREMENT,
  `Amount` int(11) NOT NULL,
  `Price` int(11) NOT NULL,
  `Name` varchar(50) DEFAULT NULL,
  `Expiration_date` date NOT NULL,
  `Type` enum('Food','Drink','Other') DEFAULT NULL,
  PRIMARY KEY (`ProductID`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,0,6,'bread','2018-01-07','Food'),(2,0,4,'roll','2018-01-07','Food'),(3,0,4,'yoghurt','2018-01-07','Food'),(4,0,8,'cheese','2018-01-07','Food'),(5,0,6,'ham','2018-01-07','Food'),(6,0,12,'butter','2018-01-07','Food'),(7,0,4,'candy bar','2018-01-07','Food'),(8,0,8,'sugar','2018-01-07','Food'),(9,0,8,'flour','2018-01-07','Food'),(10,0,4,'water','2018-01-14','Drink'),(11,0,6,'orange juice','2018-01-14','Drink'),(12,0,6,'apple juice','2018-01-14','Drink'),(13,0,8,'coca cola','2018-01-14','Drink'),(14,0,14,'energy drink','2018-01-14','Drink'),(15,0,8,'pepsi','2018-01-14','Drink'),(16,0,6,'multifruit drink','2018-01-14','Drink'),(17,0,2,'matches','2018-01-21','Other'),(18,0,6,'battery','2018-01-21','Other'),(19,0,26,'painkillers','2018-01-21','Other'),(20,0,16,'soap','2018-01-21','Other'),(21,0,4,'bag','2018-01-21','Other'),(22,0,4,'wipes','2018-01-21','Other'),(23,0,6,'pen','2018-01-21','Other'),(24,0,8,'paper','2018-01-21','Other');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales`
--

DROP TABLE IF EXISTS `sales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sales` (
  `SaleID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `Date_from` date NOT NULL,
  `Date_to` date NOT NULL,
  `ProductID` int(11) NOT NULL,
  `Price` int(11) NOT NULL,
  `Quantity` int(11) NOT NULL,
  PRIMARY KEY (`SaleID`),
  KEY `ProductID` (`ProductID`),
  CONSTRAINT `sales_ibfk_1` FOREIGN KEY (`ProductID`) REFERENCES `products` (`ProductID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales`
--

LOCK TABLES `sales` WRITE;
/*!40000 ALTER TABLE `sales` DISABLE KEYS */;
/*!40000 ALTER TABLE `sales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `storage`
--

DROP TABLE IF EXISTS `storage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `storage` (
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
-- Dumping data for table `storage`
--

LOCK TABLES `storage` WRITE;
/*!40000 ALTER TABLE `storage` DISABLE KEYS */;
INSERT INTO `storage` VALUES (500,200,200,100,0,0,0,0);
/*!40000 ALTER TABLE `storage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tempcart`
--

DROP TABLE IF EXISTS `tempcart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tempcart` (
  `clientID` int(11) NOT NULL,
  `productID` int(11) NOT NULL,
  `pieces` int(11) NOT NULL,
  KEY `clientID` (`clientID`),
  KEY `productID` (`productID`),
  CONSTRAINT `tempcart_ibfk_1` FOREIGN KEY (`clientID`) REFERENCES `clients` (`ClientID`),
  CONSTRAINT `tempcart_ibfk_2` FOREIGN KEY (`productID`) REFERENCES `products` (`ProductID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tempcart`
--

LOCK TABLES `tempcart` WRITE;
/*!40000 ALTER TABLE `tempcart` DISABLE KEYS */;
/*!40000 ALTER TABLE `tempcart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transactions`
--

DROP TABLE IF EXISTS `transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transactions` (
  `TransactionID` int(11) NOT NULL AUTO_INCREMENT,
  `Date` date NOT NULL,
  `ClientID` int(11) NOT NULL,
  `TotalPrice` int(11) NOT NULL,
  `NumberOfProducts` int(11) NOT NULL,
  `Status` enum('Waiting','Declined','Accepted','Paid') DEFAULT NULL,
  PRIMARY KEY (`TransactionID`),
  KEY `ClientID` (`ClientID`),
  CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`ClientID`) REFERENCES `clients` (`ClientID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transactions`
--

LOCK TABLES `transactions` WRITE;
/*!40000 ALTER TABLE `transactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `workers`
--

DROP TABLE IF EXISTS `workers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `workers` (
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workers`
--

LOCK TABLES `workers` WRITE;
/*!40000 ALTER TABLE `workers` DISABLE KEYS */;
INSERT INTO `workers` VALUES (1,'jurek345','1234','jurek','adam','98041106345','123456789',20,'2018-01-07','2019-01-07');
/*!40000 ALTER TABLE `workers` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-01-12 20:43:23
