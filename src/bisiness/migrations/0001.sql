--
-- Create model Orgform
--
CREATE TABLE `orgforms` (`id` integer AUTO_INCREMENT NOT NULL PRIMARY KEY, `name` varchar(256) NOT NULL, `short_name` varchar(16) NOT NULL);
--
-- Create model BisinessCard
--
CREATE TABLE `bisiness_cards` (`name` varchar(256) NOT NULL, `ogrn` varchar(16) NOT NULL UNIQUE, `unic` varchar(16) NOT NULL PRIMARY KEY, `kpp` varchar(16) NULL, `address_id` integer NOT NULL, `director_id` integer NULL, `orgform_id` integer NOT NULL);
ALTER TABLE `bisiness_cards` ADD CONSTRAINT `bisiness_cards_address_id_d189d491_fk_addresses_id` FOREIGN KEY (`address_id`) REFERENCES `addresses` (`id`);
ALTER TABLE `bisiness_cards` ADD CONSTRAINT `bisiness_cards_director_id_bc2252bb_fk_persons_id` FOREIGN KEY (`director_id`) REFERENCES `persons` (`id`);
ALTER TABLE `bisiness_cards` ADD CONSTRAINT `bisiness_cards_orgform_id_60abd724_fk_orgforms_id` FOREIGN KEY (`orgform_id`) REFERENCES `orgforms` (`id`);
