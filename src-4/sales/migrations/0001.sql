--
-- Create model ContractType
--
CREATE TABLE `contracts_type` (`id` integer AUTO_INCREMENT NOT NULL PRIMARY KEY, `name` varchar(64) NOT NULL UNIQUE);
--
-- Create model Contract
--
CREATE TABLE `contracts` (`number` varchar(32) NOT NULL PRIMARY KEY, `price` double precision NOT NULL, `dt_issue` date NOT NULL, `flat_id` integer NOT NULL, `type_id` integer NOT NULL);
--
-- Create model Sale
--
CREATE TABLE `sales` (`id` integer AUTO_INCREMENT NOT NULL PRIMARY KEY, `part_price` double precision NOT NULL, `client_id` varchar(16) NOT NULL, `contract_id` varchar(32) NOT NULL);
ALTER TABLE `contracts` ADD CONSTRAINT `contracts_flat_id_0e30615f_fk_flats_id` FOREIGN KEY (`flat_id`) REFERENCES `flats` (`id`);
ALTER TABLE `contracts` ADD CONSTRAINT `contracts_type_id_c510c47f_fk_contracts_type_id` FOREIGN KEY (`type_id`) REFERENCES `contracts_type` (`id`);
ALTER TABLE `sales` ADD CONSTRAINT `sales_client_id_32ab12f6_fk_clients_unic` FOREIGN KEY (`client_id`) REFERENCES `clients` (`unic`);
ALTER TABLE `sales` ADD CONSTRAINT `sales_contract_id_d5903b6b_fk_contracts_number` FOREIGN KEY (`contract_id`) REFERENCES `contracts` (`number`);
