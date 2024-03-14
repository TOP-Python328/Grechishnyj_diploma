--
-- Create model Country
--
CREATE TABLE `countries` (`id` integer AUTO_INCREMENT NOT NULL PRIMARY KEY, `full_name` varchar(32) NOT NULL UNIQUE, `short_name` varchar(16) NULL, `int_code` varchar(4) NOT NULL);
--
-- Create model Locality
--
CREATE TABLE `locations` (`name` varchar(32) NOT NULL PRIMARY KEY, `size` varchar(8) NOT NULL);
--
-- Create model Region
--
CREATE TABLE `regions` (`id` integer AUTO_INCREMENT NOT NULL PRIMARY KEY, `name` varchar(64) NOT NULL UNIQUE, `country_id` integer NOT NULL, `locality_id` varchar(32) NOT NULL);
--
-- Create model Address
--
CREATE TABLE `addresses` (`id` integer AUTO_INCREMENT NOT NULL PRIMARY KEY, `postal_code` varchar(8) NULL, `district` varchar(32) NULL, `title` varchar(32) NOT NULL, `street` varchar(32) NOT NULL, `house` varchar(32) NULL, `index` varchar(32) NULL, `flat` varchar(8) NULL, `locality_id` varchar(32) NOT NULL, `region_id` integer NOT NULL);
ALTER TABLE `regions` ADD CONSTRAINT `regions_country_id_432a4d4c_fk_countries_id` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`);
ALTER TABLE `regions` ADD CONSTRAINT `regions_locality_id_f76cb568_fk_locations_name` FOREIGN KEY (`locality_id`) REFERENCES `locations` (`name`);
ALTER TABLE `addresses` ADD CONSTRAINT `addresses_locality_id_9a9bf5a3_fk_locations_name` FOREIGN KEY (`locality_id`) REFERENCES `locations` (`name`);
ALTER TABLE `addresses` ADD CONSTRAINT `addresses_region_id_1addacb7_fk_regions_id` FOREIGN KEY (`region_id`) REFERENCES `regions` (`id`);
