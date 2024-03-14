drop database if exists dipltop;
create database dipltop;
use dipltop;

-- ------------------------------------------------
-- Сущности описывающие объект (квартиру) продажи
-- ------------------------------------------------

-- виды комнат:
--     id
--     name_room наименование комнаты (гостинная, кухня ...)
--     living жилая или не жилая
--     koef_price коэффициент стоимости
create table rooms(
    id smallint unsigned primary key auto_increment,
    name_room varchar(32) not null unique,
    living boolean not null,
    koef_price float not null
);

-- комнаты
--     id
--     square площадь комнаты
--     type_id тип комнаты (гостинная, кухня ...) (один ко многим)
-- create table rooms(
--     id smallint unsigned primary key auto_increment,
--     square float not null,
--     type_id smallint not null references rooms_types (id)
-- );

-- статус квартиры
--     id статус (забронировано, продано ...)
create table sales_statuses(
    id varchar(16) primary key not null unique
);

-- квартиры
--     id
--     номер квартиры
--     этаж (один ко многим)
--     статус (продано, забронировано) (один ко многим)
create table flats(
    id smallint unsigned primary key auto_increment,
    number varchar(4) not null,
    floor_id smallint unsigned not null references floors (id),
    sale_status varchar(16) not null references sales_statuses (id)
);

create table flats_rooms(
    flat_id smallint unsigned not null references flats (id),
    room_id smallint unsigned not null references rooms (id),
    square float not null
);

-- этажи
    -- id
    -- number номер этажа
    -- section_id секция(подьезд)
create table floors(
    id smallint unsigned primary key auto_increment,
    number varchar(4) not null,
    section_id smallint unsigned not null references sections (id)
);

-- типы секций(подъездов)
    -- id (одиночная, торцевая, рядовая ....)
create table sections_types(
    id varchar(16) primary key not null unique
);

-- секции(подъезды)
    -- id
    -- number номер
    -- type_id тип подьезда
    -- house_id дом
create table sections(
    id smallint unsigned primary key auto_increment,
    number varchar(4) not null,
    type_id varchar(16) not null references sections_types (id),
    house_id smallint unsigned not null references houses (id)
);

-- Классы энергетической эффективности
    -- (A++, A+, A, B+, B, C+, C, C-, D, E)
create table energy_saves(
    id char(4) primary key not null unique
);

-- Класс сейсмостойкости
    -- (C5, C6, C7, C8, C9, C10)
create table seismics(
    id char(4) primary key not null unique
);

-- Разрешение на строительство
    -- id 
    -- number номер разрешения
    -- dt_issue дата выдачи
    -- dt_expiry дата окончания срока действия
create table building_permits(
    id smallint unsigned primary key auto_increment,
    number varchar(32) not null unique,
    dt_issue date not null,
    dt_expiry date not null
);

-- Многоквартирные дома
--     id 
--     number номер дома
--     quater_id микрорайон
--     building_permit_id разрешение на строительство
--     seismic класс сейсмостойкости
--     energy_save класс эффективности
create table houses(
    id smallint unsigned primary key auto_increment,
    number varchar(8) not null,
    quater_id smallint unsigned not null references quaters (id),
    building_permit_id smallint unsigned not null references building_permits (id),
    seismic char(4) not null references seismic (id),
    energy_save char(4) not null references energy_saves (id)
);

-- Микрорайоны
    -- id
    -- name наименование микрорайона
create table quaters(
    id smallint unsigned primary key auto_increment,
    name varchar(32) not null
);

-- ----------------------------------------------------------------------
-- Сущности описывающие объекты (стороны сделки) покупатель-продавец
-- ----------------------------------------------------------------------

-- Пол 
-- +----+----------+
-- | id | name     |
-- +----+----------+
-- | 0  | женский  |
-- | 1  | мужской  |
-- +----+----------+
create table sex(
    id boolean primary key unique,
    name varchar(8) unique
);

-- Персоны
--     id
--     last_name фамилия
--     first_name имя
--     patr_name отчество
--     birthday дата рождения
--     sex пол
create table persons(
    id smallint unsigned primary key auto_increment,
    last_name varchar(32) not null,
    first_name varchar(32) not null,
    patr_name varchar(32),
    birthday date not null,
    sex boolean not null references sex (id)
);

-- Организационно-правовые формы
--     (ООО, ОАО ...)
create table orgforms(
    id smallint unsigned primary key auto_increment,
    name varchar(128) not null unique,
    short_name varchar(16) not null unique
);

-- Карточка юридического лица (идентифицирует юридическое лицо)
--     id
--     name наименование
--     ogrn огрн
--     inn инн
--     kpp кпп
--     orgform_id организационно-правовая форма
--     address_id адрес
--     director_id руководитель
create table bisiness_cards(
    id smallint unsigned primary key auto_increment,
    name varchar(64) not null,
    ogrn varchar(16) unique not null,
    inn varchar(16) unique not null,
    kpp varchar(16) not null,
    orgform_id smallint unsigned not null references orgforms (id),
    address_id smallint unsigned not null references addresses (id),
    director_id smallint unsigned not null references persons (id)
);


-- Паспорт клиента (идентифицирует физическое лицо)
    -- id
    -- series серия
    -- number номер
    -- unic_number уникальный номер (серия + номер)
    -- police_id отделение выдавшее
    -- address_id адрес прописки
    -- person_id владелец
create table passports(
    id smallint unsigned primary key auto_increment,
    series char(8) not null,
    number char(8) not null,
    unic_number varchar(16) unique not null,
    police varchar(256) not null,
    police_code varchar(8) not null,
    dt_issue date not null,
    address_id smallint unsigned not null references addresses (id),
    person_id smallint unsigned not null references persons (id)
);

-- Клиенты покупатели могут быть юридическим либо физическим лицом 
    -- id
    -- unic_number уникальный номер (либо паспорт либо с карточка организации)
create table clients(
    id smallint unsigned primary key auto_increment,
    unic_number varchar(16) not null unique
);

-- Банк (расчетный счет)
    -- id
    -- bik банковкий номер
    -- branch филиал отделение
    -- pay_account расчетный счет
    -- cor_account корреспондентский счет
    -- bisiness_card_id карта организации (банк как сущность юридическое лицо)
    -- client_id клиент владелец
create table banks(
    id smallint unsigned primary key auto_increment,
    bik varchar(16) not null,
    department varchar(64),
    pay_account varchar(32) unique not null,
    cor_account varchar(32),
    bisiness_card_id smallint unsigned not null references bisiness_cards (id),
    client_id smallint unsigned not null references clients (id),
    director_id smallint unsigned references persons (id),
    address_id smallint unsigned references addresses (id)
);

-- ----------------------------------------------------------------------
-- Сущности описывающие объекты (локации) адрес
-- ----------------------------------------------------------------------
-- Тип локаций
    -- id
    -- name тип населенного пункта (республика, край, область, город, село ...)
create table locality_types(
    id varchar(32) primary key not null unique
);
-- Адрес 
--     id
--     region_id регион
--     postal_code почтовый индекс
--     district район(округ)
--     locality_type_id тип населенного пункта
--     locality_title название населенного пункта
--     street улица
--     home дом
--     building строение(корпус)
--     flat квартира
create table addresses(
    id smallint unsigned primary key auto_increment,
    postal_code varchar(8),
    region_id smallint unsigned references regions (id),
    district varchar(32),
    locality_type_id varchar(32) not null references locality_types (id),
    locality_title varchar(32) not null,
    street varchar(32) not null,
    home varchar(8),
    building varchar(8),
    flat varchar(8)
);

-- Страна(ы)
create table countries(
    id smallint unsigned primary key auto_increment,
    full_name varchar(64) unique not null,
    short_name varchar(32) unique,
    int_code char(4)
);

-- Регионы (субъекты РФ) 
create table regions(
    id smallint unsigned primary key auto_increment,
    first_name varchar(32) unique not null,
    last_name varchar(32),
    locality_type_id varchar(32) not null references locality_types (id),
    country_id smallint unsigned not null references countries (id)
);

-- Города по умолчанию
create table cities(
    id smallint unsigned primary key auto_increment,
    locality_type_id varchar(32) not null references locality_types (id),
    locality_title varchar(32) not null,
    region_id smallint unsigned references regions (id),
    district varchar(32)
);

-- ----------------------------------------------------------------------
-- Сущности описывающие объект Контраткт
-- ----------------------------------------------------------------------

-- Контракты
    -- id
    -- number номер
    -- dt_create дата создания
    -- flat_id объект недвижимости (квартира)
create table contracts(
    id smallint unsigned primary key auto_increment,
    number varchar(32) unique not null,
    dt_create date not null,
    flat_id smallint unsigned not null references flats (id)
);

-- Контракты - клиенты (в одном контракте может бфть несколько клиентов)
    -- contract_id контракт
    -- client_id клиент
create table contracts_clients(
    contract_id smallint unsigned not null references contracts (id),
    client_id smallint unsigned not null references clients (id),
    part float not null
);


-- ----------------------------------------------------------------------
-- Дополнительно - контакты
-- ----------------------------------------------------------------------

-- Виды связи (ссылки) с клиентами (почта телефон соцсети)
create table contact_types(
    id smallint unsigned primary key auto_increment,
    name varchar(16) not null unique
);

-- Контакты-клиентов
--     contract_type_id вид связи
--     client_id клиент
--     link номер(ссылка, email ...)
create table contacts_clients(
    contract_type_id smallint unsigned not null references contact_types (id),
    client_id smallint unsigned not null references contact_types (id),
    link varchar(32) unique not null
);


-- - MySQL  localhost:33060+ ssl  dipltop  SQL > show tables;
-- +-------------------+
-- | Tables_in_dipltop |
-- +-------------------+
-- | addresses         |
-- | banks             |
-- | bisiness_cards    |
-- | building_permits  |
-- | clients           |
-- | contact_types     |
-- | contacts_clients  |
-- | contracts         |
-- | contracts_clients |
-- | energy_saves      |
-- | flats             |
-- | floors            |
-- | houses            |
-- | locality_types    |
-- | orgforms          |
-- | passport          |
-- | persons           |
-- | police            |
-- | quaters           |
-- | regions           |
-- | rooms             |
-- | sales_statuses    |
-- | sections          |
-- | sections_types    |
-- | seismics          |
-- | sex               |
-- +-------------------+

-- ----------------------------------------------------------------------
-- Добавление статических данных
-- ----------------------------------------------------------------------

-- Типы комнат
insert into rooms (name_room, living, koef_price) values ('гостинная', 1, 1);
insert into rooms (name_room, living, koef_price) values ('спальня', 1, 1);
insert into rooms (name_room, living, koef_price) values ('детская', 1, 1);
insert into rooms (name_room, living, koef_price) values ('кабинет', 1, 1);
insert into rooms (name_room, living, koef_price) values ('кухня', 0, 1);
insert into rooms (name_room, living, koef_price) values ('столовая', 0, 1);
insert into rooms (name_room, living, koef_price) values ('холл', 0, 1);
insert into rooms (name_room, living, koef_price) values ('прихожая', 0, 1);
insert into rooms (name_room, living, koef_price) values ('гардеробная', 0, 1);
insert into rooms (name_room, living, koef_price) values ('спортзал', 0, 1);
insert into rooms (name_room, living, koef_price) values ('мастерская', 0, 1);
insert into rooms (name_room, living, koef_price) values ('кладовая', 0, 1);
insert into rooms (name_room, living, koef_price) values ('котельная', 0, 1);
insert into rooms (name_room, living, koef_price) values ('ванная', 0, 1);
insert into rooms (name_room, living, koef_price) values ('туалет', 0, 1);
insert into rooms (name_room, living, koef_price) values ('санузел', 0, 1);
insert into rooms (name_room, living, koef_price) values ('балкон', 0, 0.5);
insert into rooms (name_room, living, koef_price) values ('лоджия', 0, 0.5);

-- select * from rooms;
-- +----+-------------+--------+------------+
-- | id | name_room   | living | koef_price |
-- +----+-------------+--------+------------+
-- |  1 | гостинная   |      1 |          1 |
-- |  2 | спальня     |      1 |          1 |
-- |  3 | детская     |      1 |          1 |
-- |  4 | кабинет     |      1 |          1 |
-- |  5 | кухня       |      0 |          1 |
-- |  6 | столовая    |      0 |          1 |
-- |  7 | холл        |      0 |          1 |
-- |  8 | прихожая    |      0 |          1 |
-- |  9 | гардеробная |      0 |          1 |
-- | 10 | спортзал    |      0 |          1 |
-- | 11 | мастерская  |      0 |          1 |
-- | 12 | кладовая    |      0 |          1 |
-- | 13 | котельная   |      0 |          1 |
-- | 14 | ванная      |      0 |          1 |
-- | 15 | туалет      |      0 |          1 |
-- | 16 | санузел     |      0 |          1 |
-- | 17 | балкон      |      0 |        0.5 |
-- | 18 | лоджия      |      0 |        0.5 |
-- +----+-------------+--------+------------+

