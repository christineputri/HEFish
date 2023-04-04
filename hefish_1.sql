-- Valentina Studio --
-- MySQL dump --
-- ---------------------------------------------------------


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
-- ---------------------------------------------------------


-- DROP DATABASE "hefish_1" --------------------------------
DROP DATABASE IF EXISTS `hefish_1`;
-- ---------------------------------------------------------


-- CREATE DATABASE "hefish_1" ------------------------------
CREATE DATABASE `hefish_1` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `hefish_1`;
-- ---------------------------------------------------------


-- CREATE TABLE "fish_types" -----------------------------------
CREATE TABLE `fish_types`( 
	`id` Int( 0 ) NOT NULL,
	`name` VarChar( 50 ) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
	PRIMARY KEY ( `id` ) )
CHARACTER SET = utf8mb4
COLLATE = utf8mb4_general_ci
ENGINE = InnoDB;
-- -------------------------------------------------------------


-- CREATE TABLE "fishes" ---------------------------------------
CREATE TABLE `fishes`( 
	`id` Int( 0 ) NOT NULL,
	`user_id` Int( 0 ) NOT NULL,
	`fish_type_id` Int( 0 ) NOT NULL,
	`name` VarChar( 50 ) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
	`description` VarChar( 255 ) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
	`price` Int( 0 ) NOT NULL,
	`image_path` VarChar( 100 ) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
	PRIMARY KEY ( `id` ) )
CHARACTER SET = utf8mb4
COLLATE = utf8mb4_general_ci
ENGINE = InnoDB;
-- -------------------------------------------------------------


-- CREATE TABLE "users" ----------------------------------------
CREATE TABLE `users`( 
	`id` Int( 0 ) NOT NULL,
	`email` VarChar( 50 ) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
	`username` VarChar( 50 ) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
	`password` VarChar( 20 ) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
	`token` Char( 10 ) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
	PRIMARY KEY ( `id` ) )
CHARACTER SET = utf8mb4
COLLATE = utf8mb4_general_ci
ENGINE = InnoDB;
-- -------------------------------------------------------------


-- Dump data of "fish_types" -------------------------------
BEGIN;

INSERT INTO `fish_types`(`id`,`name`) VALUES 
( '1', 'FRESH WATER' ),
( '2', 'SALT WATER' ),
( '3', 'MIX WATER' );
COMMIT;
-- ---------------------------------------------------------


-- Dump data of "fishes" -----------------------------------
BEGIN;

INSERT INTO `fishes`(`id`,`user_id`,`fish_type_id`,`name`,`description`,`price`,`image_path`) VALUES 
( '1', '2', '1', 'Gurame', 'Citarasa daging manis dan lembut,.', '37500', 'gurame.png' ),
( '4', '2', '2', 'Kembung', 'Digoreng dan ditambah sambal auto nambah nasi', '45000', 'kembung.png' ),
( '5', '2', '3', 'Bandeng', 'Digoreng dan ditambah sambal auto nambah nasi', '65000', 'bandeng.png' ),
( '6', '2', '1', 'Nila', 'Berdaging manis dan lezat dipadukan dengan sambal', '38000', 'nila.png' ),
( '7', '2', '2', 'Tongkol', 'Bertekstur daging kenyal dan lezat dengan sambal.', '45000', 'tongkol.png' ),
( '8', '2', '1', 'Patin', 'Pindang ikan patin sangat menggugah selera', '36000', 'patin.png' ),
( '9', '2', '2', 'Baronang', 'Tesst edit', '74000', 'baronang.jpg' ),
( '10', '2', '2', 'Kerapu Macan', 'Bergizi dan dagingnya sangat lembut', '200000', 'kerapu_macan.jpeg' ),
( '13', '2', '2', 'Kakap Merah', 'Berwarna merah dan cocok dibakar dgn sambal', '75000', 'kakap_merah.png' );
COMMIT;
-- ---------------------------------------------------------


-- Dump data of "users" ------------------------------------
BEGIN;

INSERT INTO `users`(`id`,`email`,`username`,`password`,`token`) VALUES 
('1', 'calvin.anacia@gmail.com', 'clvn', 'Anacia12', 'CthoBmUIqz'),
('2', 'brahmantyo@gmail.com', 'bruh', 'Mantyo12', 'CthoBIk9Pq'),
('3', 'mh0101@gmail.com', 'michael', 'Haryantooo12', 'IF6MH4sdzC'),
('4', 'jwoen@gmail.com', 'jowoen', 'Woenwoen27', 'HqzRoVPUzd'),
('5', 'reynardot@gmail.com', 'reynard', 'Otannato12', 'ZWVLBx7rEj'),
('6', 'christineptri@gmail.com', 'ptri', 'CptCptCpt12', 'MFaFWj7h8q'),
('7', 'febricojonata@gmail.com', 'febrico', 'Jonatanata12', 'clch3gd0Nn'),
('8', 'nctristan@hefish.com', 'tristan', 'Ntberkali12', 'uacCDI2Ajz');



COMMIT;
-- ---------------------------------------------------------


-- CREATE INDEX "lnk_fish_types_fishes" ------------------------
CREATE INDEX `lnk_fish_types_fishes` USING BTREE ON `fishes`( `fish_type_id` );
-- -------------------------------------------------------------


-- CREATE INDEX "lnk_users_fishes" -----------------------------
CREATE INDEX `lnk_users_fishes` USING BTREE ON `fishes`( `user_id` );
-- -------------------------------------------------------------


-- CREATE LINK "lnk_fish_types_fishes" -------------------------
ALTER TABLE `fishes`
	ADD CONSTRAINT `lnk_fish_types_fishes` FOREIGN KEY ( `fish_type_id` )
	REFERENCES `fish_types`( `id` )
	ON DELETE Cascade
	ON UPDATE Cascade;
-- -------------------------------------------------------------


-- CREATE LINK "lnk_users_fishes" ------------------------------
ALTER TABLE `fishes`
	ADD CONSTRAINT `lnk_users_fishes` FOREIGN KEY ( `user_id` )
	REFERENCES `users`( `id` )
	ON DELETE Cascade
	ON UPDATE Cascade;
-- -------------------------------------------------------------


/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
-- ---------------------------------------------------------


