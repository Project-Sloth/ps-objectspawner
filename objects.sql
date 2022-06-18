CREATE TABLE `objects` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`model` varchar(50) NOT NULL,
	`coords` varchar(255) NOT NULL,
	`type` varchar(50) DEFAULT NULL,
	`options` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`options`)),
	`name` varchar(25) DEFAULT NULL,
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='utf8mb4_general_ci' ENGINE=InnoDB AUTO_INCREMENT=1;