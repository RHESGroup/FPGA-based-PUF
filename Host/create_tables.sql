/*
SQLyog Community v13.1.8 (64 bit)
MySQL - 8.0.27-0ubuntu0.20.04.1 : Database - PUF_CRPs
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`PUF_CRPs` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `PUF_CRPs`;

/*Table structure for table `PUF_results` */

DROP TABLE IF EXISTS `PUF_results`;

CREATE TABLE `PUF_results` (
  `runID` int NOT NULL,
  `response` int NOT NULL,
  `n_occurrences` int DEFAULT NULL,
  PRIMARY KEY (`runID`,`response`),
  CONSTRAINT `PUF_results_ibfk_1` FOREIGN KEY (`runID`) REFERENCES `PUF_runs` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `PUF_results` */

/*Table structure for table `PUF_runs` */

DROP TABLE IF EXISTS `PUF_runs`;

CREATE TABLE `PUF_runs` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `secube` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `challenge` binary(8) DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `valid_responses` int DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `PUF_runs` */

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
