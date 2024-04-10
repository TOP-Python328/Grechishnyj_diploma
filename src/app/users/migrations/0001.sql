--
-- Create model CustomUser
--
CREATE TABLE `users_customuser` (`id` integer AUTO_INCREMENT NOT NULL PRIMARY KEY, `password` varchar(128) NOT NULL, `last_login` datetime(6) NULL, `is_superuser` bool NOT NULL, `username` varchar(150) NOT NULL UNIQUE, `first_name` varchar(150) NOT NULL, `last_name` varchar(150) NOT NULL, `email` varchar(254) NOT NULL UNIQUE, `is_staff` bool NOT NULL, `is_active` bool NOT NULL, `date_joined` datetime(6) NOT NULL, `dbase` varchar(16) NOT NULL UNIQUE);
CREATE TABLE `users_customuser_groups` (`id` integer AUTO_INCREMENT NOT NULL PRIMARY KEY, `customuser_id` integer NOT NULL, `group_id` integer NOT NULL);
CREATE TABLE `users_customuser_user_permissions` (`id` integer AUTO_INCREMENT NOT NULL PRIMARY KEY, `customuser_id` integer NOT NULL, `permission_id` integer NOT NULL);
ALTER TABLE `users_customuser_groups` ADD CONSTRAINT `users_customuser_groups_customuser_id_group_id_76b619e3_uniq` UNIQUE (`customuser_id`, `group_id`);
ALTER TABLE `users_customuser_groups` ADD CONSTRAINT `users_customuser_gro_customuser_id_958147bf_fk_users_cus` FOREIGN KEY (`customuser_id`) REFERENCES `users_customuser` (`id`);
ALTER TABLE `users_customuser_groups` ADD CONSTRAINT `users_customuser_groups_group_id_01390b14_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`);
ALTER TABLE `users_customuser_user_permissions` ADD CONSTRAINT `users_customuser_user_pe_customuser_id_permission_7a7debf6_uniq` UNIQUE (`customuser_id`, `permission_id`);
ALTER TABLE `users_customuser_user_permissions` ADD CONSTRAINT `users_customuser_use_customuser_id_5771478b_fk_users_cus` FOREIGN KEY (`customuser_id`) REFERENCES `users_customuser` (`id`);
ALTER TABLE `users_customuser_user_permissions` ADD CONSTRAINT `users_customuser_use_permission_id_baaa2f74_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`);
