CREATE TABLE `objects` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`model` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
	`coords` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_general_ci',
	`type` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`options` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_bin',
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=10
;
