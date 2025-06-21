-- MySQL dump 10.13  Distrib 8.0.33, for Linux (x86_64)
--
-- Host: localhost    Database: DogWalkService
-- ------------------------------------------------------
-- Server version	8.0.33-0ubuntu0.22.04.2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `DogWalkService`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `DogWalkService` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `DogWalkService`;

--
-- Table structure for table `Dogs`
--

DROP TABLE IF EXISTS `Dogs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Dogs` (
  `dog_id` int NOT NULL AUTO_INCREMENT,
  `owner_id` int NOT NULL,
  `name` varchar(50) NOT NULL,
  `size` enum('small','medium','large') NOT NULL,
  PRIMARY KEY (`dog_id`),
  KEY `owner_id` (`owner_id`),
  CONSTRAINT `Dogs_ibfk_1` FOREIGN KEY (`owner_id`) REFERENCES `Users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Dogs`
--

LOCK TABLES `Dogs` WRITE;
/*!40000 ALTER TABLE `Dogs` DISABLE KEYS */;
INSERT INTO `Dogs` VALUES (1,1,'Max','medium'),(2,3,'Bella','small'),(5,4,'Maple','medium'),(11,1,'Spots','large'),(12,11,'Cerberus','large'),(13,1,'Blue','small');
/*!40000 ALTER TABLE `Dogs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Users`
--

DROP TABLE IF EXISTS `Users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('owner','walker') NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Users`
--

LOCK TABLES `Users` WRITE;
/*!40000 ALTER TABLE `Users` DISABLE KEYS */;
INSERT INTO `Users` VALUES (1,'alice123','alice@example.com','hashed123','owner','2025-06-20 01:49:58'),(2,'bobwalker','bob@example.com','hashed456','walker','2025-06-20 01:49:58'),(3,'carol123','carol@example.com','hashed789','owner','2025-06-20 01:49:58'),(4,'eliza','eliza@example.com','hashed699','owner','2025-06-20 02:36:18'),(5,'gregoryHouseMD','drHouse@example.com','itslupus','walker','2025-06-20 02:36:18'),(11,'orange','youglad@example.com','hashed000','owner','2025-06-21 01:22:04'),(12,'clementines','clemmy@example.com','hashed003','walker','2025-06-21 01:22:04');
/*!40000 ALTER TABLE `Users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `WalkApplications`
--

DROP TABLE IF EXISTS `WalkApplications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `WalkApplications` (
  `application_id` int NOT NULL AUTO_INCREMENT,
  `request_id` int NOT NULL,
  `walker_id` int NOT NULL,
  `applied_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('pending','accepted','rejected') DEFAULT 'pending',
  PRIMARY KEY (`application_id`),
  UNIQUE KEY `unique_application` (`request_id`,`walker_id`),
  KEY `walker_id` (`walker_id`),
  CONSTRAINT `WalkApplications_ibfk_1` FOREIGN KEY (`request_id`) REFERENCES `WalkRequests` (`request_id`),
  CONSTRAINT `WalkApplications_ibfk_2` FOREIGN KEY (`walker_id`) REFERENCES `Users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `WalkApplications`
--

LOCK TABLES `WalkApplications` WRITE;
/*!40000 ALTER TABLE `WalkApplications` DISABLE KEYS */;
INSERT INTO `WalkApplications` VALUES (1,3,3,'2025-06-20 07:12:45','pending'),(2,4,2,'2025-06-20 08:29:18','pending'),(3,5,2,'2025-06-20 14:58:15','pending');
/*!40000 ALTER TABLE `WalkApplications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `WalkRatings`
--

DROP TABLE IF EXISTS `WalkRatings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `WalkRatings` (
  `rating_id` int NOT NULL AUTO_INCREMENT,
  `request_id` int NOT NULL,
  `walker_id` int NOT NULL,
  `owner_id` int NOT NULL,
  `rating` int DEFAULT NULL,
  `comments` text,
  `rated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`rating_id`),
  UNIQUE KEY `unique_rating_per_walk` (`request_id`),
  KEY `walker_id` (`walker_id`),
  KEY `owner_id` (`owner_id`),
  CONSTRAINT `WalkRatings_ibfk_1` FOREIGN KEY (`request_id`) REFERENCES `WalkRequests` (`request_id`),
  CONSTRAINT `WalkRatings_ibfk_2` FOREIGN KEY (`walker_id`) REFERENCES `Users` (`user_id`),
  CONSTRAINT `WalkRatings_ibfk_3` FOREIGN KEY (`owner_id`) REFERENCES `Users` (`user_id`),
  CONSTRAINT `WalkRatings_chk_1` CHECK ((`rating` between 1 and 5))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `WalkRatings`
--

LOCK TABLES `WalkRatings` WRITE;
/*!40000 ALTER TABLE `WalkRatings` DISABLE KEYS */;
INSERT INTO `WalkRatings` VALUES (1,1,2,4,5,NULL,'2025-06-20 03:19:50');
/*!40000 ALTER TABLE `WalkRatings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `WalkRequests`
--

DROP TABLE IF EXISTS `WalkRequests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `WalkRequests` (
  `request_id` int NOT NULL AUTO_INCREMENT,
  `dog_id` int NOT NULL,
  `requested_time` datetime NOT NULL,
  `duration_minutes` int NOT NULL,
  `location` varchar(255) NOT NULL,
  `status` enum('open','accepted','completed','cancelled') DEFAULT 'open',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`request_id`),
  KEY `dog_id` (`dog_id`),
  CONSTRAINT `WalkRequests_ibfk_1` FOREIGN KEY (`dog_id`) REFERENCES `Dogs` (`dog_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `WalkRequests`
--

LOCK TABLES `WalkRequests` WRITE;
/*!40000 ALTER TABLE `WalkRequests` DISABLE KEYS */;
INSERT INTO `WalkRequests` VALUES (1,1,'2025-06-10 08:00:00',30,'Parklands','open','2025-06-20 01:58:26'),(2,2,'2025-06-10 09:30:00',45,'Beachside Ave','accepted','2025-06-20 01:58:26'),(3,5,'2025-06-20 12:25:00',30,'North Terrace','accepted','2025-06-20 02:36:38'),(4,1,'2025-06-20 17:37:00',34,'Wherever, Whenever','accepted','2025-06-20 08:08:00'),(5,1,'2025-06-20 23:33:00',100,'Unley','accepted','2025-06-20 14:03:39'),(6,1,'2025-06-08 23:33:00',5,'Elizabeth','open','2025-06-20 14:03:56'),(7,1,'2025-06-22 11:30:00',40,'Rundle St','open','2025-06-21 01:23:52'),(8,1,'2025-06-21 09:00:00',30,'Elizabeth','open','2025-06-21 01:23:52');
/*!40000 ALTER TABLE `WalkRequests` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-06-21  1:43:40
