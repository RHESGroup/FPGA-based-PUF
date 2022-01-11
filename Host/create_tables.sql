/*
SQLyog Community v13.1.8 (64 bit)
MySQL - 10.3.28-MariaDB : Database - PUF_CRPs
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`PUF_CRPs` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `PUF_CRPs`;

/*Table structure for table `PUF_results` */

DROP TABLE IF EXISTS `PUF_results`;

CREATE TABLE `PUF_results` (
  `runID` int(11) NOT NULL,
  `bistable` tinyint(11) unsigned NOT NULL,
  `n_occurrences` blob DEFAULT NULL,
  PRIMARY KEY (`runID`,`bistable`),
  CONSTRAINT `PUF_results_ibfk_1` FOREIGN KEY (`runID`) REFERENCES `PUF_runs` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `PUF_results` */

/*Table structure for table `PUF_runs` */

DROP TABLE IF EXISTS `PUF_runs`;

CREATE TABLE `PUF_runs` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `secube` varchar(24) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `challenge` binary(8) DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `valid_responses` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `PUF_runs` */

/*Table structure for table `PUF_runs_view` */

DROP TABLE IF EXISTS `PUF_runs_view`;

/*!50001 DROP VIEW IF EXISTS `PUF_runs_view` */;
/*!50001 DROP TABLE IF EXISTS `PUF_runs_view` */;

/*!50001 CREATE TABLE  `PUF_runs_view`(
 `ID` int(11) ,
 `secube` varchar(24) ,
 `HEX(challenge)` varchar(16) ,
 `timestamp` timestamp ,
 `valid_responses` int(11) 
)*/;

/*View structure for view PUF_runs_view */

/*!50001 DROP TABLE IF EXISTS `PUF_runs_view` */;
/*!50001 DROP VIEW IF EXISTS `PUF_runs_view` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`user`@`localhost` SQL SECURITY DEFINER VIEW `PUF_runs_view` AS (select `PUF_runs`.`ID` AS `ID`,`PUF_runs`.`secube` AS `secube`,hex(`PUF_runs`.`challenge`) AS `HEX(challenge)`,`PUF_runs`.`timestamp` AS `timestamp`,`PUF_runs`.`valid_responses` AS `valid_responses` from `PUF_runs`) */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
