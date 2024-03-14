use topdip;

-- Пол
insert into sex(id, name) values(0, 'женский');
insert into sex(id, name) values(1, 'мужской');


-- Люди
insert into persons(last_name, first_name, patr_name, birthday, sex_id) values('Иванов', 'Иван', 'Иванович', '1995-01-01', 1);
insert into persons(last_name, first_name, patr_name, birthday, sex_id) values('Петров', 'Пётр', 'Петрович', '1992-07-17', 1);
insert into persons(last_name, first_name, patr_name, birthday, sex_id) values('Кузнецов', 'Олег', 'Викторович', '1986-07-23', 1);
insert into persons(last_name, first_name, patr_name, birthday, sex_id) values('Дмитриев', 'Павел', 'Александрович', '1988-08-13', 1);
insert into persons(last_name, first_name, patr_name, birthday, sex_id) values('Глазунов', 'Дмитрий', 'Михайлович', '1982-02-12', 1);
insert into persons(last_name, first_name, patr_name, birthday, sex_id) values('Терехина', 'Татьяна', 'Олеговна', '1999-12-22', 0);
insert into persons(last_name, first_name, patr_name, birthday, sex_id) values('Кардаш', 'Юлия', 'Владимировна', '1985-01-11', 0);
insert into persons(last_name, first_name, patr_name, birthday, sex_id) values('Дружинина', 'Елена', 'Альбертовна', '1985-01-16', 0);
insert into persons(last_name, first_name, patr_name, birthday, sex_id) values('Кададкий', 'Артём', 'Васильевич', '1976-11-11', 1);
insert into persons(last_name, first_name, patr_name, birthday, sex_id) values('Прохоренко', 'Андрей', 'Михайлович', '1976-10-31', 1);
insert into persons(last_name, first_name, patr_name, birthday, sex_id) values('Степанова', 'Вероника', 'Сергеевна', '2000-05-09', 0);



-- Паспорта - клиенты
insert into passports(series, unic, number, police, police_code, dt_issue, address_id, birth_place, person_id)
values('2900', '2900102030', '102030', 'ТП УФМС РОССИИ ПО КАЛУЖСКОЙ ОБЛАСТИ В ДЗЕРЖИНСКОМ РАЙОНЕ', '400-001', '2000-05-05', 2, 'Г. КАЛУГА', 1);
insert into clients(unic) values('2900102030');

insert into passports(series, unic, number, police, police_code, dt_issue, address_id, birth_place, person_id)
values('3678', '3678102030', '102030', 'ТП УФМС РОССИИ ПО ОРЛОВСКОЙ ОБЛАСТИ ГОРОДА МЦЕНСК', '510-001', '2019-12-05', 3, 'Г. МЦЕНСК ОРЛОВСКОЙ ОБЛАСТИ', 2);
insert into clients(unic) values('3678102030');

insert into passports(series, unic, number, police, police_code, dt_issue, address_id, birth_place, person_id)
values('3400', '3400784512', '784512', 'ТП УФМС РОССИИ ПО СМОЛЕНСКОЙ ОБЛАСТИ В ДЕСНОГОРСКОМ РАЙОНЕ', '650-001', '2010-10-10', 4, 'Г. СМОЛЕНСК', 3);
insert into clients(unic) values('3400784512');

insert into passports(series, unic, number, police, police_code, dt_issue, address_id, birth_place, person_id)
values('4500', '4500895623', '895623', 'ТП УФМС РОССИИ ПО ЯРОСЛАВСКОЙ ОБЛАСТИ В ДЗЕРЖИНСКОМ РАЙОНЕ', '770-001', '2022-02-28', 5, 'Г. ЯРОСЛАВЛЬ', 4);
insert into clients(unic) values('4500895623');

insert into passports(series, unic, number, police, police_code, dt_issue, address_id, birth_place, person_id)
values('1515', '1515794613', '794613', 'ТП УФМС РОССИИ ПО ТУЛЬСКОЙ ОБЛАСТИ В НОВОМОСКОВСКОМ РАЙОНЕ', '020-001', '2002-11-30', 6, 'Г. ТУЛА', 5);
insert into clients(unic) values('1515794613');

insert into passports(series, unic, number, police, police_code, dt_issue, address_id, birth_place, person_id)
values('3232', '3232456525', '456525', 'ТП УФМС РОССИИ ПО КАЛУЖСКОЙ ОБЛАСТИ В УЛЬЯНОВСКОМ РАЙОНЕ', '130-001', '2001-09-15', 7, 'Г. КАЛУГА', 6);
insert into clients(unic) values('3232456525');

insert into passports(series, unic, number, police, police_code, dt_issue, address_id, birth_place, person_id)
values('1000', '1000445566', '445566', 'ТП УФМС РОССИИ ПО ОРЛОВСКОЙ ОБЛАСТИ В ВЕРХОВСКОМ РАЙОНЕ', '555-001', '2010-04-01', 8, 'Г. ОРЁЛ', 7);
insert into clients(unic) values('1000445566');