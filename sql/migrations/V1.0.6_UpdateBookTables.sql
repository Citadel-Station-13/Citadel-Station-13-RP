
ALTER TABLE `library`
  CHANGE COLUMN `author` `author` VARCHAR(45) NOT NULL,
  CHANGE COLUMN `title` `title` VARCHAR(45) NOT NULL,
  CHANGE COLUMN `category` `category` ENUM('Any', 'Fiction', 'Non-Fiction', 'Adult', 'Reference', 'Religion') NOT NULL,
  ADD COLUMN `ckey` `ckey` VARCHAR(32) NOT NULL DEFAULT 'LEGACY' AFTER `category`,
  ADD COLUMN `datetime` `datetime` DATETIME NOT NULL AFTER `ckey`,
  ADD COLUMN `deleted` `deleted` tinyint(1) unsigned DEFAULT NULL AFTER `datetime`,
  ADD COLUMN `round_id_created` int(11) unsigned NULL AFTER `deleted`;

ALTER TABLE `library`
  ADD INDEX `deleted_idx` (`deleted` ASC),
  ADD INDEX `idx_lib_id_del` (`id` ASC, `deleted` ASC),
  ADD INDEX `idx_lib_del_title` (`deleted` ASC, `title` ASC),
  ADD INDEX `idx_lib_search` (`deleted` ASC, `author` ASC, `title` ASC, `category` ASC);
