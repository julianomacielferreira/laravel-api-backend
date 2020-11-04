-- DATABASE SCHEMA FOR LARAVEL-API

-- DROP AND RECREATE DATABASE
DROP DATABASE IF EXISTS laravel_api;
CREATE DATABASE laravel_api;
USE laravel_api;

--
-- Table structure for table `article`
--
CREATE TABLE IF NOT EXISTS `article` (
  `idArticle` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(200) NOT NULL,
  `description` TEXT NOT NULL,
  `status` TINYINT NOT NULL DEFAULT 1,
  `created_at` DATETIME NOT NULL,
  `updated_at` DATETIME NULL,
  PRIMARY KEY (`idArticle`)
);