-- Статусы квартиры
insert into sales_statuses (id) values ('свободно');
insert into sales_statuses (id) values ('забронировано');
insert into sales_statuses (id) values ('на оформлении');
insert into sales_statuses (id) values ('подписано');
insert into sales_statuses (id) values ('продано');
insert into sales_statuses (id) values ('передано');

-- select * from sales_statuses;
-- +---------------+
-- | id            |
-- +---------------+
-- | забронировано |
-- | на оформлении |
-- | передано      |
-- | подписано     |
-- | продано       |
-- | свободно      |
-- +---------------+

-- Типы секций
insert into sections_types (id) values ('одиночная');
insert into sections_types (id) values ('рядовая');
insert into sections_types (id) values ('торцевая');
insert into sections_types (id) values ('угловая');

-- select * from sections_types;
-- +-----------+
-- | id        |
-- +-----------+
-- | одиночная |
-- | рядовая   |
-- | торцевая  |
-- | угловая   |
-- +-----------+

-- Классы энергетической эффективости
insert into energy_saves (id) values ('A++');
insert into energy_saves (id) values ('A+');
insert into energy_saves (id) values ('A');
insert into energy_saves (id) values ('B+');
insert into energy_saves (id) values ('B');
insert into energy_saves (id) values ('C+');
insert into energy_saves (id) values ('C');
insert into energy_saves (id) values ('C-');
insert into energy_saves (id) values ('D');
insert into energy_saves (id) values ('E');

-- select * from energy_saves;
-- +-----+
-- | id  |
-- +-----+
-- | A   |
-- | A+  |
-- | A++ |
-- | B   |
-- | B+  |
-- | C   |
-- | C-  |
-- | C+  |
-- | D   |
-- | E   |
-- +-----+

-- Классы сейсмостойкости
insert into seismics (id) values ('C5');
insert into seismics (id) values ('C6');
insert into seismics (id) values ('C7');
insert into seismics (id) values ('C8');
insert into seismics (id) values ('C9');
insert into seismics (id) values ('C10');

-- select * from seismics;
-- +-----+
-- | id  |
-- +-----+
-- | C10 |
-- | C5  |
-- | C6  |
-- | C7  |
-- | C8  |
-- | C9  |
-- +-----+

-- Пол
insert into sex (id, name) values (0, 'женский');
insert into sex (id, name) values (1, 'мужской');

-- select * from sex;
-- +----+---------+
-- | id | name    |
-- +----+---------+
-- |  0 | женский |
-- |  1 | мужской |
-- +----+---------+

-- Организационно-правовые формы

insert into orgforms (name, short_name) values ('общество с ограниченной ответственностью', 'ооо');
insert into orgforms (name, short_name) values ('публичное акционерное общество', 'пао');
insert into orgforms (name, short_name) values ('идивидуальный предриниматель', 'ип');

-- select * from orgforms;
-- +----+------------------------------------------+------------+
-- | id | name                                     | short_name |
-- +----+------------------------------------------+------------+
-- |  1 | общество с ограниченной ответственностью | ооо        |
-- |  2 | публичное акционерное общество           | пао        |
-- |  3 | идивидуальный предриниматель             | ип         |
-- +----+------------------------------------------+------------+


-- ----------------------------------------------------------------------
-- Доваление тестовых данных
-- ----------------------------------------------------------------------

-- Микрорайон
insert into quaters (name) values ('Малиновка');
-- select * from quaters;
-- +----+-----------+
-- | id | name      |
-- +----+-----------+
-- |  1 | Малиновка |
-- +----+-----------+

-- Разрешения на строительство
insert into building_permits (number, dt_issue, dt_expiry) values ('RU-40-0001-24', '2024-01-01', '2024-12-31');
insert into building_permits (number, dt_issue, dt_expiry) values ('RU-40-0002-24', '2024-01-10', '2025-01-10');
-- select * from building_permits;
-- +----+---------------+------------+------------+
-- | id | number        | dt_issue   | dt_expiry  |
-- +----+---------------+------------+------------+
-- |  1 | RU-40-0001-24 | 2024-01-01 | 2024-12-31 |
-- |  2 | RU-40-0002-24 | 2024-01-10 | 2025-01-10 |
-- +----+---------------+------------+------------+

-- Многоквартирные дома
insert into houses (number, quater_id, building_permit_id, seismic, energy_save) values ('6', 1, 1, 'C7', 'A++');
insert into houses (number, quater_id, building_permit_id, seismic, energy_save) values ('9', 1, 2, 'C7', 'A++');

-- select * from houses;
-- +----+--------+-----------+--------------------+---------+-------------+
-- | id | number | quater_id | building_permit_id | seismic | energy_save |
-- +----+--------+-----------+--------------------+---------+-------------+
-- |  1 | 6      |         1 |                  1 | C7      | A++         |
-- |  2 | 9      |         1 |                  2 | C7      | A++         |
-- +----+--------+-----------+--------------------+---------+-------------+

-- Секции подъезды
insert into sections (number, type_id, house_id) values ('1', 'торцевая', 1);
insert into sections (number, type_id, house_id) values ('2', 'рядовая', 1);
insert into sections (number, type_id, house_id) values ('3', 'торцевая', 1);
insert into sections (number, type_id, house_id) values ('1', 'одиночная', 2);

-- select * from sections;
-- +----+--------+---------+----------+
-- | id | number | type_id | house_id |
-- +----+--------+---------+----------+
-- |  1 | 1      |       3 |        1 |
-- |  2 | 2      |       2 |        1 |
-- |  3 | 3      |       3 |        1 |
-- |  4 | 1      |       1 |        2 |
-- +----+--------+---------+----------+

-- Этажи
insert into floors (number, section_id) values ('1', 1);
insert into floors (number, section_id) values ('2', 1);
insert into floors (number, section_id) values ('3', 1);
insert into floors (number, section_id) values ('4', 1);
insert into floors (number, section_id) values ('5', 1);
insert into floors (number, section_id) values ('6', 1);
insert into floors (number, section_id) values ('7', 1);
insert into floors (number, section_id) values ('8', 1);
insert into floors (number, section_id) values ('9', 1);
insert into floors (number, section_id) values ('10', 1);
insert into floors (number, section_id) values ('1', 2);
insert into floors (number, section_id) values ('2', 2);
insert into floors (number, section_id) values ('3', 2); 
insert into floors (number, section_id) values ('4', 2);
insert into floors (number, section_id) values ('5', 2);
insert into floors (number, section_id) values ('6', 2);
insert into floors (number, section_id) values ('7', 2);
insert into floors (number, section_id) values ('8', 2);
insert into floors (number, section_id) values ('9', 2);
insert into floors (number, section_id) values ('10', 2);
insert into floors (number, section_id) values ('1', 3);
insert into floors (number, section_id) values ('2', 3);
insert into floors (number, section_id) values ('3', 3);
insert into floors (number, section_id) values ('4', 3);
insert into floors (number, section_id) values ('5', 3);
insert into floors (number, section_id) values ('6', 3);
insert into floors (number, section_id) values ('7', 3);
insert into floors (number, section_id) values ('8', 3);
insert into floors (number, section_id) values ('9', 3);
insert into floors (number, section_id) values ('10', 3);
insert into floors (number, section_id) values ('1', 4);
insert into floors (number, section_id) values ('2', 4);
insert into floors (number, section_id) values ('3', 4);
insert into floors (number, section_id) values ('4', 4);
insert into floors (number, section_id) values ('5', 4);
insert into floors (number, section_id) values ('6', 4);
insert into floors (number, section_id) values ('7', 4);
insert into floors (number, section_id) values ('8', 4);
insert into floors (number, section_id) values ('9', 4);
insert into floors (number, section_id) values ('10', 4);
insert into floors (number, section_id) values ('11', 4);
insert into floors (number, section_id) values ('12', 4);
insert into floors (number, section_id) values ('13', 4);
insert into floors (number, section_id) values ('14', 4);
insert into floors (number, section_id) values ('15', 4);
insert into floors (number, section_id) values ('16', 4);
insert into floors (number, section_id) values ('17', 4);
insert into floors (number, section_id) values ('18', 4);
insert into floors (number, section_id) values ('19', 4);
-- select * from floors;
-- +----+--------+------------+
-- | id | number | section_id |
-- +----+--------+------------+
-- |  1 | 1      |          1 |
-- |  2 | 2      |          1 |
-- |  3 | 3      |          1 |
-- |  4 | 4      |          1 |
-- |  5 | 5      |          1 |
-- |  6 | 6      |          1 |
-- |  7 | 7      |          1 |
-- |  8 | 8      |          1 |
-- |  9 | 9      |          1 |
-- | 10 | 10     |          1 |
-- | 11 | 1      |          2 |
-- | 12 | 2      |          2 |
-- | 13 | 3      |          2 |
-- | 14 | 4      |          2 |
-- | 15 | 5      |          2 |
-- | 16 | 6      |          2 |
-- | 17 | 7      |          2 |
-- | 18 | 8      |          2 |
-- | 19 | 9      |          2 |
-- | 20 | 10     |          2 |
-- | 21 | 1      |          3 |
-- | 22 | 2      |          3 |
-- | 23 | 3      |          3 |
-- | 24 | 4      |          3 |
-- | 25 | 5      |          3 |
-- | 26 | 6      |          3 |
-- | 27 | 7      |          3 |
-- | 28 | 8      |          3 |
-- | 29 | 9      |          3 |
-- | 30 | 10     |          3 |
-- | 31 | 1      |          4 |
-- | 32 | 2      |          4 |
-- | 33 | 3      |          4 |
-- | 34 | 4      |          4 |
-- | 35 | 5      |          4 |
-- | 36 | 6      |          4 |
-- | 37 | 7      |          4 |
-- | 38 | 8      |          4 |
-- | 39 | 9      |          4 |
-- | 40 | 10     |          4 |
-- | 41 | 11     |          4 |
-- | 42 | 12     |          4 |
-- | 43 | 13     |          4 |
-- | 44 | 14     |          4 |
-- | 45 | 15     |          4 |
-- | 46 | 16     |          4 |
-- | 47 | 17     |          4 |
-- | 48 | 18     |          4 |
-- | 49 | 19     |          4 |
-- +----+--------+------------+

