--
-- Create model Person
--
CREATE TABLE `persons` (`id` integer AUTO_INCREMENT NOT NULL PRIMARY KEY, `last_name` varchar(32) NOT NULL, `first_name` varchar(32) NOT NULL, `patr_name` varchar(32) NULL, `birthday` date NOT NULL);
--
-- Create model Sex
--
CREATE TABLE `sex` (`id` bool NOT NULL PRIMARY KEY, `name` varchar(8) NOT NULL UNIQUE);
--
-- Create model Passport
--
CREATE TABLE `passports` (`series` varchar(4) NOT NULL, `number` varchar(8) NOT NULL, `unic` varchar(16) NOT NULL PRIMARY KEY, `police` varchar(256) NOT NULL, `police_code` varchar(8) NOT NULL, `dt_issue` date NOT NULL, `birth_place` varchar(128) NOT NULL, `address_id` integer NOT NULL, `person_id` integer NOT NULL UNIQUE);
--
-- Add field sex to person
--
ALTER TABLE `persons` ADD COLUMN `sex_id` bool NOT NULL , ADD CONSTRAINT `persons_sex_id_13a094c1_fk_sex_id` FOREIGN KEY (`sex_id`) REFERENCES `sex`(`id`);
ALTER TABLE `passports` ADD CONSTRAINT `passports_address_id_d27ac239_fk_addresses_id` FOREIGN KEY (`address_id`) REFERENCES `addresses` (`id`);
ALTER TABLE `passports` ADD CONSTRAINT `passports_person_id_4b64c354_fk_persons_id` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`);
