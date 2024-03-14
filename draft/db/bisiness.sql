use topdip;

-- Организационно-правовые формы
insert into orgforms (name, short_name) values ('Общество с ограниченной ответственностью', 'ООО');
insert into orgforms (name, short_name) values ('Публичное акционерное общество', 'ПАО');
insert into orgforms (name, short_name) values ('Индивидуальный предприниматель', 'ИП');


-- Бизнес карты
insert into bisiness_cards (name, ogrn, unic, kpp, address_id, director_id, orgform_id) 
    values ('Сбербанк', '7712345678910', '7712345678', '7701001', 7, 7, 2);
insert into clients(unic) values('7712345678');

insert into bisiness_cards (name, ogrn, unic, kpp, address_id, director_id, orgform_id) 
    values ('Корпорация Ы', '11111111111111', '1111111111', '1111111', 8, 8, 1);
insert into clients(unic) values('1111111111');

insert into bisiness_cards (name, ogrn, unic, kpp, address_id, director_id, orgform_id) 
    values ('Корпорация Ю', '22222222222222', '2222222222', '2222222', 9, 9, 1);
insert into clients(unic) values('2222222222');