-- Квартиры
-- >>> n = 1
-- >>> f = 1
-- >>> for a in range(3):
-- ...     for i in range(1, 11):
-- ...             for j in range(4):
-- ...                     print(f'insert into flats (number, floor_id, sale_status) values ({n}, {f}, "свободно");')
-- ...                     n += 1
-- ...             f += 1
-- ...
insert into flats (number, floor_id, sale_status) values (1, 1, "свободно");
insert into flats (number, floor_id, sale_status) values (2, 1, "свободно");
insert into flats (number, floor_id, sale_status) values (3, 1, "свободно");
insert into flats (number, floor_id, sale_status) values (4, 1, "свободно");
insert into flats (number, floor_id, sale_status) values (5, 2, "свободно");
insert into flats (number, floor_id, sale_status) values (6, 2, "свободно");
insert into flats (number, floor_id, sale_status) values (7, 2, "свободно");
insert into flats (number, floor_id, sale_status) values (8, 2, "свободно");
insert into flats (number, floor_id, sale_status) values (9, 3, "свободно");
insert into flats (number, floor_id, sale_status) values (10, 3, "свободно");
insert into flats (number, floor_id, sale_status) values (11, 3, "свободно");
insert into flats (number, floor_id, sale_status) values (12, 3, "свободно");
insert into flats (number, floor_id, sale_status) values (13, 4, "свободно");
insert into flats (number, floor_id, sale_status) values (14, 4, "свободно");
insert into flats (number, floor_id, sale_status) values (15, 4, "свободно");
insert into flats (number, floor_id, sale_status) values (16, 4, "свободно");
insert into flats (number, floor_id, sale_status) values (17, 5, "свободно");
insert into flats (number, floor_id, sale_status) values (18, 5, "свободно");
insert into flats (number, floor_id, sale_status) values (19, 5, "свободно");
insert into flats (number, floor_id, sale_status) values (20, 5, "свободно");
insert into flats (number, floor_id, sale_status) values (21, 6, "свободно");
insert into flats (number, floor_id, sale_status) values (22, 6, "свободно");
insert into flats (number, floor_id, sale_status) values (23, 6, "свободно");
insert into flats (number, floor_id, sale_status) values (24, 6, "свободно");
insert into flats (number, floor_id, sale_status) values (25, 7, "свободно");
insert into flats (number, floor_id, sale_status) values (26, 7, "свободно");
insert into flats (number, floor_id, sale_status) values (27, 7, "свободно");
insert into flats (number, floor_id, sale_status) values (28, 7, "свободно");
insert into flats (number, floor_id, sale_status) values (29, 8, "свободно");
insert into flats (number, floor_id, sale_status) values (30, 8, "свободно");
insert into flats (number, floor_id, sale_status) values (31, 8, "свободно");
insert into flats (number, floor_id, sale_status) values (32, 8, "свободно");
insert into flats (number, floor_id, sale_status) values (33, 9, "свободно");
insert into flats (number, floor_id, sale_status) values (34, 9, "свободно");
insert into flats (number, floor_id, sale_status) values (35, 9, "свободно");
insert into flats (number, floor_id, sale_status) values (36, 9, "свободно");
insert into flats (number, floor_id, sale_status) values (37, 10, "свободно");
insert into flats (number, floor_id, sale_status) values (38, 10, "свободно");
insert into flats (number, floor_id, sale_status) values (39, 10, "свободно");
insert into flats (number, floor_id, sale_status) values (40, 10, "свободно");
insert into flats (number, floor_id, sale_status) values (41, 11, "свободно");
insert into flats (number, floor_id, sale_status) values (42, 11, "свободно");
insert into flats (number, floor_id, sale_status) values (43, 11, "свободно");
insert into flats (number, floor_id, sale_status) values (44, 11, "свободно");
insert into flats (number, floor_id, sale_status) values (45, 12, "свободно");
insert into flats (number, floor_id, sale_status) values (46, 12, "свободно");
insert into flats (number, floor_id, sale_status) values (47, 12, "свободно");
insert into flats (number, floor_id, sale_status) values (48, 12, "свободно");
insert into flats (number, floor_id, sale_status) values (49, 13, "свободно");
insert into flats (number, floor_id, sale_status) values (50, 13, "свободно");
insert into flats (number, floor_id, sale_status) values (51, 13, "свободно");
insert into flats (number, floor_id, sale_status) values (52, 13, "свободно");
insert into flats (number, floor_id, sale_status) values (53, 14, "свободно");
insert into flats (number, floor_id, sale_status) values (54, 14, "свободно");
insert into flats (number, floor_id, sale_status) values (55, 14, "свободно");
insert into flats (number, floor_id, sale_status) values (56, 14, "свободно");
insert into flats (number, floor_id, sale_status) values (57, 15, "свободно");
insert into flats (number, floor_id, sale_status) values (58, 15, "свободно");
insert into flats (number, floor_id, sale_status) values (59, 15, "свободно");
insert into flats (number, floor_id, sale_status) values (60, 15, "свободно");
insert into flats (number, floor_id, sale_status) values (61, 16, "свободно");
insert into flats (number, floor_id, sale_status) values (62, 16, "свободно");
insert into flats (number, floor_id, sale_status) values (63, 16, "свободно");
insert into flats (number, floor_id, sale_status) values (64, 16, "свободно");
insert into flats (number, floor_id, sale_status) values (65, 17, "свободно");
insert into flats (number, floor_id, sale_status) values (66, 17, "свободно");
insert into flats (number, floor_id, sale_status) values (67, 17, "свободно");
insert into flats (number, floor_id, sale_status) values (68, 17, "свободно");
insert into flats (number, floor_id, sale_status) values (69, 18, "свободно");
insert into flats (number, floor_id, sale_status) values (70, 18, "свободно");
insert into flats (number, floor_id, sale_status) values (71, 18, "свободно");
insert into flats (number, floor_id, sale_status) values (72, 18, "свободно");
insert into flats (number, floor_id, sale_status) values (73, 19, "свободно");
insert into flats (number, floor_id, sale_status) values (74, 19, "свободно");
insert into flats (number, floor_id, sale_status) values (75, 19, "свободно");
insert into flats (number, floor_id, sale_status) values (76, 19, "свободно");
insert into flats (number, floor_id, sale_status) values (77, 20, "свободно");
insert into flats (number, floor_id, sale_status) values (78, 20, "свободно");
insert into flats (number, floor_id, sale_status) values (79, 20, "свободно");
insert into flats (number, floor_id, sale_status) values (80, 20, "свободно");
insert into flats (number, floor_id, sale_status) values (81, 21, "свободно");
insert into flats (number, floor_id, sale_status) values (82, 21, "свободно");
insert into flats (number, floor_id, sale_status) values (83, 21, "свободно");
insert into flats (number, floor_id, sale_status) values (84, 21, "свободно");
insert into flats (number, floor_id, sale_status) values (85, 22, "свободно");
insert into flats (number, floor_id, sale_status) values (86, 22, "свободно");
insert into flats (number, floor_id, sale_status) values (87, 22, "свободно");
insert into flats (number, floor_id, sale_status) values (88, 22, "свободно");
insert into flats (number, floor_id, sale_status) values (89, 23, "свободно");
insert into flats (number, floor_id, sale_status) values (90, 23, "свободно");
insert into flats (number, floor_id, sale_status) values (91, 23, "свободно");
insert into flats (number, floor_id, sale_status) values (92, 23, "свободно");
insert into flats (number, floor_id, sale_status) values (93, 24, "свободно");
insert into flats (number, floor_id, sale_status) values (94, 24, "свободно");
insert into flats (number, floor_id, sale_status) values (95, 24, "свободно");
insert into flats (number, floor_id, sale_status) values (96, 24, "свободно");
insert into flats (number, floor_id, sale_status) values (97, 25, "свободно");
insert into flats (number, floor_id, sale_status) values (98, 25, "свободно");
insert into flats (number, floor_id, sale_status) values (99, 25, "свободно");
insert into flats (number, floor_id, sale_status) values (100, 25, "свободно");
insert into flats (number, floor_id, sale_status) values (101, 26, "свободно");
insert into flats (number, floor_id, sale_status) values (102, 26, "свободно");
insert into flats (number, floor_id, sale_status) values (103, 26, "свободно");
insert into flats (number, floor_id, sale_status) values (104, 26, "свободно");
insert into flats (number, floor_id, sale_status) values (105, 27, "свободно");
insert into flats (number, floor_id, sale_status) values (106, 27, "свободно");
insert into flats (number, floor_id, sale_status) values (107, 27, "свободно");
insert into flats (number, floor_id, sale_status) values (108, 27, "свободно");
insert into flats (number, floor_id, sale_status) values (109, 28, "свободно");
insert into flats (number, floor_id, sale_status) values (110, 28, "свободно");
insert into flats (number, floor_id, sale_status) values (111, 28, "свободно");
insert into flats (number, floor_id, sale_status) values (112, 28, "свободно");
insert into flats (number, floor_id, sale_status) values (113, 29, "свободно");
insert into flats (number, floor_id, sale_status) values (114, 29, "свободно");
insert into flats (number, floor_id, sale_status) values (115, 29, "свободно");
insert into flats (number, floor_id, sale_status) values (116, 29, "свободно");
insert into flats (number, floor_id, sale_status) values (117, 30, "свободно");
insert into flats (number, floor_id, sale_status) values (118, 30, "свободно");
insert into flats (number, floor_id, sale_status) values (119, 30, "свободно");
insert into flats (number, floor_id, sale_status) values (120, 30, "свободно");

