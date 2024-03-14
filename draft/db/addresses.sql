use topdip;

-- Страна
insert into countries (full_name, short_name, int_code) values ('Pоссийская Федерация', 'Россия', 'RUS');


-- Локации
insert into locations (name, size) values ('республика', 'large');
insert into locations (name, size) values ('край', 'large');
insert into locations (name, size) values ('автономная область', 'large');
insert into locations (name, size) values ('автономный округ', 'large');
insert into locations (name, size) values ('область', 'large');
insert into locations (name, size) values ('район', 'small');
insert into locations (name, size) values ('округ', 'small');
insert into locations (name, size) values ('город', 'small');
insert into locations (name, size) values ('село', 'small');
insert into locations (name, size) values ('поселение', 'small');
insert into locations (name, size) values ('посёлок', 'small');
insert into locations (name, size) values ('деревня', 'small');


-- Регионы
insert into regions (name, locality_id, country_id) values ('Aдыгея', 'республика', 1);
insert into regions (name, locality_id, country_id) values ('Aлтай', 'республика', 1);
insert into regions (name, locality_id, country_id) values ('Aлтайский', 'край', 1);
insert into regions (name, locality_id, country_id) values ('Aмурская', 'область', 1);
insert into regions (name, locality_id, country_id) values ('Aрхангельская', 'область', 1);
insert into regions (name, locality_id, country_id) values ('Aстраханская', 'область', 1);
insert into regions (name, locality_id, country_id) values ('Башкортостан', 'республика', 1);
insert into regions (name, locality_id, country_id) values ('Белгородская', 'область', 1);
insert into regions (name, locality_id, country_id) values ('Брянская', 'область', 1);
insert into regions (name, locality_id, country_id) values ('Бурятия', 'республика', 1);
insert into regions (name, locality_id, country_id) values ('Владимирская', 'область', 1);
insert into regions (name, locality_id, country_id) values ('Волгоградская', 'область', 1);
insert into regions (name, locality_id, country_id) values ('Вологодская', 'область', 1);
insert into regions (name, locality_id, country_id) values ('Воронежская', 'область', 1);
insert into regions (name, locality_id, country_id) values ('Дагестан', 'республика', 1);
insert into regions (name, locality_id, country_id) values ('Еврейская', 'автономная область', 1);
insert into regions (name, locality_id, country_id) values ('Забайкальский', 'край', 1);
insert into regions (name, locality_id, country_id) values ('Ивановская', 'область', 1);
insert into regions (name, locality_id, country_id) values ('Ингушетия', 'республика', 1);
insert into regions (name, locality_id, country_id) values ('Иркутская', 'область', 1);
insert into regions (name, locality_id, country_id) values ('Кабардино-Балкарская', 'республика', 1);
insert into regions (name, locality_id, country_id) values ('Калининградская', 'область', 1);
insert into regions (name, locality_id, country_id) values ('Калмыкия', 'республика', 1);
insert into regions (name, locality_id, country_id) values ('Калужская', 'область', 1);
insert into regions (name, locality_id, country_id) values ('Камчатский', 'край', 1);
insert into regions (name, locality_id, country_id) values ('Карачаево-Черкесская', 'республика', 1);
insert into regions (name, locality_id, country_id) values ('Карелия', 'республика', 1);
insert into regions (name, locality_id, country_id) values ('Кемеровская', 'область', 1);
insert into regions (name, locality_id, country_id) values ('Кировская', 'область', 1);
insert into regions (name, locality_id, country_id) values ('Коми', 'республика', 1);
insert into regions (name, locality_id, country_id) values ('Костромская', 'область', 1);
insert into regions (name, locality_id, country_id) values ('Краснодарский', 'край', 1);
insert into regions (name, locality_id, country_id) values ('Красноярский', 'край', 1);
insert into regions (name, locality_id, country_id) values ('Крым', 'республика', 1);
insert into regions (name, locality_id, country_id) values ('Курганская', 'область', 1);
insert into regions (name, locality_id, country_id) values ('Курская', 'область', 1);
insert into regions (name, locality_id, country_id) values ('Ленинградская', 'область', 1);
insert into regions (name, locality_id, country_id) values ('Липецкая', 'область', 1);
insert into regions (name, locality_id, country_id) values ('Магаданская', 'область', 1);
insert into regions (name, locality_id, country_id) values ('Марий Эл', 'республика', 1);
insert into regions (name, locality_id, country_id) values ('Мордовия', 'республика', 1);
insert into regions (name, locality_id, country_id) values ('Москва', 'город', 1);
insert into regions (name, locality_id, country_id) values ('Московская', 'область', 1);
insert into regions (name, locality_id, country_id) values ('Мурманская', 'область', 1);
insert into regions (name, locality_id, country_id) values ('Ненецкий', 'автономный округ', 1);
insert into regions (name, locality_id, country_id) values ('Нижегородская', 'область', 1);
insert into regions (name, locality_id, country_id) values ('Новгородская', 'область', 1);
insert into regions (name, locality_id, country_id) values ('Новосибирская', 'область', 1);
insert into regions (name, locality_id, country_id) values ('Омская', 'область', 1);
insert into regions (name, locality_id, country_id) values ('Оренбургская', 'область', 1);
insert into regions (name, locality_id, country_id) values ('Орловская', 'область', 1);
insert into regions (name, locality_id, country_id) values ('Пензенская', 'область', 1);
insert into regions (name, locality_id, country_id) values ('Пермский', 'край', 1);
insert into regions (name, locality_id, country_id) values ('Приморский', 'край', 1);
insert into regions (name, locality_id, country_id) values ('Псковская', 'область', 1);
insert into regions (name, locality_id, country_id) values ('Ростовская', 'область', 1);
insert into regions (name, locality_id, country_id) values ('Рязанская', 'область', 1);
insert into regions (name, locality_id, country_id) values ('Самарская', 'область', 1);
insert into regions (name, locality_id, country_id) values ('Санкт-Петербург', 'город', 1);
insert into regions (name, locality_id, country_id) values ('Саратовская', 'область', 1);
insert into regions (name, locality_id, country_id) values ('Саха', 'республика', 1);
insert into regions (name, locality_id, country_id) values ('Сахалинская', 'область', 1);
insert into regions (name, locality_id, country_id) values ('Свердловская', 'область', 1);
insert into regions (name, locality_id, country_id) values ('Севастополь', 'город', 1);
insert into regions (name, locality_id, country_id) values ('Северная Осетия', 'республика', 1);
insert into regions (name, locality_id, country_id) values ('Смоленская', 'область', 1);
insert into regions (name, locality_id, country_id) values ('Ставропольский', 'край', 1);
insert into regions (name, locality_id, country_id) values ('Тамбовская', 'область', 1);
insert into regions (name, locality_id, country_id) values ('Татарстан', 'республика', 1);
insert into regions (name, locality_id, country_id) values ('Тверская', 'область', 1);
insert into regions (name, locality_id, country_id) values ('Томская', 'область', 1);
insert into regions (name, locality_id, country_id) values ('Тульская', 'область', 1);
insert into regions (name, locality_id, country_id) values ('Тыва', 'республика', 1);
insert into regions (name, locality_id, country_id) values ('Тюменская', 'область', 1);
insert into regions (name, locality_id, country_id) values ('Удмуртская', 'республика', 1);
insert into regions (name, locality_id, country_id) values ('Ульяновская', 'область', 1);
insert into regions (name, locality_id, country_id) values ('Хабаровский', 'край', 1);
insert into regions (name, locality_id, country_id) values ('Хакасия', 'республика', 1);
insert into regions (name, locality_id, country_id) values ('Ханты-Мансийский', 'автономный округ', 1);
insert into regions (name, locality_id, country_id) values ('Челябинская', 'область', 1);
insert into regions (name, locality_id, country_id) values ('Чеченская', 'республика', 1);
insert into regions (name, locality_id, country_id) values ('Чувашская', 'республика', 1);
insert into regions (name, locality_id, country_id) values ('Чукотский', 'автономный округ', 1);
insert into regions (name, locality_id, country_id) values ('Ямало-Ненецкий', 'автономный округ', 1);
insert into regions (name, locality_id, country_id) values ('Ярославская', 'область', 1);


