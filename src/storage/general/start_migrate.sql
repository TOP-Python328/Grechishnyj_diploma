create table energy_saves (
    name varchar(4) primary key);
insert into energy_saves (name) values ('A++');
insert into energy_saves (name) values ('A+');
insert into energy_saves (name) values ('A');
insert into energy_saves (name) values ('B');
insert into energy_saves (name) values ('C');
insert into energy_saves (name) values ('D');
insert into energy_saves (name) values ('E');
insert into energy_saves (name) values ('F');
insert into energy_saves (name) values ('G');

create table seismics (
    name varchar(4) primary key);
insert into seismics (name) values ('Классификация не требуется');
insert into seismics (name) values ('C5');
insert into seismics (name) values ('C6');
insert into seismics (name) values ('C7');
insert into seismics (name) values ('C8');
insert into seismics (name) values ('C9');
insert into seismics (name) values ('C10');

create table materials (
    id integer primary key,
    name varchar(32) not null unique);
insert into materials (name) values ('газобетонные блоки');
insert into materials (name) values ('кирпич');
insert into materials (name) values ('монолит');
insert into materials (name) values ('монолит каркасный');
insert into materials (name) values ('панели ЖБИ');
insert into materials (name) values ('плиты ЖБИ');

create table sale_statuses (
    name varchar(16) primary key);
insert into sale_statuses (name) values ('free');
insert into sale_statuses (name) values ('sold');

create table room_types ( 
    id integer primary key, 
    name varchar(32) not null unique, 
    living boolean not null check (living in (0, 1)), 
    koef_price float not null default(1.0)); 
insert into room_types (name, living, koef_price) values ('гостинная', 1, 1.0); 
insert into room_types (name, living, koef_price) values ('спальня', 1, 1.0); 
insert into room_types (name, living, koef_price) values ('детская', 1, 1.0); 
insert into room_types (name, living, koef_price) values ('кабинет', 1, 1.0); 
insert into room_types (name, living, koef_price) values ('кухня', 0, 1.0); 
insert into room_types (name, living, koef_price) values ('ванная', 0, 1.0); 
insert into room_types (name, living, koef_price) values ('туалет', 0, 1.0); 
insert into room_types (name, living, koef_price) values ('санузел', 0, 1.0); 
insert into room_types (name, living, koef_price) values ('коридор', 0, 1.0); 
insert into room_types (name, living, koef_price) values ('прихожая', 0, 1.0); 
insert into room_types (name, living, koef_price) values ('лоджия', 0, 0.5); 
insert into room_types (name, living, koef_price) values ('балкон', 0, 0.5);

create table land_plots (
    id integer primary key,
    number varchar(64) not null unique,
    square float not null default(0.0),
    usage varchar(128) not null,
    category varchar(128) not null,
    owner_type varchar(64) not null,
    owner_number varchar(64) not null,
    owner_date date not null,
    owner_reg_number varchar(64) not null,
    owner_reg_date date not null,
    document_egrn date);

create table building_permits (
    id integer primary key,
    number varchar(32) not null unique,
    dt_issue date not null,
    dt_expiry date not null,
    land_plot_id integer not null,
    foreign key (land_plot_id) references land_plots(id));

create table house_types (
    id integer primary key,
    name varchar(16) not null);
insert into house_types (name) values ('монолитный');
insert into house_types (name) values ('кирпичный');
insert into house_types (name) values ('панельный');

create table microdistricts (
    id integer primary key,
    name varchar(32) not null unique,
    full_name text(1000));

create table houses (
    id integer primary key,
    number varchar(8) not null,
    building_permit_id integer not null,
    microdistrict_id integer not null,
    energy_save_id varchar(4) not null,
    seismic_id varchar(4) not null,
    type_id integer not null,
    material_wall_id integer not null,
    material_floor_id integer not null, 
    address_id integer not null, 
    foreign key (building_permit_id) references building_permits(id),
    foreign key (microdistrict_id) references microdistricts(id),
    foreign key (energy_save_id) references energy_saves(name),
    foreign key (seismic_id) references seismics(name),
    foreign key (type_id) references house_types(id),
    foreign key (material_wall_id) references materials(id),
    foreign key (material_floor_id) references materials(id),
    foreign key (address_id) references addresses(id));

create table flats_plan ( 
    id integer primary key, 
    name varchar(32) not null, 
    square float not null default(0.0), 
    room_type_id integer not null, 
    foreign key (room_type_id) references room_types(id));

