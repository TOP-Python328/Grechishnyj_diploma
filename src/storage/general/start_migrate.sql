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

create table rooms (
    id integer primary key,
    name varchar(32) not null unique,
    living boolean not null check (living in (0, 1)),
    koef_price float not null);
insert into rooms (name, living, koef_price) values ('гостинная', 1, 1.0);
insert into rooms (name, living, koef_price) values ('спальня', 1, 1.0);
insert into rooms (name, living, koef_price) values ('детская', 1, 1.0);
insert into rooms (name, living, koef_price) values ('кабинет', 1, 1.0);
insert into rooms (name, living, koef_price) values ('кухня', 0, 1.0);
insert into rooms (name, living, koef_price) values ('ванная', 0, 1.0);
insert into rooms (name, living, koef_price) values ('туалет', 0, 1.0);
insert into rooms (name, living, koef_price) values ('санузел', 0, 1.0);
insert into rooms (name, living, koef_price) values ('коридор', 0, 1.0);
insert into rooms (name, living, koef_price) values ('прихожая', 0, 1.0);
insert into rooms (name, living, koef_price) values ('лоджия', 0, 0.5);
insert into rooms (name, living, koef_price) values ('балкон', 0, 0.5);

create table building_permits (
    id integer primary key,
    number varchar(32) not null unique,
    dt_issue date not null,
    dt_expiry date not null);

create table house_types (
    id integer primary key,
    name varchar(16) not null);
insert into house_types (name) values ('монолитный');
insert into house_types (name) values ('кирпичный');
insert into house_types (name) values ('панельный');

create table microdistricts (
    id integer primary key,
    name varchar(32) not null unique);

create table houses (
    id integer primary key,
    number varchar(8) not null,
    building_permit_id integer not null,
    microdistrict_id integer not null,
    energy_save_id varchar(4) not null,
    seismic_id varchar(4) not null,
    type_id integer not null,
    foreign key (building_permit_id) references building_permits(id),
    foreign key (microdistrict_id) references microdistricts(id),
    foreign key (energy_save_id) references energy_saves(name),
    foreign key (seismic_id) references seismics(name),
    foreign key (type_id) references house_types(id));

create table section_types (
    name varchar(32) primary key);
insert into section_types (name) values ('отдельностоящая');
insert into section_types (name) values ('рядовая');
insert into section_types (name) values ('торцевая');
insert into section_types (name) values ('угловая');

create table sections (
    id integer primary key,
    number varchar(2) not null,
    house_id integer not null,
    type_id varchar(32) not null,
    foreign key (type_id) references section_types(name),
    foreign key (house_id) references houses(id));

create table floors (
    id integer primary key,
    number varchar(4) not null);

create table flats (
    id integer primary key,
    number varchar(4) not null,
    floor_id integer not null,
    status_id varchar(16) not null default 'free',
    foreign key (floor_id) references floors(id),
    foreign key (status_id) references sale_statuses(name));

create table flats_plan (
    id integer primary key,
    square float not null,
    flat_id integer not null,
    room_id integer not null,
    foreign key (flat_id) references flats(id),
    foreign key (room_id) references rooms(id));


