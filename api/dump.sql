
SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
--  Table structure for `groups`
-- ----------------------------
DROP TABLE IF EXISTS `groups`;
CREATE TABLE `groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `groups`
-- ----------------------------
BEGIN;
INSERT INTO `groups` VALUES ('1', 'Admin'), ('2', 'User Manager'), ('3', 'Records Manager'), ('4', 'Users');
COMMIT;

-- ----------------------------
--  Table structure for `permissions`
-- ----------------------------
DROP TABLE IF EXISTS `permissions`;
CREATE TABLE `permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `model` varchar(255) NOT NULL,
  `create` char(1) NOT NULL DEFAULT '0',
  `read` char(1) NOT NULL DEFAULT '0',
  `update` char(1) NOT NULL DEFAULT '0',
  `delete` char(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `permissions`
-- ----------------------------
BEGIN;
INSERT INTO `permissions` VALUES ('1', '1', '*', '2', '2', '2', '2'), ('2', '2', 'users', '2', '2', '2', '2'), ('3', '2', 'groups', '0', '2', '0', '0'), ('4', '2', 'permissions', '0', '2', '0', '0'), ('5', '3', 'users', '0', '2', '1', '0'), ('6', '3', 'groups', '0', '1', '0', '0'), ('7', '3', 'permissions', '0', '1', '0', '0'), ('8', '3', 'records', '2', '2', '2', '2'), ('9', '4', 'users', '0', '1', '1', '0'), ('10', '4', 'groups', '0', '1', '0', '0'), ('11', '4', 'permissions', '0', '1', '0', '0'), ('12', '4', 'records', '1', '1', '1', '1');
COMMIT;

-- ----------------------------
--  Table structure for `records`
-- ----------------------------
DROP TABLE IF EXISTS `records`;
CREATE TABLE `records` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `text` text NOT NULL,
  `datetime` datetime NOT NULL,
  `calories` float NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `records`
-- ----------------------------
BEGIN;
INSERT INTO `records` VALUES ('1', '3', 'Evening Dinner', '2016-03-01 17:00:00', '20.5'), ('2', '3', 'Lunch', '2016-03-01 12:00:00', '30.1'), ('3', '3', 'Breakfast', '2016-03-01 09:30:00', '60.3'), ('4', '3', 'Breakfast with Tiffany', '2016-03-02 09:45:00', '50'), ('5', '3', 'Second lunch with tomatoes', '2016-03-04 09:00:00', '60.7'), ('6', '3', 'No dinner', '2016-03-06 19:00:00', '0'), ('7', '3', 'Second Lunch', '2016-03-01 13:00:00', '14'), ('8', '3', 'Tasty Burger', '2016-03-08 19:15:00', '205'), ('9', '4', 'Milch', '2016-03-10 21:00:00', '10'), ('10', '4', 'There is a text', '2016-03-10 08:45:00', '110'), ('11', '4', 'Eat', '2016-03-10 09:15:00', '20'), ('12', '4', 'Dinner', '2016-03-01 09:15:00', '120'), ('13', '3', 'Yogurt', '2016-03-09 22:45:00', '15'), ('14', '3', 'Night Bite', '2016-03-08 03:15:00', '26'), ('15', '4', 'Test', '2016-03-11 19:00:00', '230');
COMMIT;

-- ----------------------------
--  Table structure for `users`
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `calories_per_day` float NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `users`
-- ----------------------------
BEGIN;
INSERT INTO `users` VALUES ('1', '1', 'Michael', 'u1@test.test', '5f4dcc3b5aa765d61d8327deb882cf99', '120'), ('2', '2', 'Mann User Manager', 'u2@test.test', '5f4dcc3b5aa765d61d8327deb882cf99', '150'), ('3', '3', 'GÃ¼nter', 'u3@test.test', '5f4dcc3b5aa765d61d8327deb882cf99', '140'), ('4', '4', 'Hunz GrÃ¼ber', 'u4@test.test', '5f4dcc3b5aa765d61d8327deb882cf99', '100');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
