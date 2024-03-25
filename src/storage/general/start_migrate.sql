CREATE TABLE `building_permits` (`id` integer AUTO_INCREMENT NOT NULL PRIMARY KEY, `number` varchar(32) NOT NULL UNIQUE, `dt_issue` date NOT NULL, `dt_expiry` date NOT NULL);
CREATE TABLE `constructions` (`id` integer AUTO_INCREMENT NOT NULL PRIMARY KEY, `name` varchar(32) NOT NULL UNIQUE);
CREATE TABLE `energy_saves` (`name` varchar(4) NOT NULL PRIMARY KEY);
CREATE TABLE `floors` (`id` integer AUTO_INCREMENT NOT NULL PRIMARY KEY, `number` varchar(2) NOT NULL);
CREATE TABLE `house_types` (`id` integer AUTO_INCREMENT NOT NULL PRIMARY KEY, `name` varchar(128) NOT NULL);
CREATE TABLE `rooms` (`id` integer AUTO_INCREMENT NOT NULL PRIMARY KEY, `name` varchar(32) NOT NULL UNIQUE, `living` bool NOT NULL, `koef_price` double precision NOT NULL);
CREATE TABLE `sale_statuses` (`name` varchar(16) NOT NULL PRIMARY KEY);
CREATE TABLE `section_types` (`name` varchar(32) NOT NULL PRIMARY KEY);
CREATE TABLE `seismics` (`name` varchar(4) NOT NULL PRIMARY KEY);
CREATE TABLE `flats` (`id` integer AUTO_INCREMENT NOT NULL PRIMARY KEY, `number` varchar(4) NOT NULL, `floor_id` integer NOT NULL, `status_id` varchar(16) NOT NULL);
CREATE TABLE `houses` (`id` integer AUTO_INCREMENT NOT NULL PRIMARY KEY, `number` varchar(8) NOT NULL, `building_permit_id` integer NOT NULL, `construction_id` integer NOT NULL, `energy_save_id` varchar(4) NOT NULL, `type_id` integer NOT NULL, `seismic_id` varchar(4) NOT NULL);
CREATE TABLE `flats_plan` (`id` integer AUTO_INCREMENT NOT NULL PRIMARY KEY, `square` double precision NOT NULL, `flat_id` integer NOT NULL, `room_id` integer NOT NULL);
CREATE TABLE `sections` (`id` integer AUTO_INCREMENT NOT NULL PRIMARY KEY, `number` varchar(2) NOT NULL, `house_id` integer NOT NULL, `name_id` varchar(32) NOT NULL);