-- >>> n = 1
-- >>> f = 31
-- >>> for a in range(1):
-- ...     for i in range(1, 20):
-- ...             for j in range(7):
-- ...                     print(f'insert into flats (number, floor_id, sale_status) values ({n}, {f}, "свободно");')
-- ...                     n += 1
-- ...             f += 1
-- ...
insert into flats (number, floor_id, sale_status) values (1, 31, "свободно");
insert into flats (number, floor_id, sale_status) values (2, 31, "свободно");
insert into flats (number, floor_id, sale_status) values (3, 31, "свободно");
insert into flats (number, floor_id, sale_status) values (4, 31, "свободно");
insert into flats (number, floor_id, sale_status) values (5, 31, "свободно");
insert into flats (number, floor_id, sale_status) values (6, 31, "свободно");
insert into flats (number, floor_id, sale_status) values (7, 31, "свободно");
insert into flats (number, floor_id, sale_status) values (8, 32, "свободно");
insert into flats (number, floor_id, sale_status) values (9, 32, "свободно");
insert into flats (number, floor_id, sale_status) values (10, 32, "свободно");
insert into flats (number, floor_id, sale_status) values (11, 32, "свободно");
insert into flats (number, floor_id, sale_status) values (12, 32, "свободно");
insert into flats (number, floor_id, sale_status) values (13, 32, "свободно");
insert into flats (number, floor_id, sale_status) values (14, 32, "свободно");
insert into flats (number, floor_id, sale_status) values (15, 33, "свободно");
insert into flats (number, floor_id, sale_status) values (16, 33, "свободно");
insert into flats (number, floor_id, sale_status) values (17, 33, "свободно");
insert into flats (number, floor_id, sale_status) values (18, 33, "свободно");
insert into flats (number, floor_id, sale_status) values (19, 33, "свободно");
insert into flats (number, floor_id, sale_status) values (20, 33, "свободно");
insert into flats (number, floor_id, sale_status) values (21, 33, "свободно");
insert into flats (number, floor_id, sale_status) values (22, 34, "свободно");
insert into flats (number, floor_id, sale_status) values (23, 34, "свободно");
insert into flats (number, floor_id, sale_status) values (24, 34, "свободно");
insert into flats (number, floor_id, sale_status) values (25, 34, "свободно");
insert into flats (number, floor_id, sale_status) values (26, 34, "свободно");
insert into flats (number, floor_id, sale_status) values (27, 34, "свободно");
insert into flats (number, floor_id, sale_status) values (28, 34, "свободно");
insert into flats (number, floor_id, sale_status) values (29, 35, "свободно");
insert into flats (number, floor_id, sale_status) values (30, 35, "свободно");
insert into flats (number, floor_id, sale_status) values (31, 35, "свободно");
insert into flats (number, floor_id, sale_status) values (32, 35, "свободно");
insert into flats (number, floor_id, sale_status) values (33, 35, "свободно");
insert into flats (number, floor_id, sale_status) values (34, 35, "свободно");
insert into flats (number, floor_id, sale_status) values (35, 35, "свободно");
insert into flats (number, floor_id, sale_status) values (36, 36, "свободно");
insert into flats (number, floor_id, sale_status) values (37, 36, "свободно");
insert into flats (number, floor_id, sale_status) values (38, 36, "свободно");
insert into flats (number, floor_id, sale_status) values (39, 36, "свободно");
insert into flats (number, floor_id, sale_status) values (40, 36, "свободно");
insert into flats (number, floor_id, sale_status) values (41, 36, "свободно");
insert into flats (number, floor_id, sale_status) values (42, 36, "свободно");
insert into flats (number, floor_id, sale_status) values (43, 37, "свободно");
insert into flats (number, floor_id, sale_status) values (44, 37, "свободно");
insert into flats (number, floor_id, sale_status) values (45, 37, "свободно");
insert into flats (number, floor_id, sale_status) values (46, 37, "свободно");
insert into flats (number, floor_id, sale_status) values (47, 37, "свободно");
insert into flats (number, floor_id, sale_status) values (48, 37, "свободно");
insert into flats (number, floor_id, sale_status) values (49, 37, "свободно");
insert into flats (number, floor_id, sale_status) values (50, 38, "свободно");
insert into flats (number, floor_id, sale_status) values (51, 38, "свободно");
insert into flats (number, floor_id, sale_status) values (52, 38, "свободно");
insert into flats (number, floor_id, sale_status) values (53, 38, "свободно");
insert into flats (number, floor_id, sale_status) values (54, 38, "свободно");
insert into flats (number, floor_id, sale_status) values (55, 38, "свободно");
insert into flats (number, floor_id, sale_status) values (56, 38, "свободно");
insert into flats (number, floor_id, sale_status) values (57, 39, "свободно");
insert into flats (number, floor_id, sale_status) values (58, 39, "свободно");
insert into flats (number, floor_id, sale_status) values (59, 39, "свободно");
insert into flats (number, floor_id, sale_status) values (60, 39, "свободно");
insert into flats (number, floor_id, sale_status) values (61, 39, "свободно");
insert into flats (number, floor_id, sale_status) values (62, 39, "свободно");
insert into flats (number, floor_id, sale_status) values (63, 39, "свободно");
insert into flats (number, floor_id, sale_status) values (64, 40, "свободно");
insert into flats (number, floor_id, sale_status) values (65, 40, "свободно");
insert into flats (number, floor_id, sale_status) values (66, 40, "свободно");
insert into flats (number, floor_id, sale_status) values (67, 40, "свободно");
insert into flats (number, floor_id, sale_status) values (68, 40, "свободно");
insert into flats (number, floor_id, sale_status) values (69, 40, "свободно");
insert into flats (number, floor_id, sale_status) values (70, 40, "свободно");
insert into flats (number, floor_id, sale_status) values (71, 41, "свободно");
insert into flats (number, floor_id, sale_status) values (72, 41, "свободно");
insert into flats (number, floor_id, sale_status) values (73, 41, "свободно");
insert into flats (number, floor_id, sale_status) values (74, 41, "свободно");
insert into flats (number, floor_id, sale_status) values (75, 41, "свободно");
insert into flats (number, floor_id, sale_status) values (76, 41, "свободно");
insert into flats (number, floor_id, sale_status) values (77, 41, "свободно");
insert into flats (number, floor_id, sale_status) values (78, 42, "свободно");
insert into flats (number, floor_id, sale_status) values (79, 42, "свободно");
insert into flats (number, floor_id, sale_status) values (80, 42, "свободно");
insert into flats (number, floor_id, sale_status) values (81, 42, "свободно");
insert into flats (number, floor_id, sale_status) values (82, 42, "свободно");
insert into flats (number, floor_id, sale_status) values (83, 42, "свободно");
insert into flats (number, floor_id, sale_status) values (84, 42, "свободно");
insert into flats (number, floor_id, sale_status) values (85, 43, "свободно");
insert into flats (number, floor_id, sale_status) values (86, 43, "свободно");
insert into flats (number, floor_id, sale_status) values (87, 43, "свободно");
insert into flats (number, floor_id, sale_status) values (88, 43, "свободно");
insert into flats (number, floor_id, sale_status) values (89, 43, "свободно");
insert into flats (number, floor_id, sale_status) values (90, 43, "свободно");
insert into flats (number, floor_id, sale_status) values (91, 43, "свободно");
insert into flats (number, floor_id, sale_status) values (92, 44, "свободно");
insert into flats (number, floor_id, sale_status) values (93, 44, "свободно");
insert into flats (number, floor_id, sale_status) values (94, 44, "свободно");
insert into flats (number, floor_id, sale_status) values (95, 44, "свободно");
insert into flats (number, floor_id, sale_status) values (96, 44, "свободно");
insert into flats (number, floor_id, sale_status) values (97, 44, "свободно");
insert into flats (number, floor_id, sale_status) values (98, 44, "свободно");
insert into flats (number, floor_id, sale_status) values (99, 45, "свободно");
insert into flats (number, floor_id, sale_status) values (100, 45, "свободно");
insert into flats (number, floor_id, sale_status) values (101, 45, "свободно");
insert into flats (number, floor_id, sale_status) values (102, 45, "свободно");
insert into flats (number, floor_id, sale_status) values (103, 45, "свободно");
insert into flats (number, floor_id, sale_status) values (104, 45, "свободно");
insert into flats (number, floor_id, sale_status) values (105, 45, "свободно");
insert into flats (number, floor_id, sale_status) values (106, 46, "свободно");
insert into flats (number, floor_id, sale_status) values (107, 46, "свободно");
insert into flats (number, floor_id, sale_status) values (108, 46, "свободно");
insert into flats (number, floor_id, sale_status) values (109, 46, "свободно");
insert into flats (number, floor_id, sale_status) values (110, 46, "свободно");
insert into flats (number, floor_id, sale_status) values (111, 46, "свободно");
insert into flats (number, floor_id, sale_status) values (112, 46, "свободно");
insert into flats (number, floor_id, sale_status) values (113, 47, "свободно");
insert into flats (number, floor_id, sale_status) values (114, 47, "свободно");
insert into flats (number, floor_id, sale_status) values (115, 47, "свободно");
insert into flats (number, floor_id, sale_status) values (116, 47, "свободно");
insert into flats (number, floor_id, sale_status) values (117, 47, "свободно");
insert into flats (number, floor_id, sale_status) values (118, 47, "свободно");
insert into flats (number, floor_id, sale_status) values (119, 47, "свободно");
insert into flats (number, floor_id, sale_status) values (120, 48, "свободно");
insert into flats (number, floor_id, sale_status) values (121, 48, "свободно");
insert into flats (number, floor_id, sale_status) values (122, 48, "свободно");
insert into flats (number, floor_id, sale_status) values (123, 48, "свободно");
insert into flats (number, floor_id, sale_status) values (124, 48, "свободно");
insert into flats (number, floor_id, sale_status) values (125, 48, "свободно");
insert into flats (number, floor_id, sale_status) values (126, 48, "свободно");
insert into flats (number, floor_id, sale_status) values (127, 49, "свободно");
insert into flats (number, floor_id, sale_status) values (128, 49, "свободно");
insert into flats (number, floor_id, sale_status) values (129, 49, "свободно");
insert into flats (number, floor_id, sale_status) values (130, 49, "свободно");
insert into flats (number, floor_id, sale_status) values (131, 49, "свободно");
insert into flats (number, floor_id, sale_status) values (132, 49, "свободно");
insert into flats (number, floor_id, sale_status) values (133, 49, "свободно");

