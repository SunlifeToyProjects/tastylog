-- MySQL Script generated by MySQL Workbench
-- Fri Jul 30 10:07:59 2021
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema tastylog
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `tastylog` ;

-- -----------------------------------------------------
-- Schema tastylog
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `tastylog` DEFAULT CHARACTER SET utf8 ;
USE `tastylog` ;

-- -----------------------------------------------------
-- Table `tastylog`.`m_address`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tastylog`.`m_address` ;

CREATE TABLE IF NOT EXISTS `tastylog`.`m_address` (
  `jis_code` INT NULL DEFAULT NULL,
  `post_code` VARCHAR(7) NOT NULL,
  `prefecture_kana` VARCHAR(90) NULL DEFAULT NULL,
  `city_kana` VARCHAR(90) NULL DEFAULT NULL,
  `town_kana` VARCHAR(120) NULL DEFAULT NULL,
  `prefecture_name` VARCHAR(90) NULL DEFAULT NULL,
  `city_name` VARCHAR(90) NULL DEFAULT NULL,
  `town_name` VARCHAR(120) NULL DEFAULT NULL,
  INDEX `idx_address_post_code` (`post_code` ASC) INVISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tastylog`.`t_shop`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tastylog`.`t_shop` ;

CREATE TABLE IF NOT EXISTS `tastylog`.`t_shop` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(120) NOT NULL,
  `kana` VARCHAR(120) NULL DEFAULT NULL,
  `post_code` VARCHAR(7) NOT NULL,
  `address` VARCHAR(200) NULL DEFAULT NULL,
  `tel` VARCHAR(45) NULL DEFAULT NULL,
  `holiday` VARCHAR(45) NULL DEFAULT NULL,
  `seats` INT NULL DEFAULT NULL,
  `price_range` VARCHAR(20) NULL DEFAULT NULL,
  `score` FLOAT NULL DEFAULT NULL,
  `status` INT NOT NULL,
  `geolocation_latitude` FLOAT NULL DEFAULT NULL,
  `geolocation_longitude` FLOAT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `idx_shop_id` (`id` ASC) VISIBLE,
  INDEX `idx_post_code` (`post_code` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tastylog`.`t_user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tastylog`.`t_user` ;

CREATE TABLE IF NOT EXISTS `tastylog`.`t_user` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL DEFAULT NULL,
  `email` VARCHAR(45) NOT NULL,
  `password` VARCHAR(60) NOT NULL,
  `description` VARCHAR(1000) NULL DEFAULT NULL,
  `created` DATETIME NULL DEFAULT now(),
  `updated` DATETIME NULL DEFAULT now(),
  `locked` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `idx_user_id` (`id` ASC) VISIBLE,
  UNIQUE INDEX `idx_user_email` (`email` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tastylog`.`t_review`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tastylog`.`t_review` ;

CREATE TABLE IF NOT EXISTS `tastylog`.`t_review` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `shop_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `score` INT NULL DEFAULT NULL,
  `visit` DATETIME NULL DEFAULT NULL,
  `post` DATETIME NULL DEFAULT NULL,
  `description` LONGTEXT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_review_user_id` (`user_id` ASC) VISIBLE,
  INDEX `idx_review_shop_id` (`shop_id` ASC) VISIBLE,
  UNIQUE INDEX `idx_review_id` (`id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tastylog`.`m_category`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tastylog`.`m_category` ;

CREATE TABLE IF NOT EXISTS `tastylog`.`m_category` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `parent_id` INT NULL DEFAULT NULL,
  `name` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `idx_category_id` (`id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tastylog`.`t_shop_category`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tastylog`.`t_shop_category` ;

CREATE TABLE IF NOT EXISTS `tastylog`.`t_shop_category` (
  `shop_id` INT NOT NULL,
  `category_id` INT NOT NULL,
  INDEX `idx_shop_category_shop_id` (`shop_id` ASC) VISIBLE,
  INDEX `idx_shop_category_category_id` (`category_id` ASC) INVISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tastylog`.`sessions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tastylog`.`sessions` ;

CREATE TABLE IF NOT EXISTS `tastylog`.`sessions` (
  `session_id` VARCHAR(128) NOT NULL,
  `expires` INT NOT NULL,
  `data` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`session_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tastylog`.`t_login_history`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tastylog`.`t_login_history` ;

CREATE TABLE IF NOT EXISTS `tastylog`.`t_login_history` (
  `user_id` INT NOT NULL,
  `login` DATETIME NOT NULL,
  `host_name` VARCHAR(256) NULL DEFAULT NULL,
  `user_agent` VARCHAR(512) NULL DEFAULT NULL,
  `status` INT NOT NULL,
  INDEX `idx_login_history_user_id` (`user_id` ASC, `login` ASC) VISIBLE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;