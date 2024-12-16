DROP TRIGGER IF EXISTS `playtimeTlogupdate`;
DROP TRIGGER IF EXISTS `playtimeTloginsert`;
DROP TRIGGER IF EXISTS `playtimeTlogdelete`;

DELIMITER $$
CREATE TRIGGER `playtimeTlogupdate` AFTER UPDATE ON `playtime` FOR EACH ROW BEGIN INSERT into `playtime_log` (player, roleid, delta) VALUES (NEW.player, NEW.roleid, NEW.minutes-OLD.minutes);
END
$$
CREATE TRIGGER `playtimeTloginsert` AFTER INSERT ON `playtime` FOR EACH ROW BEGIN INSERT into `playtime_log` (player, roleid, delta) VALUES (NEW.player, NEW.roleid, NEW.minutes);
END
$$
CREATE TRIGGER `playtimeTlogdelete` AFTER DELETE ON `playtime` FOR EACH ROW BEGIN INSERT into `playtime_log` (player, roleid, delta) VALUES (OLD.player, OLD.roleid, 0-OLD.minutes);
END
$$
DELIMITER ;
