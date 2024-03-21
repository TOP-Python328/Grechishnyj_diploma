--
-- Create model BuildingPermit
--
CREATE TABLE `building_permits` (`id` integer AUTO_INCREMENT NOT NULL PRIMARY KEY, `number` varchar(32) NOT NULL UNIQUE, `dt_issue` date NOT NULL, `dt_expiry` date NOT NULL);
--
-- Create model Construction
--
CREATE TABLE `constructions` (`id` integer AUTO_INCREMENT NOT NULL PRIMARY KEY, `name` varchar(32) NOT NULL UNIQUE);
--
-- Create model EnergySave
--
CREATE TABLE `energy_saves` (`name` varchar(4) NOT NULL PRIMARY KEY);
--
-- Create model Floor
--
CREATE TABLE `floors` (`id` integer AUTO_INCREMENT NOT NULL PRIMARY KEY, `number` varchar(2) NOT NULL);
--
-- Create model HouseType
--
CREATE TABLE `house_types` (`id` integer AUTO_INCREMENT NOT NULL PRIMARY KEY, `name` varchar(128) NOT NULL);
--
-- Create model Room
--
CREATE TABLE `rooms` (`id` integer AUTO_INCREMENT NOT NULL PRIMARY KEY, `name` varchar(32) NOT NULL UNIQUE, `living` bool NOT NULL, `koef_price` double precision NOT NULL);
--
-- Create model SaleStatus
--
CREATE TABLE `sale_statuses` (`name` varchar(16) NOT NULL PRIMARY KEY);
--
-- Create model SectionType
--
CREATE TABLE `section_types` (`name` varchar(32) NOT NULL PRIMARY KEY);
--
-- Create model Seismic
--
CREATE TABLE `seismics` (`name` varchar(4) NOT NULL PRIMARY KEY);
--
-- Create model Flat
--
CREATE TABLE `flats` (`id` integer AUTO_INCREMENT NOT NULL PRIMARY KEY, `number` varchar(4) NOT NULL, `floor_id` integer NOT NULL, `status_id` varchar(16) NOT NULL);
--
-- Create model House
--
CREATE TABLE `houses` (`id` integer AUTO_INCREMENT NOT NULL PRIMARY KEY, `number` varchar(8) NOT NULL, `building_permit_id` integer NOT NULL, `construction_id` integer NOT NULL, `energy_save_id` varchar(4) NOT NULL, `type_id` integer NOT NULL, `seismic_id` varchar(4) NOT NULL);
--
-- Create model Plan
--
CREATE TABLE `flats_plan` (`id` integer AUTO_INCREMENT NOT NULL PRIMARY KEY, `square` double precision NOT NULL, `flat_id` integer NOT NULL, `room_id` integer NOT NULL);
--
-- Create model Section
--
CREATE TABLE `sections` (`id` integer AUTO_INCREMENT NOT NULL PRIMARY KEY, `number` varchar(2) NOT NULL, `house_id` integer NOT NULL, `name_id` varchar(32) NOT NULL);
--
-- Add field section to floor
--
ALTER TABLE `floors` ADD COLUMN `section_id` integer NOT NULL , ADD CONSTRAINT `floors_section_id_abac1cc0_fk_sections_id` FOREIGN KEY (`section_id`) REFERENCES `sections`(`id`);
ALTER TABLE `flats` ADD CONSTRAINT `flats_floor_id_3a4e34f7_fk_floors_id` FOREIGN KEY (`floor_id`) REFERENCES `floors` (`id`);
ALTER TABLE `flats` ADD CONSTRAINT `flats_status_id_2534314c_fk_sale_statuses_name` FOREIGN KEY (`status_id`) REFERENCES `sale_statuses` (`name`);
ALTER TABLE `houses` ADD CONSTRAINT `houses_building_permit_id_d2922e13_fk_building_permits_id` FOREIGN KEY (`building_permit_id`) REFERENCES `building_permits` (`id`);
ALTER TABLE `houses` ADD CONSTRAINT `houses_construction_id_eed165e8_fk_constructions_id` FOREIGN KEY (`construction_id`) REFERENCES `constructions` (`id`);
ALTER TABLE `houses` ADD CONSTRAINT `houses_energy_save_id_5b55e815_fk_energy_saves_name` FOREIGN KEY (`energy_save_id`) REFERENCES `energy_saves` (`name`);
ALTER TABLE `houses` ADD CONSTRAINT `houses_type_id_e940e8d5_fk_house_types_id` FOREIGN KEY (`type_id`) REFERENCES `house_types` (`id`);
ALTER TABLE `houses` ADD CONSTRAINT `houses_seismic_id_7f023459_fk_seismics_name` FOREIGN KEY (`seismic_id`) REFERENCES `seismics` (`name`);
ALTER TABLE `flats_plan` ADD CONSTRAINT `flats_plan_flat_id_fb18a298_fk_flats_id` FOREIGN KEY (`flat_id`) REFERENCES `flats` (`id`);
ALTER TABLE `flats_plan` ADD CONSTRAINT `flats_plan_room_id_3aec42cd_fk_rooms_id` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`id`);
ALTER TABLE `sections` ADD CONSTRAINT `sections_house_id_ca91d0c5_fk_houses_id` FOREIGN KEY (`house_id`) REFERENCES `houses` (`id`);
ALTER TABLE `sections` ADD CONSTRAINT `sections_name_id_ce05135c_fk_section_types_name` FOREIGN KEY (`name_id`) REFERENCES `section_types` (`name`);