-- Адреса
insert into addresses(postal_code, region_id, locality_id, title, street, house) values('117312', 42, 'город', 'Москва', 'Вавилова', '19');
insert into addresses(postal_code, region_id, locality_id, title, street, house, flat) values('248000', 24, 'город', 'Калуга', 'Московская', '188', '70');
insert into addresses(postal_code, region_id, locality_id, title, street, house) values('248040', 24, 'город', 'Калуга', 'Суворова', '121');
insert into addresses(postal_code, region_id, locality_id, title, street, house, flat) values('245000', 51, 'город', 'Мценск', 'Ленина', '15', '20');
insert into addresses(postal_code, region_id, locality_id, title, street, house) values('245055', 51, 'город', 'Орёл', 'Пушкина', '4');
insert into addresses(postal_code, region_id, locality_id, title, street, house) values('248000', 24, 'город', 'Калуга', 'Кирова', '21а');
insert into addresses(postal_code, region_id, locality_id, title, street, house) values('249033', 24, 'город', 'Обнинск', 'Гагарина', '13');
insert into addresses(postal_code, region_id, locality_id, title, street, house) values('249033', 24, 'город', 'Обнинск', 'Гагарина', '10');
insert into addresses(postal_code, region_id, locality_id, title, street, house) values('100000', 51, 'город', 'Орёл', 'Гагарина', '41');
insert into addresses(postal_code, region_id, locality_id, title, street, house) values('200000', 24, 'город', 'Калуга', 'Вилонова', '121');
insert into addresses(postal_code, region_id, locality_id, title, street, house) values('300000', 24, 'город', 'Обнинск', 'Суворова', '113');
insert into addresses(postal_code, region_id, locality_id, title, street, house) values('400000', 24, 'город', 'Орёл', 'Ленина', '90');


select 
    addresses.id as id, 
    addresses.postal_code as Postal, 
    countries.full_name as Country, 
    regions.name as Region, 
    regions.locality_id as _, 
    addresses.district as District, 
    addresses.locality_id as _, 
    addresses.title as Title, 
    addresses.street as Street,
    addresses.house as House,
    addresses.index as Postindex,
    addresses.flat as Flat
from addresses
    join regions on regions.id = addresses.region_id
    join countries on countries.id = regions.country_id;