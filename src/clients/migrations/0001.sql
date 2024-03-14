--
-- Create model Client
--
CREATE TABLE `clients` (`unic` varchar(16) NOT NULL PRIMARY KEY);
--
-- Create model Bank
--
CREATE TABLE `banks` (`bik` varchar(16) NOT NULL, `department` varchar(128) NOT NULL, `pay_account` varchar(32) NOT NULL PRIMARY KEY, `cor_account` varchar(32) NOT NULL, `bisiness_card_id` varchar(16) NOT NULL, `client_id` varchar(16) NOT NULL);
ALTER TABLE `banks` ADD CONSTRAINT `banks_bisiness_card_id_04c60790_fk_bisiness_cards_unic` FOREIGN KEY (`bisiness_card_id`) REFERENCES `bisiness_cards` (`unic`);
ALTER TABLE `banks` ADD CONSTRAINT `banks_client_id_779a7776_fk_clients_unic` FOREIGN KEY (`client_id`) REFERENCES `clients` (`unic`);
