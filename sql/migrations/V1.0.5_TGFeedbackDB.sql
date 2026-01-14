
-- legacy_population
RENAME TABLE `population` TO `legacy_population`;
START TRANSACTION;
ALTER TABLE `legacy_population`
  ADD COLUMN `server_ip` INT(10) UNSIGNED NOT NULL AFTER `time`,
  ADD COLUMN `server_port` SMALLINT(5) UNSIGNED NOT NULL AFTER `server_ip`,
  ADD COLUMN `round_id` INT(11) UNSIGNED NULL AFTER `server_port`;
COMMIT;

-- for migration
RENAME TABLE `feedback` TO `feedback_old`;
--
-- Table structure for table `feedback`
--
CREATE TABLE IF NOT EXISTS `feedback` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `datetime` datetime NOT NULL,
  `round_id` int(11) unsigned NULL,
  `key_name` varchar(32) NOT NULL,
  `key_type` enum('text', 'amount', 'tally', 'nested tally', 'associative') NOT NULL,
  `version` tinyint(3) unsigned NOT NULL,
  `json` json NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Table structure for table `manifest`
--
CREATE TABLE IF NOT EXISTS `manifest` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `server_ip` int(10) unsigned NOT NULL,
  `server_port` smallint(5) NOT NULL,
  `round_id` int(11) NOT NULL,
  `ckey` varchar(32) NOT NULL,
  `character_name` text NOT NULL,
  `job` text NOT NULL,
  `special` text DEFAULT NULL,
  `latejoin` tinyint(1) NOT NULL DEFAULT 0,
  `timestamp` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Migrate old death table
START TRANSACTION;
SET SQL_SAFE_UPDATES = 0;
-- normalize
UPDATE `death`
  SET `bruteloss` = LEAST(`bruteloss`, 65535),
    `brainloss` = LEAST(`brainloss`, 65535),
    `fireloss` = LEAST(`fireloss`, 65535),
    `oxyloss` = LEAST(`oxyloss`, 65535);
-- change & add new
ALTER TABLE `death`
  CHANGE COLUMN `pod` `pod` VARCHAR(50) NOT NULL,
  ADD COLUMN `x_coord` SMALLINT(5) UNSIGNED NOT NULL AFTER `coord`,
  ADD COLUMN `y_coord` SMALLINT(5) UNSIGNED NOT NULL AFTER `x_coord`,
  ADD COLUMN `z_coord` SMALLINT(5) UNSIGNED NOT NULL AFTER `y_coord`,
  ADD COLUMN `mapname` varchar(32) NOT NULL AFTER `z_coord`,
  ADD COLUMN `server_ip` INT(10) UNSIGNED NOT NULL AFTER `mapname`,
  ADD COLUMN `server_port` SMALLINT(5) UNSIGNED NOT NULL AFTER `server_ip`,
  ADD COLUMN `round_id` int(11) UNSIGNED NULL AFTER `server_port`,
  CHANGE COLUMN `job` `job` VARCHAR(32) NOT NULL,
  CHANGE COLUMN `special` `special` VARCHAR(32) NULL DEFAULT NULL,
  CHANGE COLUMN `name` `name` VARCHAR(96) NOT NULL,
  CHANGE COLUMN `byondkey` `byondkey` VARCHAR(32) NOT NULL,
  CHANGE COLUMN `laname` `laname` VARCHAR(96) NULL DEFAULT NULL,
  CHANGE COLUMN `lakey` `lakey` VARCHAR(32) NULL DEFAULT NULL,
  CHANGE COLUMN `bruteloss` `bruteloss` SMALLINT(5) UNSIGNED NOT NULL,
  CHANGE COLUMN `brainloss` `brainloss` SMALLINT(5) UNSIGNED NOT NULL,
  CHANGE COLUMN `fireloss` `fireloss` SMALLINT(5) UNSIGNED NOT NULL,
  CHANGE COLUMN `oxyloss` `oxyloss` SMALLINT(5) UNSIGNED NOT NULL,
  ADD COLUMN `toxloss` smallint(5) unsigned NOT NULL AFTER `oxyloss`,
  ADD COLUMN `suicide` tinyint(1) NOT NULL DEFAULT '0' AFTER `toxloss`;

-- explode coord value & other value sets
UPDATE `death`
  SET
    `x_coord` = SUBSTRING_INDEX(`coord`, ',', 1),
    `y_coord` = SUBSTRING_INDEX(SUBSTRING_INDEX(`coord`, ',', 2), ',', -1),
    `z_coord` = SUBSTRING_INDEX(`coord`, ',', -1),
    `server_ip` = INET_ATON('0'),
    `server_port` = '0';
SET SQL_SAFE_UPDATES = 1;
ALTER TABLE `death`
  DROP COLUMN `coord`,
  DROP COLUMN `gender`;
COMMIT;

-- run this once you run the python script.
-- DROP TABLE `feedback_old`;
