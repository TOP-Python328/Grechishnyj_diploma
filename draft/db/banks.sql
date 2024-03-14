use topdip;


-- insert into clients(unic) values('1515794613');
-- insert into clients(unic) values('2900102030');
-- insert into clients(unic) values('3400784512');
-- insert into clients(unic) values('3678102030');
-- insert into clients(unic) values('4500895623');
-- insert into clients(unic) values('1111111111');
-- insert into clients(unic) values('2222222222');


insert into banks(bik, department, pay_account, cor_account, bisiness_card_id, client_id) 
    values('4011111111', 'Отделение № 8608', '40802457898653212', '300500600700', '7712345678', '1515794613');

insert into banks(bik, department, pay_account, cor_account, bisiness_card_id, client_id) 
    values('4011111111', 'Отделение № 8608', '40802989898989898', '300500600700', '7712345678', '2900102030');

insert into banks(bik, department, pay_account, cor_account, bisiness_card_id, client_id) 
    values('4011111111', 'Отделение № 8608', '40802111111111111', '300500600700', '7712345678', '1111111111');

insert into banks(bik, department, pay_account, cor_account, bisiness_card_id, client_id) 
    values('4011111111', 'Отделение № 8608', '40802222222222222', '300500600700', '7712345678', '2222222222');



select bik, department, pay_account, bisiness_card_id, client_id from banks
    join clients on banks.client_id = clients.unic
    join bisiness_cards on clients.unic = bisiness_cards.unic;

select bik, department, pay_account, bisiness_card_id, client_id from banks
    join clients on banks.client_id = clients.unic
    join passports on clients.unic = passports.unic;