-- Планировка квартир
-- >>> for i in range(1, 121, 4):
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {1}, 20.5);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {2}, 18.5);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {5}, 16.5);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {8}, 4.2);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {14}, 5.2);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {15}, 2.2);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {18}, 4.1);')
-- ...
insert into flats_rooms (flat_id, room_id, square) values (1, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (1, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (1, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (1, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (1, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (1, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (1, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (5, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (5, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (5, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (5, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (5, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (5, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (5, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (9, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (9, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (9, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (9, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (9, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (9, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (9, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (13, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (13, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (13, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (13, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (13, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (13, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (13, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (17, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (17, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (17, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (17, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (17, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (17, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (17, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (21, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (21, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (21, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (21, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (21, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (21, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (21, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (25, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (25, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (25, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (25, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (25, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (25, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (25, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (29, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (29, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (29, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (29, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (29, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (29, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (29, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (33, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (33, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (33, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (33, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (33, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (33, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (33, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (37, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (37, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (37, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (37, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (37, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (37, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (37, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (41, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (41, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (41, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (41, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (41, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (41, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (41, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (45, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (45, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (45, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (45, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (45, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (45, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (45, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (49, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (49, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (49, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (49, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (49, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (49, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (49, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (53, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (53, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (53, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (53, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (53, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (53, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (53, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (57, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (57, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (57, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (57, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (57, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (57, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (57, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (61, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (61, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (61, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (61, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (61, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (61, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (61, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (65, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (65, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (65, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (65, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (65, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (65, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (65, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (69, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (69, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (69, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (69, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (69, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (69, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (69, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (73, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (73, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (73, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (73, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (73, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (73, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (73, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (77, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (77, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (77, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (77, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (77, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (77, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (77, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (81, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (81, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (81, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (81, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (81, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (81, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (81, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (85, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (85, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (85, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (85, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (85, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (85, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (85, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (89, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (89, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (89, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (89, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (89, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (89, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (89, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (93, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (93, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (93, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (93, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (93, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (93, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (93, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (97, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (97, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (97, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (97, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (97, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (97, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (97, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (101, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (101, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (101, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (101, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (101, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (101, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (101, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (105, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (105, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (105, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (105, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (105, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (105, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (105, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (109, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (109, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (109, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (109, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (109, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (109, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (109, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (113, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (113, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (113, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (113, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (113, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (113, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (113, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (117, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (117, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (117, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (117, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (117, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (117, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (117, 18, 4.1);

-- >>> for i in range(2, 121, 4):
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {1}, 25.5);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {5}, 18.5);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {8}, 4.2);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {14}, 5.2);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {15}, 2.2);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {18}, 3.1);')
-- ...
insert into flats_rooms (flat_id, room_id, square) values (2, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (2, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (2, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (2, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (2, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (2, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (6, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (6, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (6, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (6, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (6, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (6, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (10, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (10, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (10, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (10, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (10, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (10, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (14, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (14, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (14, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (14, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (14, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (14, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (18, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (18, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (18, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (18, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (18, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (18, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (22, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (22, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (22, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (22, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (22, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (22, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (26, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (26, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (26, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (26, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (26, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (26, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (30, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (30, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (30, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (30, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (30, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (30, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (34, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (34, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (34, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (34, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (34, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (34, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (38, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (38, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (38, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (38, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (38, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (38, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (42, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (42, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (42, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (42, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (42, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (42, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (46, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (46, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (46, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (46, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (46, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (46, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (50, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (50, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (50, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (50, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (50, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (50, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (54, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (54, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (54, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (54, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (54, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (54, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (58, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (58, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (58, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (58, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (58, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (58, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (62, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (62, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (62, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (62, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (62, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (62, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (66, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (66, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (66, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (66, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (66, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (66, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (70, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (70, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (70, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (70, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (70, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (70, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (74, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (74, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (74, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (74, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (74, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (74, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (78, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (78, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (78, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (78, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (78, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (78, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (82, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (82, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (82, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (82, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (82, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (82, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (86, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (86, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (86, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (86, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (86, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (86, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (90, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (90, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (90, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (90, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (90, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (90, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (94, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (94, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (94, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (94, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (94, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (94, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (98, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (98, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (98, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (98, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (98, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (98, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (102, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (102, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (102, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (102, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (102, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (102, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (106, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (106, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (106, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (106, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (106, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (106, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (110, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (110, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (110, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (110, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (110, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (110, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (114, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (114, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (114, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (114, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (114, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (114, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (118, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (118, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (118, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (118, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (118, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (118, 18, 3.1);

-- >>> for i in range(3, 121, 4):
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {1}, 25.5);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {5}, 18.5);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {8}, 4.2);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {14}, 5.2);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {15}, 2.2);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {18}, 3.1);')
-- ...
insert into flats_rooms (flat_id, room_id, square) values (3, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (3, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (3, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (3, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (3, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (3, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (7, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (7, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (7, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (7, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (7, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (7, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (11, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (11, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (11, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (11, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (11, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (11, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (15, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (15, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (15, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (15, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (15, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (15, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (19, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (19, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (19, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (19, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (19, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (19, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (23, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (23, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (23, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (23, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (23, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (23, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (27, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (27, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (27, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (27, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (27, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (27, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (31, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (31, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (31, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (31, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (31, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (31, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (35, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (35, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (35, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (35, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (35, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (35, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (39, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (39, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (39, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (39, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (39, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (39, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (43, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (43, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (43, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (43, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (43, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (43, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (47, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (47, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (47, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (47, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (47, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (47, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (51, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (51, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (51, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (51, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (51, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (51, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (55, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (55, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (55, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (55, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (55, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (55, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (59, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (59, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (59, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (59, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (59, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (59, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (63, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (63, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (63, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (63, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (63, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (63, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (67, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (67, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (67, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (67, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (67, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (67, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (71, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (71, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (71, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (71, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (71, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (71, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (75, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (75, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (75, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (75, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (75, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (75, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (79, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (79, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (79, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (79, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (79, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (79, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (83, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (83, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (83, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (83, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (83, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (83, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (87, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (87, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (87, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (87, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (87, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (87, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (91, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (91, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (91, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (91, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (91, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (91, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (95, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (95, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (95, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (95, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (95, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (95, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (99, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (99, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (99, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (99, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (99, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (99, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (103, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (103, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (103, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (103, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (103, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (103, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (107, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (107, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (107, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (107, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (107, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (107, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (111, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (111, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (111, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (111, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (111, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (111, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (115, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (115, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (115, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (115, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (115, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (115, 18, 3.1);
insert into flats_rooms (flat_id, room_id, square) values (119, 1, 25.5);
insert into flats_rooms (flat_id, room_id, square) values (119, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (119, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (119, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (119, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (119, 18, 3.1);

-- >>> for i in range(4, 121, 4):
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {1}, 20.5);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {2}, 18.5);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {5}, 16.5);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {8}, 4.2);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {14}, 5.2);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {15}, 2.2);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {18}, 4.1);')
-- ...
insert into flats_rooms (flat_id, room_id, square) values (4, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (4, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (4, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (4, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (4, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (4, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (4, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (8, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (8, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (8, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (8, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (8, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (8, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (8, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (12, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (12, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (12, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (12, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (12, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (12, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (12, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (16, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (16, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (16, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (16, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (16, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (16, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (16, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (20, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (20, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (20, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (20, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (20, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (20, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (20, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (24, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (24, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (24, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (24, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (24, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (24, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (24, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (28, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (28, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (28, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (28, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (28, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (28, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (28, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (32, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (32, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (32, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (32, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (32, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (32, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (32, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (36, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (36, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (36, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (36, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (36, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (36, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (36, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (40, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (40, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (40, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (40, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (40, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (40, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (40, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (44, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (44, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (44, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (44, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (44, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (44, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (44, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (48, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (48, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (48, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (48, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (48, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (48, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (48, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (52, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (52, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (52, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (52, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (52, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (52, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (52, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (56, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (56, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (56, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (56, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (56, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (56, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (56, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (60, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (60, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (60, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (60, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (60, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (60, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (60, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (64, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (64, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (64, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (64, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (64, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (64, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (64, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (68, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (68, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (68, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (68, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (68, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (68, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (68, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (72, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (72, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (72, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (72, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (72, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (72, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (72, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (76, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (76, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (76, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (76, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (76, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (76, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (76, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (80, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (80, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (80, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (80, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (80, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (80, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (80, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (84, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (84, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (84, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (84, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (84, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (84, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (84, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (88, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (88, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (88, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (88, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (88, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (88, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (88, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (92, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (92, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (92, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (92, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (92, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (92, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (92, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (96, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (96, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (96, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (96, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (96, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (96, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (96, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (100, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (100, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (100, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (100, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (100, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (100, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (100, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (104, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (104, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (104, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (104, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (104, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (104, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (104, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (108, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (108, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (108, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (108, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (108, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (108, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (108, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (112, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (112, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (112, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (112, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (112, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (112, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (112, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (116, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (116, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (116, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (116, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (116, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (116, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (116, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (120, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (120, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (120, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (120, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (120, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (120, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (120, 18, 4.1);

-- >>> for i in range(121, 254, 7):
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {1}, 20.5);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {2}, 18.5);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {5}, 16.5);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {8}, 4.2);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {14}, 5.2);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {15}, 2.2);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {18}, 4.1);')
-- ...
insert into flats_rooms (flat_id, room_id, square) values (121, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (121, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (121, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (121, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (121, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (121, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (121, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (128, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (128, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (128, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (128, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (128, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (128, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (128, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (135, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (135, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (135, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (135, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (135, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (135, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (135, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (142, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (142, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (142, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (142, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (142, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (142, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (142, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (149, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (149, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (149, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (149, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (149, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (149, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (149, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (156, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (156, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (156, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (156, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (156, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (156, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (156, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (163, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (163, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (163, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (163, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (163, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (163, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (163, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (170, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (170, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (170, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (170, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (170, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (170, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (170, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (177, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (177, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (177, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (177, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (177, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (177, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (177, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (184, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (184, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (184, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (184, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (184, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (184, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (184, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (191, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (191, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (191, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (191, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (191, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (191, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (191, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (198, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (198, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (198, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (198, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (198, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (198, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (198, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (205, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (205, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (205, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (205, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (205, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (205, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (205, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (212, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (212, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (212, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (212, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (212, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (212, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (212, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (219, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (219, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (219, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (219, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (219, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (219, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (219, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (226, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (226, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (226, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (226, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (226, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (226, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (226, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (233, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (233, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (233, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (233, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (233, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (233, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (233, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (240, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (240, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (240, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (240, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (240, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (240, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (240, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (247, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (247, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (247, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (247, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (247, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (247, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (247, 18, 4.1);

-- >>> for i in range(122, 254, 7):
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {1}, 21.5);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {2}, 20.5);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {3}, 20.5);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {5}, 18.5);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {8}, 4.2);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {14}, 5.2);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {15}, 2.2);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {18}, 4.1);')
-- ...
insert into flats_rooms (flat_id, room_id, square) values (122, 1, 21.5);
insert into flats_rooms (flat_id, room_id, square) values (122, 2, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (122, 3, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (122, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (122, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (122, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (122, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (122, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (129, 1, 21.5);
insert into flats_rooms (flat_id, room_id, square) values (129, 2, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (129, 3, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (129, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (129, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (129, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (129, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (129, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (136, 1, 21.5);
insert into flats_rooms (flat_id, room_id, square) values (136, 2, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (136, 3, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (136, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (136, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (136, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (136, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (136, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (143, 1, 21.5);
insert into flats_rooms (flat_id, room_id, square) values (143, 2, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (143, 3, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (143, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (143, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (143, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (143, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (143, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (150, 1, 21.5);
insert into flats_rooms (flat_id, room_id, square) values (150, 2, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (150, 3, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (150, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (150, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (150, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (150, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (150, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (157, 1, 21.5);
insert into flats_rooms (flat_id, room_id, square) values (157, 2, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (157, 3, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (157, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (157, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (157, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (157, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (157, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (164, 1, 21.5);
insert into flats_rooms (flat_id, room_id, square) values (164, 2, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (164, 3, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (164, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (164, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (164, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (164, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (164, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (171, 1, 21.5);
insert into flats_rooms (flat_id, room_id, square) values (171, 2, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (171, 3, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (171, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (171, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (171, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (171, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (171, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (178, 1, 21.5);
insert into flats_rooms (flat_id, room_id, square) values (178, 2, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (178, 3, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (178, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (178, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (178, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (178, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (178, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (185, 1, 21.5);
insert into flats_rooms (flat_id, room_id, square) values (185, 2, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (185, 3, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (185, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (185, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (185, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (185, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (185, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (192, 1, 21.5);
insert into flats_rooms (flat_id, room_id, square) values (192, 2, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (192, 3, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (192, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (192, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (192, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (192, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (192, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (199, 1, 21.5);
insert into flats_rooms (flat_id, room_id, square) values (199, 2, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (199, 3, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (199, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (199, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (199, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (199, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (199, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (206, 1, 21.5);
insert into flats_rooms (flat_id, room_id, square) values (206, 2, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (206, 3, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (206, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (206, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (206, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (206, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (206, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (213, 1, 21.5);
insert into flats_rooms (flat_id, room_id, square) values (213, 2, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (213, 3, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (213, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (213, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (213, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (213, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (213, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (220, 1, 21.5);
insert into flats_rooms (flat_id, room_id, square) values (220, 2, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (220, 3, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (220, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (220, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (220, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (220, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (220, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (227, 1, 21.5);
insert into flats_rooms (flat_id, room_id, square) values (227, 2, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (227, 3, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (227, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (227, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (227, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (227, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (227, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (234, 1, 21.5);
insert into flats_rooms (flat_id, room_id, square) values (234, 2, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (234, 3, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (234, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (234, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (234, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (234, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (234, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (241, 1, 21.5);
insert into flats_rooms (flat_id, room_id, square) values (241, 2, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (241, 3, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (241, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (241, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (241, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (241, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (241, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (248, 1, 21.5);
insert into flats_rooms (flat_id, room_id, square) values (248, 2, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (248, 3, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (248, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (248, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (248, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (248, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (248, 18, 4.1);

-- >>> for i in range(123, 254, 7):
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {1}, 21.5);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {2}, 20.5);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {5}, 18.5);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {8}, 4.2);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {14}, 5.2);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {15}, 2.2);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {18}, 4.1);')
-- ...
insert into flats_rooms (flat_id, room_id, square) values (123, 1, 21.5);
insert into flats_rooms (flat_id, room_id, square) values (123, 2, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (123, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (123, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (123, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (123, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (123, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (130, 1, 21.5);
insert into flats_rooms (flat_id, room_id, square) values (130, 2, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (130, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (130, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (130, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (130, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (130, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (137, 1, 21.5);
insert into flats_rooms (flat_id, room_id, square) values (137, 2, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (137, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (137, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (137, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (137, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (137, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (144, 1, 21.5);
insert into flats_rooms (flat_id, room_id, square) values (144, 2, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (144, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (144, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (144, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (144, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (144, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (151, 1, 21.5);
insert into flats_rooms (flat_id, room_id, square) values (151, 2, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (151, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (151, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (151, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (151, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (151, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (158, 1, 21.5);
insert into flats_rooms (flat_id, room_id, square) values (158, 2, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (158, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (158, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (158, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (158, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (158, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (165, 1, 21.5);
insert into flats_rooms (flat_id, room_id, square) values (165, 2, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (165, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (165, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (165, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (165, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (165, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (172, 1, 21.5);
insert into flats_rooms (flat_id, room_id, square) values (172, 2, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (172, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (172, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (172, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (172, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (172, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (179, 1, 21.5);
insert into flats_rooms (flat_id, room_id, square) values (179, 2, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (179, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (179, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (179, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (179, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (179, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (186, 1, 21.5);
insert into flats_rooms (flat_id, room_id, square) values (186, 2, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (186, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (186, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (186, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (186, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (186, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (193, 1, 21.5);
insert into flats_rooms (flat_id, room_id, square) values (193, 2, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (193, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (193, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (193, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (193, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (193, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (200, 1, 21.5);
insert into flats_rooms (flat_id, room_id, square) values (200, 2, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (200, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (200, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (200, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (200, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (200, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (207, 1, 21.5);
insert into flats_rooms (flat_id, room_id, square) values (207, 2, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (207, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (207, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (207, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (207, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (207, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (214, 1, 21.5);
insert into flats_rooms (flat_id, room_id, square) values (214, 2, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (214, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (214, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (214, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (214, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (214, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (221, 1, 21.5);
insert into flats_rooms (flat_id, room_id, square) values (221, 2, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (221, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (221, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (221, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (221, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (221, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (228, 1, 21.5);
insert into flats_rooms (flat_id, room_id, square) values (228, 2, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (228, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (228, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (228, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (228, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (228, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (235, 1, 21.5);
insert into flats_rooms (flat_id, room_id, square) values (235, 2, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (235, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (235, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (235, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (235, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (235, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (242, 1, 21.5);
insert into flats_rooms (flat_id, room_id, square) values (242, 2, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (242, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (242, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (242, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (242, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (242, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (249, 1, 21.5);
insert into flats_rooms (flat_id, room_id, square) values (249, 2, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (249, 5, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (249, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (249, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (249, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (249, 18, 4.1);

-- >>> for i in range(124, 254, 7):
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {1}, 20.5);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {2}, 18.5);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {5}, 16.5);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {8}, 4.2);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {14}, 5.2);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {15}, 2.2);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {18}, 4.1);')
-- ...
insert into flats_rooms (flat_id, room_id, square) values (124, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (124, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (124, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (124, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (124, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (124, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (124, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (131, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (131, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (131, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (131, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (131, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (131, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (131, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (138, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (138, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (138, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (138, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (138, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (138, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (138, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (145, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (145, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (145, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (145, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (145, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (145, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (145, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (152, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (152, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (152, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (152, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (152, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (152, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (152, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (159, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (159, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (159, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (159, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (159, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (159, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (159, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (166, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (166, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (166, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (166, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (166, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (166, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (166, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (173, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (173, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (173, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (173, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (173, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (173, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (173, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (180, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (180, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (180, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (180, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (180, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (180, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (180, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (187, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (187, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (187, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (187, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (187, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (187, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (187, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (194, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (194, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (194, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (194, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (194, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (194, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (194, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (201, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (201, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (201, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (201, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (201, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (201, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (201, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (208, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (208, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (208, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (208, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (208, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (208, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (208, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (215, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (215, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (215, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (215, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (215, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (215, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (215, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (222, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (222, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (222, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (222, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (222, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (222, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (222, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (229, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (229, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (229, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (229, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (229, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (229, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (229, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (236, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (236, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (236, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (236, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (236, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (236, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (236, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (243, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (243, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (243, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (243, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (243, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (243, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (243, 18, 4.1);
insert into flats_rooms (flat_id, room_id, square) values (250, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (250, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (250, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (250, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (250, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (250, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (250, 18, 4.1);

-- >>> for i in range(125, 254, 7):
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {1}, 20.5);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {1}, 10.5);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {2}, 18.5);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {5}, 16.5);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {8}, 4.2);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {14}, 5.2);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {15}, 2.2);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {18}, 5.1);')
-- ...
insert into flats_rooms (flat_id, room_id, square) values (125, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (125, 1, 10.5);
insert into flats_rooms (flat_id, room_id, square) values (125, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (125, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (125, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (125, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (125, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (125, 18, 5.1);
insert into flats_rooms (flat_id, room_id, square) values (132, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (132, 1, 10.5);
insert into flats_rooms (flat_id, room_id, square) values (132, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (132, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (132, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (132, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (132, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (132, 18, 5.1);
insert into flats_rooms (flat_id, room_id, square) values (139, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (139, 1, 10.5);
insert into flats_rooms (flat_id, room_id, square) values (139, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (139, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (139, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (139, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (139, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (139, 18, 5.1);
insert into flats_rooms (flat_id, room_id, square) values (146, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (146, 1, 10.5);
insert into flats_rooms (flat_id, room_id, square) values (146, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (146, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (146, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (146, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (146, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (146, 18, 5.1);
insert into flats_rooms (flat_id, room_id, square) values (153, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (153, 1, 10.5);
insert into flats_rooms (flat_id, room_id, square) values (153, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (153, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (153, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (153, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (153, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (153, 18, 5.1);
insert into flats_rooms (flat_id, room_id, square) values (160, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (160, 1, 10.5);
insert into flats_rooms (flat_id, room_id, square) values (160, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (160, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (160, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (160, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (160, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (160, 18, 5.1);
insert into flats_rooms (flat_id, room_id, square) values (167, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (167, 1, 10.5);
insert into flats_rooms (flat_id, room_id, square) values (167, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (167, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (167, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (167, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (167, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (167, 18, 5.1);
insert into flats_rooms (flat_id, room_id, square) values (174, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (174, 1, 10.5);
insert into flats_rooms (flat_id, room_id, square) values (174, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (174, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (174, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (174, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (174, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (174, 18, 5.1);
insert into flats_rooms (flat_id, room_id, square) values (181, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (181, 1, 10.5);
insert into flats_rooms (flat_id, room_id, square) values (181, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (181, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (181, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (181, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (181, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (181, 18, 5.1);
insert into flats_rooms (flat_id, room_id, square) values (188, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (188, 1, 10.5);
insert into flats_rooms (flat_id, room_id, square) values (188, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (188, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (188, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (188, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (188, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (188, 18, 5.1);
insert into flats_rooms (flat_id, room_id, square) values (195, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (195, 1, 10.5);
insert into flats_rooms (flat_id, room_id, square) values (195, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (195, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (195, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (195, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (195, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (195, 18, 5.1);
insert into flats_rooms (flat_id, room_id, square) values (202, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (202, 1, 10.5);
insert into flats_rooms (flat_id, room_id, square) values (202, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (202, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (202, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (202, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (202, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (202, 18, 5.1);
insert into flats_rooms (flat_id, room_id, square) values (209, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (209, 1, 10.5);
insert into flats_rooms (flat_id, room_id, square) values (209, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (209, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (209, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (209, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (209, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (209, 18, 5.1);
insert into flats_rooms (flat_id, room_id, square) values (216, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (216, 1, 10.5);
insert into flats_rooms (flat_id, room_id, square) values (216, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (216, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (216, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (216, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (216, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (216, 18, 5.1);
insert into flats_rooms (flat_id, room_id, square) values (223, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (223, 1, 10.5);
insert into flats_rooms (flat_id, room_id, square) values (223, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (223, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (223, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (223, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (223, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (223, 18, 5.1);
insert into flats_rooms (flat_id, room_id, square) values (230, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (230, 1, 10.5);
insert into flats_rooms (flat_id, room_id, square) values (230, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (230, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (230, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (230, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (230, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (230, 18, 5.1);
insert into flats_rooms (flat_id, room_id, square) values (237, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (237, 1, 10.5);
insert into flats_rooms (flat_id, room_id, square) values (237, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (237, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (237, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (237, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (237, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (237, 18, 5.1);
insert into flats_rooms (flat_id, room_id, square) values (244, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (244, 1, 10.5);
insert into flats_rooms (flat_id, room_id, square) values (244, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (244, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (244, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (244, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (244, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (244, 18, 5.1);
insert into flats_rooms (flat_id, room_id, square) values (251, 1, 20.5);
insert into flats_rooms (flat_id, room_id, square) values (251, 1, 10.5);
insert into flats_rooms (flat_id, room_id, square) values (251, 2, 18.5);
insert into flats_rooms (flat_id, room_id, square) values (251, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (251, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (251, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (251, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (251, 18, 5.1);

-- >>> for i in range(126, 254, 7):
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {1}, 19.5);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {5}, 16.5);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {8}, 4.2);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {14}, 5.2);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {15}, 2.2);')
-- ...
insert into flats_rooms (flat_id, room_id, square) values (126, 1, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (126, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (126, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (126, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (126, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (133, 1, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (133, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (133, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (133, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (133, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (140, 1, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (140, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (140, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (140, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (140, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (147, 1, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (147, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (147, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (147, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (147, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (154, 1, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (154, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (154, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (154, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (154, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (161, 1, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (161, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (161, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (161, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (161, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (168, 1, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (168, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (168, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (168, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (168, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (175, 1, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (175, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (175, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (175, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (175, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (182, 1, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (182, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (182, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (182, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (182, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (189, 1, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (189, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (189, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (189, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (189, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (196, 1, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (196, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (196, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (196, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (196, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (203, 1, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (203, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (203, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (203, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (203, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (210, 1, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (210, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (210, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (210, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (210, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (217, 1, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (217, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (217, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (217, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (217, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (224, 1, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (224, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (224, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (224, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (224, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (231, 1, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (231, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (231, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (231, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (231, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (238, 1, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (238, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (238, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (238, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (238, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (245, 1, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (245, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (245, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (245, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (245, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (252, 1, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (252, 5, 16.5);
insert into flats_rooms (flat_id, room_id, square) values (252, 8, 4.2);
insert into flats_rooms (flat_id, room_id, square) values (252, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (252, 15, 2.2);

-- >>> for i in range(127, 254, 7):
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {1}, 19.5);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {2}, 19.5);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {5}, 17.5);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {8}, 6.2);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {14}, 5.2);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {15}, 2.2);')
-- ...     print(f'insert into flats_rooms (flat_id, room_id, square) values ({i}, {18}, 5.1);')
-- ...
insert into flats_rooms (flat_id, room_id, square) values (127, 1, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (127, 2, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (127, 5, 17.5);
insert into flats_rooms (flat_id, room_id, square) values (127, 8, 6.2);
insert into flats_rooms (flat_id, room_id, square) values (127, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (127, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (127, 18, 5.1);
insert into flats_rooms (flat_id, room_id, square) values (134, 1, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (134, 2, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (134, 5, 17.5);
insert into flats_rooms (flat_id, room_id, square) values (134, 8, 6.2);
insert into flats_rooms (flat_id, room_id, square) values (134, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (134, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (134, 18, 5.1);
insert into flats_rooms (flat_id, room_id, square) values (141, 1, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (141, 2, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (141, 5, 17.5);
insert into flats_rooms (flat_id, room_id, square) values (141, 8, 6.2);
insert into flats_rooms (flat_id, room_id, square) values (141, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (141, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (141, 18, 5.1);
insert into flats_rooms (flat_id, room_id, square) values (148, 1, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (148, 2, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (148, 5, 17.5);
insert into flats_rooms (flat_id, room_id, square) values (148, 8, 6.2);
insert into flats_rooms (flat_id, room_id, square) values (148, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (148, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (148, 18, 5.1);
insert into flats_rooms (flat_id, room_id, square) values (155, 1, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (155, 2, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (155, 5, 17.5);
insert into flats_rooms (flat_id, room_id, square) values (155, 8, 6.2);
insert into flats_rooms (flat_id, room_id, square) values (155, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (155, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (155, 18, 5.1);
insert into flats_rooms (flat_id, room_id, square) values (162, 1, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (162, 2, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (162, 5, 17.5);
insert into flats_rooms (flat_id, room_id, square) values (162, 8, 6.2);
insert into flats_rooms (flat_id, room_id, square) values (162, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (162, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (162, 18, 5.1);
insert into flats_rooms (flat_id, room_id, square) values (169, 1, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (169, 2, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (169, 5, 17.5);
insert into flats_rooms (flat_id, room_id, square) values (169, 8, 6.2);
insert into flats_rooms (flat_id, room_id, square) values (169, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (169, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (169, 18, 5.1);
insert into flats_rooms (flat_id, room_id, square) values (176, 1, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (176, 2, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (176, 5, 17.5);
insert into flats_rooms (flat_id, room_id, square) values (176, 8, 6.2);
insert into flats_rooms (flat_id, room_id, square) values (176, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (176, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (176, 18, 5.1);
insert into flats_rooms (flat_id, room_id, square) values (183, 1, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (183, 2, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (183, 5, 17.5);
insert into flats_rooms (flat_id, room_id, square) values (183, 8, 6.2);
insert into flats_rooms (flat_id, room_id, square) values (183, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (183, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (183, 18, 5.1);
insert into flats_rooms (flat_id, room_id, square) values (190, 1, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (190, 2, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (190, 5, 17.5);
insert into flats_rooms (flat_id, room_id, square) values (190, 8, 6.2);
insert into flats_rooms (flat_id, room_id, square) values (190, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (190, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (190, 18, 5.1);
insert into flats_rooms (flat_id, room_id, square) values (197, 1, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (197, 2, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (197, 5, 17.5);
insert into flats_rooms (flat_id, room_id, square) values (197, 8, 6.2);
insert into flats_rooms (flat_id, room_id, square) values (197, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (197, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (197, 18, 5.1);
insert into flats_rooms (flat_id, room_id, square) values (204, 1, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (204, 2, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (204, 5, 17.5);
insert into flats_rooms (flat_id, room_id, square) values (204, 8, 6.2);
insert into flats_rooms (flat_id, room_id, square) values (204, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (204, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (204, 18, 5.1);
insert into flats_rooms (flat_id, room_id, square) values (211, 1, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (211, 2, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (211, 5, 17.5);
insert into flats_rooms (flat_id, room_id, square) values (211, 8, 6.2);
insert into flats_rooms (flat_id, room_id, square) values (211, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (211, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (211, 18, 5.1);
insert into flats_rooms (flat_id, room_id, square) values (218, 1, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (218, 2, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (218, 5, 17.5);
insert into flats_rooms (flat_id, room_id, square) values (218, 8, 6.2);
insert into flats_rooms (flat_id, room_id, square) values (218, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (218, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (218, 18, 5.1);
insert into flats_rooms (flat_id, room_id, square) values (225, 1, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (225, 2, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (225, 5, 17.5);
insert into flats_rooms (flat_id, room_id, square) values (225, 8, 6.2);
insert into flats_rooms (flat_id, room_id, square) values (225, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (225, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (225, 18, 5.1);
insert into flats_rooms (flat_id, room_id, square) values (232, 1, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (232, 2, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (232, 5, 17.5);
insert into flats_rooms (flat_id, room_id, square) values (232, 8, 6.2);
insert into flats_rooms (flat_id, room_id, square) values (232, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (232, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (232, 18, 5.1);
insert into flats_rooms (flat_id, room_id, square) values (239, 1, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (239, 2, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (239, 5, 17.5);
insert into flats_rooms (flat_id, room_id, square) values (239, 8, 6.2);
insert into flats_rooms (flat_id, room_id, square) values (239, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (239, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (239, 18, 5.1);
insert into flats_rooms (flat_id, room_id, square) values (246, 1, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (246, 2, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (246, 5, 17.5);
insert into flats_rooms (flat_id, room_id, square) values (246, 8, 6.2);
insert into flats_rooms (flat_id, room_id, square) values (246, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (246, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (246, 18, 5.1);
insert into flats_rooms (flat_id, room_id, square) values (253, 1, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (253, 2, 19.5);
insert into flats_rooms (flat_id, room_id, square) values (253, 5, 17.5);
insert into flats_rooms (flat_id, room_id, square) values (253, 8, 6.2);
insert into flats_rooms (flat_id, room_id, square) values (253, 14, 5.2);
insert into flats_rooms (flat_id, room_id, square) values (253, 15, 2.2);
insert into flats_rooms (flat_id, room_id, square) values (253, 18, 5.1);


-- select *
--     from flats_rooms 
--     join rooms on flats_rooms.room_id = rooms.id 
--     join flats on flats_rooms.flat_id = flats.id
--     join floors on flats.floor_id = floors.id
--     join sections on floors.section_id = sections.id
--     join sections_types on sections.type_id = sections_types.id
--     join houses on sections.house_id = houses.id
--     join building_permits on houses.building_permit_id = building_permits.id
--     join quaters on houses.quater_id = quaters.id
    
--     order by quaters.name
--     limit 10;

-- select
--         flats.id as id,
--         flats.number as Flat,
--         flats.sale_status as Status,
--         quaters.name as Quater,
--         houses.number as House,
--         building_permits.number as Permit,
--         building_permits.dt_issue as Start,
--         building_permits.dt_expiry as End,
--         houses.seismic as Seismic,
--         houses.energy_save as Energy,
--         sections.number as Section,
--         sections_types.id as Type,
--         floors.number as Floor,
--         rooms.name_room as Room,
--         rooms.living as Living,
--         rooms.koef_price as Koef,
--         flats_rooms.square as Square
--     from flats_rooms 
--     join rooms on flats_rooms.room_id = rooms.id 
--     join flats on flats_rooms.flat_id = flats.id
--     join floors on flats.floor_id = floors.id
--     join sections on floors.section_id = sections.id
--     join sections_types on sections.type_id = sections_types.id
--     join houses on sections.house_id = houses.id
--     join building_permits on houses.building_permit_id = building_permits.id
--     join quaters on houses.quater_id = quaters.id;


-- Персоны
insert into persons (last_name, first_name, patr_name, sex, birthday) values ('иванов', 'иван', 'иванович', 1, '1990-07-01');
insert into persons (last_name, first_name, patr_name, sex, birthday) values ('петров', 'пётр', 'петрович', 1, '1980-03-31');
insert into persons (last_name, first_name, patr_name, sex, birthday) values ('кузнецов', 'олег', 'иванович', 1, '1970-12-16');
insert into persons (last_name, first_name, patr_name, sex, birthday) values ('рябинина', 'татьяна', 'викторовна', 0, '1985-07-02');
insert into persons (last_name, first_name, patr_name, sex, birthday) values ('дмитриева', 'сюзанна', 'владимировна', 0, '1990-11-30');
insert into persons (last_name, first_name, patr_name, sex, birthday) values ('бергер', 'инна', 'васильевна', 0, '1988-03-08');
insert into persons (last_name, first_name, patr_name, sex, birthday) values ('глазунов', 'виктор', 'валерьевич', 1, '1979-02-15');
-- select * from persons;
-- +----+-----------+------------+--------------+------------+-----+
-- | id | last_name | first_name | patr_name    | birthday   | sex |
-- +----+-----------+------------+--------------+------------+-----+
-- |  1 | иванов    | иван       | иванович     | 1990-07-01 |   1 |
-- |  2 | петров    | пётр       | петрович     | 1980-03-31 |   1 |
-- |  3 | кузнецов  | олег       | иванович     | 1970-12-16 |   1 |
-- |  4 | рябинина  | татьяна    | викторовна   | 1985-07-02 |   0 |
-- |  5 | дмитриева | сюзанна    | владимировна | 1990-11-30 |   0 |
-- |  6 | бергер    | инна       | васильевна   | 1988-03-08 |   0 |
-- +----+-----------+------------+--------------+------------+-----+

-- Страна
insert into countries (full_name, short_name, int_code) values ('российская федерация', 'россия', 'rus');
-- select * from countries;
-- +----+----------------------+------------+----------+
-- | id | full_name            | short_name | int_code |
-- +----+----------------------+------------+----------+
-- |  1 | российская федерация | россия     | rus      |
-- +----+----------------------+------------+----------+


-- Локации
-- >>> arr = ['республика', 'край', 'автономный округ', 'автономная область', 'область', 'район', 'округ', 'город', 'село', 'поселение', 'посёлок', 'деревня']
-- >>> for item in arr:
-- ...     print(f'insert into locality_types (id) values ("{item}");')
-- ...
insert into locality_types (id) values ('республика');
insert into locality_types (id) values ('край');
insert into locality_types (id) values ('автономная область');
insert into locality_types (id) values ('автономный округ');
insert into locality_types (id) values ('область');
insert into locality_types (id) values ('район');
insert into locality_types (id) values ('округ');
insert into locality_types (id) values ('город');
insert into locality_types (id) values ('село');
insert into locality_types (id) values ('поселение');
insert into locality_types (id) values ('посёлок');
insert into locality_types (id) values ('деревня');


insert into regions (first_name, locality_type_id, country_id) values ('адыгея', 'pеспублика', 1);
insert into regions (first_name, locality_type_id, country_id) values ('алтай', 'pеспублика', 1);
insert into regions (first_name, locality_type_id, country_id) values ('алтайский', 'край', 1);
insert into regions (first_name, locality_type_id, country_id) values ('амурская', 'область', 1);
insert into regions (first_name, locality_type_id, country_id) values ('архангельская', 'область', 1);
insert into regions (first_name, locality_type_id, country_id) values ('астраханская', 'область', 1);
insert into regions (first_name, locality_type_id, country_id) values ('башкортостан', 'pеспублика', 1);
insert into regions (first_name, locality_type_id, country_id) values ('белгородская', 'область', 1);
insert into regions (first_name, locality_type_id, country_id) values ('брянская', 'область', 1);
insert into regions (first_name, locality_type_id, country_id) values ('бурятия', 'pеспублика', 1);
insert into regions (first_name, locality_type_id, country_id) values ('владимирская', 'область', 1);
insert into regions (first_name, locality_type_id, country_id) values ('волгоградская', 'область', 1);
insert into regions (first_name, locality_type_id, country_id) values ('вологодская', 'область', 1);
insert into regions (first_name, locality_type_id, country_id) values ('воронежская', 'область', 1);
insert into regions (first_name, locality_type_id, country_id) values ('дагестан', 'pеспублика', 1);
insert into regions (first_name, locality_type_id, country_id) values ('еврейская', 'автономная область', 1);
insert into regions (first_name, locality_type_id, country_id) values ('забайкальский', 'край', 1);
insert into regions (first_name, locality_type_id, country_id) values ('ивановская', 'область', 1);
insert into regions (first_name, locality_type_id, country_id) values ('ингушетия', 'pеспублика', 1);
insert into regions (first_name, locality_type_id, country_id) values ('иркутская', 'область', 1);
insert into regions (first_name, locality_type_id, country_id) values ('кабардино-балкарская', 'pеспублика', 1);
insert into regions (first_name, locality_type_id, country_id) values ('калининградская', 'область', 1);
insert into regions (first_name, locality_type_id, country_id) values ('калмыкия', 'pеспублика', 1);
insert into regions (first_name, locality_type_id, country_id) values ('калужская', 'область', 1);
insert into regions (first_name, locality_type_id, country_id) values ('камчатский', 'край', 1);
insert into regions (first_name, locality_type_id, country_id) values ('карачаево-черкесская', 'pеспублика', 1);
insert into regions (first_name, locality_type_id, country_id) values ('карелия', 'pеспублика', 1);
insert into regions (first_name, locality_type_id, country_id) values ('кемеровская', 'область', 1);
insert into regions (first_name, locality_type_id, country_id) values ('кировская', 'область', 1);
insert into regions (first_name, locality_type_id, country_id) values ('коми', 'pеспублика', 1);
insert into regions (first_name, locality_type_id, country_id) values ('костромская', 'область', 1);
insert into regions (first_name, locality_type_id, country_id) values ('краснодарский', 'край', 1);
insert into regions (first_name, locality_type_id, country_id) values ('красноярский', 'край', 1);
insert into regions (first_name, locality_type_id, country_id) values ('крым', 'pеспублика', 1);
insert into regions (first_name, locality_type_id, country_id) values ('курганская', 'область', 1);
insert into regions (first_name, locality_type_id, country_id) values ('курская', 'область', 1);
insert into regions (first_name, locality_type_id, country_id) values ('ленинградская', 'область', 1);
insert into regions (first_name, locality_type_id, country_id) values ('липецкая', 'область', 1);
insert into regions (first_name, locality_type_id, country_id) values ('магаданская', 'область', 1);
insert into regions (first_name, locality_type_id, country_id) values ('марий эл', 'pеспублика', 1);
insert into regions (first_name, locality_type_id, country_id) values ('мордовия', 'pеспублика', 1);
insert into regions (first_name, locality_type_id, country_id) values ('москва', 'город', 1);
insert into regions (first_name, locality_type_id, country_id) values ('московская', 'область', 1);
insert into regions (first_name, locality_type_id, country_id) values ('мурманская', 'область', 1);
insert into regions (first_name, locality_type_id, country_id) values ('ненецкий', 'автономный округ', 1);
insert into regions (first_name, locality_type_id, country_id) values ('нижегородская', 'область', 1);
insert into regions (first_name, locality_type_id, country_id) values ('новгородская', 'область', 1);
insert into regions (first_name, locality_type_id, country_id) values ('новосибирская', 'область', 1);
insert into regions (first_name, locality_type_id, country_id) values ('омская', 'область', 1);
insert into regions (first_name, locality_type_id, country_id) values ('оренбургская', 'область', 1);
insert into regions (first_name, locality_type_id, country_id) values ('орловская', 'область', 1);
insert into regions (first_name, locality_type_id, country_id) values ('пензенская', 'область', 1);
insert into regions (first_name, locality_type_id, country_id) values ('пермский', 'край', 1);
insert into regions (first_name, locality_type_id, country_id) values ('приморский', 'край', 1);
insert into regions (first_name, locality_type_id, country_id) values ('псковская', 'область', 1);
insert into regions (first_name, locality_type_id, country_id) values ('ростовская', 'область', 1);
insert into regions (first_name, locality_type_id, country_id) values ('рязанская', 'область', 1);
insert into regions (first_name, locality_type_id, country_id) values ('самарская', 'область', 1);
insert into regions (first_name, locality_type_id, country_id) values ('санкт-петербург', 'город', 1);
insert into regions (first_name, locality_type_id, country_id) values ('саратовская', 'область', 1);
insert into regions (first_name, last_name, locality_type_id, country_id) values ('саха', 'якутия', 'pеспублика', 1);
insert into regions (first_name, locality_type_id, country_id) values ('сахалинская', 'область', 1);
insert into regions (first_name, locality_type_id, country_id) values ('свердловская', 'область', 1);
insert into regions (first_name, locality_type_id, country_id) values ('севастополь', 'город', 1);
insert into regions (first_name, last_name, locality_type_id, country_id) values ('северная осетия', 'алания', 'pеспублика', 1);
insert into regions (first_name, locality_type_id, country_id) values ('смоленская', 'область', 1);
insert into regions (first_name, locality_type_id, country_id) values ('ставропольский', 'край', 1);
insert into regions (first_name, locality_type_id, country_id) values ('тамбовская', 'область', 1);
insert into regions (first_name, locality_type_id, country_id) values ('татарстан', 'pеспублика', 1);
insert into regions (first_name, locality_type_id, country_id) values ('тверская', 'область', 1);
insert into regions (first_name, locality_type_id, country_id) values ('томская', 'область', 1);
insert into regions (first_name, locality_type_id, country_id) values ('тульская', 'область', 1);
insert into regions (first_name, locality_type_id, country_id) values ('тыва', 'pеспублика', 1);
insert into regions (first_name, locality_type_id, country_id) values ('тюменская', 'область', 1);
insert into regions (first_name, locality_type_id, country_id) values ('удмуртская', 'pеспублика', 1);
insert into regions (first_name, locality_type_id, country_id) values ('ульяновская', 'область', 1);
insert into regions (first_name, locality_type_id, country_id) values ('хабаровский', 'край', 1);
insert into regions (first_name, locality_type_id, country_id) values ('хакасия', 'pеспублика', 1);
insert into regions (first_name, last_name, locality_type_id, country_id) values ('ханты-мансийский', 'югра', 'автономный округ', 1);
insert into regions (first_name, locality_type_id, country_id) values ('челябинская', 'область', 1);
insert into regions (first_name, locality_type_id, country_id) values ('чеченская', 'pеспублика', 1);
insert into regions (first_name, last_name, locality_type_id, country_id) values ('чувашская', 'чувашия', 'pеспублика', 1);
insert into regions (first_name, locality_type_id, country_id) values ('чукотский', 'автономный округ', 1);
insert into regions (first_name, locality_type_id, country_id) values ('ямало-ненецкий', 'автономный округ', 1);
insert into regions (first_name, locality_type_id, country_id) values ('ярославская', 'область', 1);

-- select * from regions;
-- +----+----------------------+-----------+--------------------+------------+
-- | id | first_name           | last_name | locality_type_id   | country_id |
-- +----+----------------------+-----------+--------------------+------------+
-- |  1 | адыгея               | NULL      | pеспублика         |          1 |
-- |  2 | алтай                | NULL      | pеспублика         |          1 |
-- |  3 | алтайский            | NULL      | край               |          1 |
-- |  4 | амурская             | NULL      | область            |          1 |
-- |  5 | архангельская        | NULL      | область            |          1 |
-- |  6 | астраханская         | NULL      | область            |          1 |
-- |  7 | башкортостан         | NULL      | pеспублика         |          1 |
-- |  8 | белгородская         | NULL      | область            |          1 |
-- |  9 | брянская             | NULL      | область            |          1 |
-- | 10 | бурятия              | NULL      | pеспублика         |          1 |
-- | 11 | владимирская         | NULL      | область            |          1 |
-- | 12 | волгоградская        | NULL      | область            |          1 |
-- | 13 | вологодская          | NULL      | область            |          1 |
-- | 14 | воронежская          | NULL      | область            |          1 |
-- | 15 | дагестан             | NULL      | pеспублика         |          1 |
-- | 16 | еврейская            | NULL      | автономная область |          1 |
-- | 17 | забайкальский        | NULL      | край               |          1 |
-- | 18 | ивановская           | NULL      | область            |          1 |
-- | 19 | ингушетия            | NULL      | pеспублика         |          1 |
-- | 20 | иркутская            | NULL      | область            |          1 |
-- | 21 | кабардино-балкарская | NULL      | pеспублика         |          1 |
-- | 22 | калининградская      | NULL      | область            |          1 |
-- | 23 | калмыкия             | NULL      | pеспублика         |          1 |
-- | 24 | калужская            | NULL      | область            |          1 |
-- | 25 | камчатский           | NULL      | край               |          1 |
-- | 26 | карачаево-черкесская | NULL      | pеспублика         |          1 |
-- | 27 | карелия              | NULL      | pеспублика         |          1 |
-- | 28 | кемеровская          | NULL      | область            |          1 |
-- | 29 | кировская            | NULL      | область            |          1 |
-- | 30 | коми                 | NULL      | pеспублика         |          1 |
-- | 31 | костромская          | NULL      | область            |          1 |
-- | 32 | краснодарский        | NULL      | край               |          1 |
-- | 33 | красноярский         | NULL      | край               |          1 |
-- | 34 | крым                 | NULL      | pеспублика         |          1 |
-- | 35 | курганская           | NULL      | область            |          1 |
-- | 36 | курская              | NULL      | область            |          1 |
-- | 37 | ленинградская        | NULL      | область            |          1 |
-- | 38 | липецкая             | NULL      | область            |          1 |
-- | 39 | магаданская          | NULL      | область            |          1 |
-- | 40 | марий эл             | NULL      | pеспублика         |          1 |
-- | 41 | мордовия             | NULL      | pеспублика         |          1 |
-- | 42 | москва               | NULL      | город              |          1 |
-- | 43 | московская           | NULL      | область            |          1 |
-- | 44 | мурманская           | NULL      | область            |          1 |
-- | 45 | ненецкий             | NULL      | автономный округ   |          1 |
-- | 46 | нижегородская        | NULL      | область            |          1 |
-- | 47 | новгородская         | NULL      | область            |          1 |
-- | 48 | новосибирская        | NULL      | область            |          1 |
-- | 49 | омская               | NULL      | область            |          1 |
-- | 50 | оренбургская         | NULL      | область            |          1 |
-- | 51 | орловская            | NULL      | область            |          1 |
-- | 52 | пензенская           | NULL      | область            |          1 |
-- | 53 | пермский             | NULL      | край               |          1 |
-- | 54 | приморский           | NULL      | край               |          1 |
-- | 55 | псковская            | NULL      | область            |          1 |
-- | 56 | ростовская           | NULL      | область            |          1 |
-- | 57 | рязанская            | NULL      | область            |          1 |
-- | 58 | самарская            | NULL      | область            |          1 |
-- | 59 | санкт-петербург      | NULL      | город              |          1 |
-- | 60 | саратовская          | NULL      | область            |          1 |
-- | 61 | саха                 | якутия    | pеспублика         |          1 |
-- | 62 | сахалинская          | NULL      | область            |          1 |
-- | 63 | свердловская         | NULL      | область            |          1 |
-- | 64 | севастополь          | NULL      | город              |          1 |
-- | 65 | северная осетия      | алания    | pеспублика         |          1 |
-- | 66 | смоленская           | NULL      | область            |          1 |
-- | 67 | ставропольский       | NULL      | край               |          1 |
-- | 68 | тамбовская           | NULL      | область            |          1 |
-- | 69 | татарстан            | NULL      | pеспублика         |          1 |
-- | 70 | тверская             | NULL      | область            |          1 |
-- | 71 | томская              | NULL      | область            |          1 |
-- | 72 | тульская             | NULL      | область            |          1 |
-- | 73 | тыва                 | NULL      | pеспублика         |          1 |
-- | 74 | тюменская            | NULL      | область            |          1 |
-- | 75 | удмуртская           | NULL      | pеспублика         |          1 |
-- | 76 | ульяновская          | NULL      | область            |          1 |
-- | 77 | хабаровский          | NULL      | край               |          1 |
-- | 78 | хакасия              | NULL      | pеспублика         |          1 |
-- | 79 | ханты-мансийский     | югра      | автономный округ   |          1 |
-- | 80 | челябинская          | NULL      | область            |          1 |
-- | 81 | чеченская            | NULL      | pеспублика         |          1 |
-- | 82 | чувашская            | чувашия   | pеспублика         |          1 |
-- | 83 | чукотский            | NULL      | автономный округ   |          1 |
-- | 84 | ямало-ненецкий       | NULL      | автономный округ   |          1 |
-- | 85 | ярославская          | NULL      | область            |          1 |
-- +----+----------------------+-----------+--------------------+------------+



-- Адреса

insert into addresses(postal_code, locality_type_id, locality_title, street, home) 
    values('117312', 'город', 'москва', 'вавилова', '19');
insert into addresses(postal_code, region_id, locality_type_id, locality_title, street, home, flat) 
    values('248000', 24, 'город', 'калуга', 'московская', '188', '70');
insert into addresses(postal_code, region_id, locality_type_id, locality_title, street, home) 
    values('248040', 24, 'город', 'калуга', 'суворова', '121');
insert into addresses(postal_code, region_id, locality_type_id, locality_title, street, home, flat) 
    values('245000', 51, 'город', 'мценск', 'ленина', '15', '20');
insert into addresses(postal_code, region_id, locality_type_id, locality_title, street, home) 
    values('245055', 51, 'город', 'орёл', 'пушкина', '4');
insert into addresses(postal_code, region_id, locality_type_id, locality_title, street, home) 
    values('248000', 24, 'город', 'калуга', 'кирова', '21а');


-- select * from addresses;
-- +----+-------------+-----------+----------+------------------+----------------+------------+------+----------+------+
-- | id | postal_code | region_id | district | locality_type_id | locality_title | street     | home | building | flat |
-- +----+-------------+-----------+----------+------------------+----------------+------------+------+----------+------+
-- |  1 | 117312      |      NULL | NULL     | город            | москва         | вавилова   | 19   | NULL     | NULL |
-- |  2 | 248000      |        24 | NULL     | город            | калуга         | московская | 188  | NULL     | 70   |
-- |  3 | 248040      |        24 | NULL     | город            | калуга         | суворова   | 121  | NULL     | NULL |
-- |  4 | 245000      |        51 | NULL     | город            | мценск         | ленина     | 15   | NULL     | 20   |
-- +----+-------------+-----------+----------+------------------+----------------+------------+------+----------+------+



-- Паспорта
insert into passports(series, number, unic_number, police, police_code, dt_issue, address_id, person_id)
    values('2900', '102030', '2900102030', 'ТП УФМС РОССИИ ПО КАЛУЖСКОЙ ОБЛАСТИ В ДЗЕРЖИНСКОМ РАЙОНЕ', '400-001', '2000-05-05', 2, 1);
insert into clients(unic_number) values('2900102030');

insert into passports(series, number, unic_number, police, police_code, dt_issue, address_id, person_id)
    values('4905', '784512', '4905784512', 'ТП УФМС РОССИИ ПО ОРЛОВСКОЙ ОБЛАСТИ ГОРОДА МЦЕНСК', '570-002', '2010-10-10',3, 2);
insert into clients(unic_number) values('4905784512');

-- select * from passports;
-- +----+--------+--------+-------------+----------------------------------------------------------+-------------+------------+------------+-----------+
-- | id | series | number | unic_number | police                                                   | police_code | dt_issue   | address_id | person_id |
-- +----+--------+--------+-------------+----------------------------------------------------------+-------------+------------+------------+-----------+
-- |  1 | 2900   | 102030 | 2900102030  | ТП УФМС РОССИИ ПО КАЛУЖСКОЙ ОБЛАСТИ В ДЗЕРЖИНСКОМ РАЙОНЕ | 400-001     | 2000-05-05 |          1 |         1 |
-- |  2 | 4905   | 784512 | 4905784512  | ТП УФМС РОССИИ ПО ОРЛОВСКОЙ ОБЛАСТИ ГОРОДА МЦЕНСК        | 570-002     | 2010-10-10 |          2 |         2 |
-- +----+--------+--------+-------------+----------------------------------------------------------+-------------+------------+------------+-----------+

insert into bisiness_cards(name, ogrn, inn, kpp, orgform_id, address_id, director_id) 
    values('корпрорация ы', '112456784512', '4027603704', '402701001', 1, 4, 3);
insert into clients(unic_number) values('4027603704');

insert into bisiness_cards(name, ogrn, inn, kpp, orgform_id, address_id, director_id) 
    values('корпрорация а', '113896532147', '770258785', '770001001', 1, 5, 4);
insert into clients(unic_number) values('770258785');

insert into bisiness_cards(name, ogrn, inn, kpp, orgform_id, address_id, director_id) 
    values('сбербанк', '1027700132195', '7707083893', '773601001', 2, 1, 6);

-- select * from bisiness_cards;
-- +----+---------------+---------------+------------+-----------+------------+------------+-------------+
-- | id | name          | ogrn          | inn        | kpp       | orgform_id | address_id | director_id |
-- +----+---------------+---------------+------------+-----------+------------+------------+-------------+
-- |  1 | корпрорация ы | 112456784512  | 4027603704 | 402701001 |          1 |          4 |           3 |
-- |  2 | корпрорация а | 113896532147  | 770258785  | 770001001 |          1 |          5 |           4 |
-- |  3 | сбербанк      | 1027700132195 | 7707083893 | 773601001 |          2 |          1 |           6 |
-- +----+---------------+---------------+------------+-----------+------------+------------+-------------+

insert into banks(bik, department, pay_account, cor_account, bisiness_card_id, address_id, client_id)
    values('042908612', 'калужское отделение № 8608', '900000000000000000001', '30101810100000000612', 3, 6, 1);
insert into banks(bik, department, pay_account, cor_account, bisiness_card_id, address_id, client_id)
    values('042908612', 'калужское отделение № 8608', '900000000000000000002', '30101810100000000612', 3, 6, 2);
insert into banks(bik, department, pay_account, cor_account, bisiness_card_id, address_id, client_id)
    values('042908612', 'калужское отделение № 8608', '900000000000000000003', '30101810100000000612', 3, 6, 3);
insert into banks(bik, department, pay_account, cor_account, bisiness_card_id, address_id, client_id)
    values('042908612', 'калужское отделение № 8608', '900000000000000000004', '30101810100000000612', 3, 6, 4);


-- контакты
insert into contracts(number, dt_create, flat_id) values('0010101006/01012024', '2024-01-01', 1);
insert into contracts_clients(contract_id, client_id, part) values(1, 1, 55.5);
insert into contracts_clients(contract_id, client_id, part) values(1, 2, 44.5);
update flats set sale_status='подписано' where id = 1;

insert into contracts(number, dt_create, flat_id) values('0020101006/01012024', '2024-01-01', 2);
insert into contracts_clients(contract_id, client_id, part) values(2, 3, 100);
update flats set sale_status='подписано' where id = 2;

-- select * from flats limit 10;
-- +----+--------+----------+-------------+
-- | id | number | floor_id | sale_status |
-- +----+--------+----------+-------------+
-- |  1 | 1      |        1 | подписано   |
-- |  2 | 2      |        1 | подписано   |
-- |  3 | 3      |        1 | свободно    |
-- |  4 | 4      |        1 | свободно    |
-- |  5 | 5      |        2 | свободно    |
-- |  6 | 6      |        2 | свободно    |
-- |  7 | 7      |        2 | свободно    |
-- |  8 | 8      |        2 | свободно    |
-- |  9 | 9      |        3 | свободно    |
-- | 10 | 10     |        3 | свободно    |
-- +----+--------+----------+-------------+