create table flats ( 
    id integer primary key, 
    number varchar(4) not null, 
    floor_id integer not null, 
    status_id varchar(16) not null default 'free', 
    flat_plan_id integer not null, 
    foreign key (floor_id) references floors(id), 
    foreign key (status_id) references sale_statuses(name), 
    foreign key (flat_plan_id) references flats_plan(id));

create table floors_plan (
    id integer primary key,
    name varchar(32) not null,
    flat_plan_name varchar(32) not null);

create table floors (
    id integer primary key,
    number varchar(4) not null,
    section_id integer not null,
    floor_plan_id integer not null,
    foreign key (section_id) references sections(id),
    foreign key (floor_plan_id) references floors_plan(id));

create table sections_plan (
    id integer primary key,
    name varchar(32) not null,
    floor_plan_name varchar(32) not null);

create table sections (
    id integer primary key,
    number varchar(2) not null,
    house_id integer not null,
    section_plan_id integer not null,
    foreign key (house_id) references houses(id),
    foreign key (section_plan_id) references sections_plan(id));

create table rooms (
    id integer primary key,
    square float not null default(0.0),
    flat_id integer not null,
    room_type_id integer not null,
    foreign key (flat_id) references flats(id),
    foreign key (room_type_id) references room_types(id));

create table addresses (
    id integer primary key,
    country_name varchar(32) not null,
    country_full_name varchar(64) not null,
    region varchar(64) not null,
    district varchar(64) not null,
    locality varchar(12) not null,
    city varchar(64) not null,
    street varchar(64),
    home varchar(16),
    flat varchar(4));

create table orgforms (
    id integer primary key,
    full_name varchar(256) not null,
    short_name varchar(16) not null);
insert into orgforms (full_name, short_name) values ('Общество с ограниченной ответственностью', 'ООО');
insert into orgforms (full_name, short_name) values ('Публичное акционерное общество', 'ПАО');

create table persons (
    id integer primary key,
    last_name varchar(64) not null,
    first_name varchar(64) not null,
    patr_name varchar(64),
    sex boolean not null check (sex in (0, 1)),
    birthday date not null);

create table banks (
    id integer primary key,
    bik varchar(16) not null,
    branch varchar(128) not null,
    ks varchar(32) not null,
    rs varchar(32) not null,
    city varchar(64),
    address varchar(128),
    owner_uid varchar(16) not null,
    owner_type varchar(16) not null);

create table passports (
    id integer primary key,
    series varchar(8) not null,
    number varchar(8) not null,
    police_name varchar(256) not null,
    police_code varchar(16) not null,
    place_birth varchar(256) not null,
    dt_issue date not null,
    address_id integer not null,
    person_id integer not null,
    client_id integer,
    bank_id integer,
    foreign key (address_id) references addresses(id),
    foreign key (person_id) references persons(id),
    foreign key (bank_id) references banks(id));

create table buisiness_cards (
    id integer primary key,
    full_name varchar(256),
    short_name varchar(64) not null,
    inn varchar(16) not null,
    kpp varchar(16) not null,
    ogrn varchar(16) not null,
    business varchar(32) not null,
    site varchar(64),
    email varchar(64),
    director_power_type varchar(32),
    director_power_number varchar(32),
    director_power_date date,
    director_id integer,
    address_id integer,
    orgform_id integer not null,
    client_id integer,
    bank_id integer,
    foreign key (director_id) references persons(id),
    foreign key (address_id) references addresses(id),
    foreign key (orgform_id) references orgforms(id),
    foreign key (bank_id) references banks(id));

create table clients (
    id integer primary key,
    passport_id integer,
    business_id integer,
    foreign key (passport_id) references passports(id),
    foreign key (business_id) references buisiness_cards(id));

create table sales (
    id integer primary key,
    number varchar(32) not null,
    dt_issue date not null,
    price float not null default(0.0),
    city varchar(32) not null,
    decoration boolean not null check (decoration in (0, 1)),
    flat_id integer not null,
    escrow_agent_id integer not null,
    foreign key (flat_id) references flats(id),
    foreign key (escrow_agent_id) references buisiness_cards(id));

create table sales_clients (
    id integer primary key,
    part float not null default(100.0), 
    pay_days varchar(3) not null,
    own_money float not null default(0.0), 
    credit_money float not null default(0.0),
    client_id integer not null,
    sale_id integer not null,
    foreign key (client_id) references clients(id),
    foreign key (sale_id) references sales(id));

