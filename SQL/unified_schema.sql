/**
 * make sure to bump schema version and mark changes in database_changelog.md!
 *
 * unified schema for citadel, **sync changes to both servers.**
 **/

--
-- Table structure for table `schema_revision`
--
CREATE TABLE IF NOT EXISTS `schema_revision` (
  `major` TINYINT(3) unsigned NOT NULL,
  `minor` TINYINT(3) unsigned NOT NULL,
  `date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`major`, `minor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--- currently empty
