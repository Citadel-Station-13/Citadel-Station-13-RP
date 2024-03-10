/**
 * make sure to bump schema version and mark changes in database_changelog.md!
 *
 * default prefix is rp_
 * find replace case sensitive %_PREFIX_%
 * PRESERVE ANY vr_'s! We need to replace those tables and features at some point, that's how we konw.
 **/

-- core --

--
-- Table structure for table `schema_revision`
--
CREATE TABLE IF NOT EXISTS `%_PREFIX_%schema_revision` (
  `major` TINYINT(3) unsigned NOT NULL,
  `minor` TINYINT(3) unsigned NOT NULL,
  `date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`major`, `minor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- persistence --

-- SSpersistence modules/bulk_entity
CREATE TABLE IF NOT EXISTS `%_PREFIX_%persistence_bulk_entity` (
  `id` INT(24) NOT NULL AUTO_INCREMENT,
  `generation` INT(11) NOT NULL,
  `persistence_key` VARCHAR(64) NOT NULL,
  `level_id` VARCHAR(64) NOT NULL,
  `data` MEDIUMTEXT,
  `round_id` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX(`level_id`, `generation`, `persistence_key`),
  INDEX(`level_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- SSpersistence modules/level_objects
CREATE TABLE IF NOT EXISTS `%_PREFIX_%persistence_static_level_objects` (
  `generation` INT(11) NOT NULL,
  `object_id` VARCHAR(64) NOT NULL,
  `level_id` VARCHAR(64) NOT NULL,
  `data` MEDIUMTEXT NOT NULL,
  PRIMARY KEY(`generation`, `object_id`, `level_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- SSpersistence modules/level_objects
CREATE TABLE IF NOT EXISTS `%_PREFIX_%persistence_static_map_objects` (
  `generation` INT(11) NOT NULL,
  `object_id` VARCHAR(64) NOT NULL,
  `map_id` VARCHAR(64) NOT NULL,
  `data` MEDIUMTEXT NOT NULL,
  PRIMARY KEY(`generation`, `object_id`, `map_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- SSpersistence modules/level_objects
CREATE TABLE IF NOT EXISTS `%_PREFIX_%persistence_static_global_objects` (
  `generation` INT(11) NOT NULL,
  `object_id` VARCHAR(64) NOT NULL,
  `data` MEDIUMTEXT NOT NULL,
  PRIMARY KEY(`generation`, `object_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- SSpersistence modules/level_objects
CREATE TABLE IF NOT EXISTS `%_PREFIX_%persistence_dynamic_objects` (
  `generation` INT(11) NOT NULL,
  `object_id` INT(24) NOT NULL AUTO_INCREMENT,
  `level_id` VARCHAR(64) NOT NULL,
  `prototype_id` VARCHAR(256) NOT NULL,
  `status` INT(24) NOT NULL DEFAULT 0,
  `data` MEDIUMTEXT NOT NULL,
  `x` INT(8) NOT NULL,
  `y` INT(8) NoT NULL,
  PRIMARY KEY(`object_id`, `generation`),
  INDEX(`object_id`),
  INDEX(`level_id`, `generation`),
  INDEX(`prototype_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- SSpersistence modules/spatial_metadata
CREATE TABLE IF NOT EXISTS `%_PREFIX_%persistence_level_metadata` (
  `created` DATETIME NOT NULL DEFAULT Now(),
  `saved` DATETIME NOT NULL,
  `saved_round_id` INT(11) NOT NULL,
  `level_id` VARCHAR(64) NOT NULL,
  `data` MEDIUMTEXT NOT NULL,
  `generation` INT(11) NOT NULL,
  PRIMARY KEY(`level_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- SSpersistence modules/string_kv
CREATE TABLE IF NOT EXISTS `%_PREFIX_%persistence_string_kv` (
  `created` DATETIME NOT NULL DEFAULT Now(),
  `modified` DATETIME NOT NULL,
  `key` VARCHAR(64) NOT NULL,
  `value` MEDIUMTEXT NULL,
  `group` VARCHAR(64) NOT NULL,
  `revision` INT(11) NOT NULL,
  PRIMARY KEY(`key`, `group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- photography --

--           picture table            --
-- used to store data about pictures  --
-- hash is in sha1 format.            --
CREATE TABLE IF NOT EXISTS `%_PREFIX_%pictures` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hash` char(40) NOT NULL,
  `created` datetime NOT NULL DEFAULT Now(),
  `width` int NOT NULL,
  `height` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `hash` (`hash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--             photograph table              --
-- used to store data about photographs      --
-- picture is picture hash in picture table  --
CREATE TABLE IF NOT EXISTS `%_PREFIX_%photographs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `picture` char(40) NOT NULL,
  `created` datetime NOT NULL DEFAULT Now(),
  `scene` MEDIUMTEXT null,
  `desc` MEDIUMTEXT null,
  CONSTRAINT `linked_picture` FOREIGN KEY (`picture`)
  REFERENCES `%_PREFIX_%pictures` (`hash`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- players --

--           Player lookup table                   --
-- Used to look up player ID from ckey, as well as --
-- store last computerid/ip for a ckey.            --
CREATE TABLE IF NOT EXISTS `%_PREFIX_%player_lookup` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ckey` varchar(32) NOT NULL,
  `firstseen` datetime NOT NULL,
  `lastseen` datetime NOT NULL,
  `ip` varchar(18) NOT NULL,
  `computerid` varchar(32) NOT NULL,
  `lastadminrank` varchar(32) NOT NULL DEFAULT 'Player',
  `playerid` int(11),
  PRIMARY KEY (`id`),
  UNIQUE KEY `ckey` (`ckey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--              Primary player table               --
-- Allows for one-to-many player-ckey association. --
CREATE TABLE IF NOT EXISTS `%_PREFIX_%player` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `flags` int(24) NOT NULL DEFAULT 0,
  `firstseen` datetime NOT NULL DEFAULT Now(),
  `lastseen` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Playtime / JEXP --

--      Role Time Table - Master     --
-- Stores total role time.           --

CREATE TABLE IF NOT EXISTS `%_PREFIX_%playtime` (
  `player` INT(11) NOT NULL,
  `roleid` VARCHAR(64) NOT NULL,
  `minutes` INT UNSIGNED NOT NULL,
  PRIMARY KEY(`player`, `roleid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--      Role Time - Logging       --
-- Stores changes in role time    --
CREATE TABLE IF NOT EXISTS `%_PREFIX_%playtime_log` (
  `player` INT(11),
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `roleid` VARCHAR(64) NOT NULL,
  `delta` INT(11) NOT NULL,
  `datetime` TIMESTAMP NOT NULL DEFAULT NOW() ON UPDATE NOW(),
  PRIMARY KEY (`id`),
  KEY `player` (`player`),
  KEY `roleid` (`roleid`),
  KEY `datetime` (`datetime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DELIMITER $$
CREATE TRIGGER `playtimeTlogupdate` AFTER UPDATE ON `%_PREFIX_%playtime` FOR EACH ROW BEGIN INSERT into `%_PREFIX_%playtime_log` (player, roleid, delta) VALUES (NEW.player, NEW.roleid, NEW.minutes-OLD.minutes);
END
$$
CREATE TRIGGER `playtimeTloginsert` AFTER INSERT ON `%_PREFIX_%playtime` FOR EACH ROW BEGIN INSERT into `%_PREFIX_%playtime_log` (player, roleid, delta) VALUES (NEW.player, NEW.roleid, NEW.minutes);
END
$$
CREATE TRIGGER `playtimeTlogdelete` AFTER DELETE ON `%_PREFIX_%playtime` FOR EACH ROW BEGIN INSERT into `%_PREFIX_%playtime_log` (player, roleid, delta) VALUES (OLD.player, OLD.roleid, 0-OLD.minutes);
END
$$
DELIMITER ;

-- Security - Ipintel --

--        Ipintel Cache Table       --
-- Stores cache entries for IPIntel --
-- IP is in INET_ATON.              --
CREATE TABLE IF NOT EXISTS `%_PREFIX_%ipintel` (
  `ip` INT(10) unsigned NOT NULL,
  `date` TIMESTAMP NOT NULL DEFAULT NOW() ON UPDATE NOW(),
  `intel` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`ip`),
  KEY `idx_ipintel` (`ip`, `intel`, `date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Table structure for table `round`
--
CREATE TABLE IF NOT EXISTS `%_PREFIX_%round` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `initialize_datetime` DATETIME NOT NULL,
  `start_datetime` DATETIME NULL,
  `shutdown_datetime` DATETIME NULL,
  `end_datetime` DATETIME NULL,
  `server_ip` INT(10) UNSIGNED NOT NULL,
  `server_port` SMALLINT(5) UNSIGNED NOT NULL,
  `commit_hash` CHAR(40) NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--            Connection log           --
-- Logs all connections to the server. --
CREATE TABLE IF NOT EXISTS `%_PREFIX_%connection_log` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `datetime` datetime NOT NULL,
  `serverip` varchar(45) NOT NULL,
  `ckey` varchar(32) NOT NULL,
  `ip` varchar(45) NOT NULL,
  `computerid` varchar(32) NOT NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- /datum/character - Character Table --
CREATE TABLE IF NOT EXISTS `%_PREFIX_%character` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `created` DATETIME NOT NULL DEFAULT Now(),
  `last_played` DATETIME NULL,
  `last_persisted` DATETIME NULL,
  `playerid` INT(11) NOT NULL,
  `canonical_name` VARCHAR(128) NOT NULL,
  `persist_data` MEDIUMTEXT NULL,
  `character_type` VARCHAR(64) NOT NULL,
  PRIMARY KEY(`id`),
  CONSTRAINT `character_has_player` FOREIGN KEY (`playerid`)
  REFERENCES `%_PREFIX_%player` (`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  UNIQUE (`playerid`, `canonical_name`, `character_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `%_PREFIX_%admin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ckey` varchar(32) NOT NULL,
  `rank` varchar(32) NOT NULL DEFAULT 'Administrator',
  `level` int(2) NOT NULL DEFAULT '0',
  `flags` int(16) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `%_PREFIX_%admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `datetime` datetime NOT NULL,
  `adminckey` varchar(32) NOT NULL,
  `adminip` varchar(18) NOT NULL,
  `log` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `%_PREFIX_%ban` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bantime` datetime NOT NULL,
  `serverip` varchar(32) NOT NULL,
  `bantype` varchar(32) NOT NULL,
  `reason` text NOT NULL,
  `job` varchar(32) DEFAULT NULL,
  `duration` int(11) NOT NULL,
  `rounds` int(11) DEFAULT NULL,
  `expiration_time` datetime NOT NULL,
  `ckey` varchar(32) NOT NULL,
  `computerid` varchar(32) NOT NULL,
  `ip` varchar(32) NOT NULL,
  `a_ckey` varchar(32) NOT NULL,
  `a_computerid` varchar(32) NOT NULL,
  `a_ip` varchar(32) NOT NULL,
  `who` text NOT NULL,
  `adminwho` text NOT NULL,
  `edits` text,
  `unbanned` tinyint(1) DEFAULT NULL,
  `unbanned_datetime` datetime DEFAULT NULL,
  `unbanned_ckey` varchar(32) DEFAULT NULL,
  `unbanned_computerid` varchar(32) DEFAULT NULL,
  `unbanned_ip` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `%_PREFIX_%feedback` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `time` datetime NOT NULL,
  `round_id` int(8) NOT NULL,
  `var_name` varchar(32) NOT NULL,
  `var_value` int(16) DEFAULT NULL,
  `details` text,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 ;

CREATE TABLE IF NOT EXISTS `%_PREFIX_%poll_option` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pollid` int(11) NOT NULL,
  `text` varchar(255) NOT NULL,
  `percentagecalc` tinyint(1) NOT NULL DEFAULT '1',
  `minval` int(3) DEFAULT NULL,
  `maxval` int(3) DEFAULT NULL,
  `descmin` varchar(32) DEFAULT NULL,
  `descmid` varchar(32) DEFAULT NULL,
  `descmax` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `%_PREFIX_%poll_question` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `polltype` varchar(16) NOT NULL DEFAULT 'OPTION',
  `starttime` datetime NOT NULL,
  `endtime` datetime NOT NULL,
  `question` varchar(255) NOT NULL,
  `adminonly` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `%_PREFIX_%poll_textreply` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `datetime` datetime NOT NULL,
  `pollid` int(11) NOT NULL,
  `ckey` varchar(32) NOT NULL,
  `ip` varchar(18) NOT NULL,
  `replytext` text NOT NULL,
  `adminrank` varchar(32) NOT NULL DEFAULT 'Player',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `%_PREFIX_%poll_vote` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `datetime` datetime NOT NULL,
  `pollid` int(11) NOT NULL,
  `optionid` int(11) NOT NULL,
  `ckey` varchar(255) NOT NULL,
  `ip` varchar(16) NOT NULL,
  `adminrank` varchar(32) NOT NULL,
  `rating` int(2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `%_PREFIX_%privacy` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `datetime` datetime NOT NULL,
  `ckey` varchar(32) NOT NULL,
  `option` varchar(128) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `%_PREFIX_%vr_player_hours` (
  `ckey` varchar(32) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `department` varchar(64) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `hours` double NOT NULL,
  PRIMARY KEY (`ckey`,`department`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `%_PREFIX_%death` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `pod` TEXT NOT NULL COMMENT 'Place of death' ,
  `coord` TEXT NOT NULL COMMENT 'X, Y, Z POD' ,
  `tod` DATETIME NOT NULL COMMENT 'Time of death' ,
  `job` TEXT NOT NULL ,
  `special` TEXT NOT NULL ,
  `name` TEXT NOT NULL ,
  `byondkey` TEXT NOT NULL ,
  `laname` TEXT NOT NULL COMMENT 'Last attacker name' ,
  `lakey` TEXT NOT NULL COMMENT 'Last attacker key' ,
  `gender` TEXT NOT NULL ,
  `bruteloss` INT(11) NOT NULL ,
  `brainloss` INT(11) NOT NULL ,
  `fireloss` INT(11) NOT NULL ,
  `oxyloss` INT(11) NOT NULL ,
  PRIMARY KEY (`id`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `%_PREFIX_%karma` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `spendername` TEXT NOT NULL ,
  `spenderkey` TEXT NOT NULL ,
  `receivername` TEXT NOT NULL ,
  `receiverkey` TEXT NOT NULL ,
  `receiverrole` TEXT NOT NULL ,
  `receiverspecial` TEXT NOT NULL ,
  `isnegative` TINYINT(1) NOT NULL ,
  `spenderip` TEXT NOT NULL ,
  `time` DATETIME NOT NULL ,
  PRIMARY KEY (`id`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `%_PREFIX_%karmatotals` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `byondkey` TEXT NOT NULL ,
  `karma` INT(11) NOT NULL ,
  PRIMARY KEY (`id`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `%_PREFIX_%library` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `author` TEXT NOT NULL ,
  `title` TEXT NOT NULL ,
  `content` TEXT NOT NULL ,
  `category` TEXT NOT NULL ,
  PRIMARY KEY (`id`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `%_PREFIX_%population` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `playercount` INT(11) NULL DEFAULT NULL ,
  `admincount` INT(11) NULL DEFAULT NULL ,
  `time` DATETIME NOT NULL ,
  PRIMARY KEY (`id`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
