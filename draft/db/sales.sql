use topdip;

insert into contracts_type(name) values('Договор долевого участия');

insert into contracts(number, price, flat_id, type_id, dt_issue) values ('0010101006', 2000000.00, 1, 1, '2024-01-01');
insert into sales(contract_id, client_id, part_price) values('0010101006', '1000445566', 50.00);
insert into sales(contract_id, client_id, part_price) values('0010101006', '2900102030', 50.00);
update flats set status_id='подписано' where id=1;

insert into contracts(number, price, flat_id, type_id, dt_issue) values ('0020101006', 2000000.00, 2, 1, '2024-01-01');
insert into sales(contract_id, client_id, part_price) values('0020101006', '3400784512', 50.00);
insert into sales(contract_id, client_id, part_price) values('0020101006', '4500895623', 50.00);
update flats set status_id='подписано' where id=2;

insert into contracts(number, price, flat_id, type_id, dt_issue) values ('0030101006', 2000000.00, 3, 1, '2024-01-01');
insert into sales(contract_id, client_id, part_price) values('0030101006', '1111111111', 100.00);
update flats set status_id='подписано' where id=3;

insert into contracts(number, price, flat_id, type_id, dt_issue) values ('0040101006', 2000000.00, 4, 1, '2024-01-01');
insert into sales(contract_id, client_id, part_price) values('0030101006', '2222222222', 100.00);
update flats set status_id='подписано' where id=4;

select * from flats limit 10;