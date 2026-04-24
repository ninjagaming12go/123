CREATE TABLE IF NOT EXISTS `codem_multicharacter` (
  `#` int(11) NOT NULL AUTO_INCREMENT,
  `license` varchar(255) NOT NULL DEFAULT '0',
  `active_slots` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`#`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

CREATE TABLE `multichar_tbx` (
	`tbx` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb3_general_ci',
	`active` TINYINT(2) NULL DEFAULT NULL
) COLLATE='utf8mb3_general_ci' ENGINE=InnoDB;