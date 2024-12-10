DROP TRIGGER `playtimeTlogupdate`;
DROP TRIGGER `playtimeTloginsert`;
DROP TRIGGER `playtimeTlogdelete`;

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
