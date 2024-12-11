CREATE TABLE IF NOT EXISTS `backend_repository` (
  `repository` VARCHAR(64) NOT NULL,
  `id` VARCHAR(128) NOT NULL,
  `version` INT(11) NOT NULL,
  `data` MEDIUMTEXT NOT NULL,
  `createdTime` DATETIME NOT NULL DEFAULT Now(),
  `modifiedTime` DATETIME NOT NULL DEFAULT Now(),
  PRIMARY KEY(`repository`, `id`),
  INDEX(`repository`),
  INDEX(`id`)
)
