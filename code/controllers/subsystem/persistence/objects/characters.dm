#warn impl

/**
 * --- /datum/character - Character Table ---
CREATE TABLE IF NOT EXISTS `%_PREFIX_%character` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `created` DATETIME NOT NULL DEFAULT Now(),
  `last_played` DATETIME NULL,
  `last_persisted` DATETIME NULL,
  `playerid` INT(11) NOT NULL,
  `canonical_name` INT(11) NOT NULL,
  `persist_data` MEDIUMTEXT NULL,
  PRIMARY KEY(`id`),
  CONSTRAINT `character_has_player` FOREIGN KEY (`playerid`)
  REFERENCES `%_PREFIX_%player` (`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  UNIQUE (`playerid`, `canonical_name`)
) ENIGNE=InnoDB DEFAULT CHARSET=utf8m4 COLLATE=utf8mb4_general_ci;

 */
