-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               11.4.0-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             12.3.0.6589
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for need_for_drag
CREATE DATABASE IF NOT EXISTS `need_for_drag` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;
USE `need_for_drag`;

-- Dumping structure for table need_for_drag.players
CREATE TABLE IF NOT EXISTS `players` (
  `identifier` int(11) NOT NULL AUTO_INCREMENT,
  `license` longtext NOT NULL,
  `name` varchar(50) NOT NULL,
  `money` longtext DEFAULT NULL,
  `group` varchar(50) DEFAULT 'user',
  `skin` longtext DEFAULT NULL,
  `metadata` longtext DEFAULT NULL,
  `vehicles` longtext DEFAULT NULL,
  `crew` longtext DEFAULT NULL,
  PRIMARY KEY (`identifier`),
  UNIQUE KEY `ux-identifier` (`identifier`),
  KEY `idx-name` (`name`),
  KEY `idx-money` (`money`(768)),
  KEY `idx-group` (`group`),
  KEY `idx-skin` (`skin`(768)),
  KEY `idx-metadata` (`metadata`(768)),
  KEY `idx-vehicles` (`vehicles`(768)),
  KEY `idx-crew` (`crew`(768)),
  KEY `idx-license` (`license`(768))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci CHECKSUM=1;

-- Dumping data for table need_for_drag.players: ~1 rows (approximately)
INSERT INTO `players` (`identifier`, `license`, `name`, `money`, `group`, `skin`, `metadata`, `vehicles`, `crew`) VALUES
	(1, 'license:e1005ce54f22453911bd2cd223f0772536281c45', 'Tepelekas', '7000', 'admin', NULL, '"Tepelekas"', NULL, NULL);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
