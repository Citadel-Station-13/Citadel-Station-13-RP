CREATE TABLE IF NOT EXISTS `%_PREFIX_%persist_keyed_strings` (
  `created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `key` varchar(64) NOT NULL,
  `value` MEDIUMTEXT NULL,
  `group` varchar(64) NULL,
  `revision` INT(11) NOT NULL,
  PRIMARY KEY(`key`, `group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `%_PREFIX_%persist_mass_atoms` (
  `saved` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `handler_id` varchar(64) NOT NULL,
  `level_id` varchar(64) NOT NULL,
  `fragment` INT(3) NOT NULL,
  `data` MEDIUMTEXT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `%_PREFIX_%persist_dynamic_atoms` (
  `modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `x` INT(8) NOT NULL,
  `y` INT(8) NOT NULL,
  `level_id` varchar(64) NOT NULL,
  `type` varchar(64) NOT NULL,
  `json` MEDIUMTEXT NOT NULL,
  `revision` INT(11) NOT NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `%_PREFIX_%persist_keyed_atoms` (
  `created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `map` varchar(64) NULL,
  `key` varchar(64) NOT NULL,
  `json` MEDIUMTEXT NOT NULL,
  `revision` INT(11) NOT NULL,
  PRIMARY KEY(`key`, `map`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
