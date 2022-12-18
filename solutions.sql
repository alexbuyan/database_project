
drop schema if exists camp cascade;
create schema camp;

-- task3

-- контакт родителя на случай чп
drop table if exists camp.parent cascade;
create table if not exists camp.parent(
    parent_id integer,
    valid_from_date date not null check ( valid_from_date < valid_to_date ) default now(),
    parent_name varchar(50) not null,
    parent_phone varchar(50) check (regexp_match(parent_phone, '^((8|\+7)[\- ]?)?(\(?\d{3}\)?[\- ]?)?[\d\- ]{7,10}$') notnull),
    valid_to_date date not null check ( valid_from_date < valid_to_date ),

    primary key (parent_id, valid_from_date)
);

-- ребенок
drop table if exists camp.child cascade;
create table if not exists camp.child(
    child_id integer primary key,
    parent_id integer,
    valid_from_date date default now(),
    child_name varchar(50) not null,
    child_age integer not null check ( child_age between 9 and 17),
    child_gender varchar(1) not null check ( child_gender in ('М', 'Ж') ),

    foreign key (parent_id, valid_from_date) references camp.parent on delete set null
);

-- руководитель смены
drop table if exists camp.director cascade;
create table if not exists camp.director(
    director_id integer primary key,
    director_name varchar(50) not null,
    director_age integer not null check ( director_age between 18 and 65),
    director_phone varchar(50) check (regexp_match(director_phone, '^((8|\+7)[\- ]?)?(\(?\d{3}\)?[\- ]?)?[\d\- ]{7,10}$') notnull)
);

-- база отдыха
drop table if exists camp.recreation_centre cascade;
create table if not exists camp.recreation_centre(
    centre_id integer primary key,
    centre_name varchar(50) not null,
    centre_location varchar(50) not null,
    centre_type varchar(50) not null
);

-- смена в лагере
drop table if exists camp.session cascade;
create table if not exists camp.session(
    session_id integer primary key,
    director_id integer references camp.director(director_id) on delete set null,
    centre_id integer references camp.recreation_centre(centre_id) on delete set null,
    session_name varchar(50) not null,
    session_duration integer check ( session_duration in (14, 21) ),
    session_price integer not null check ( session_price >= 0 )
);

-- вожатый
drop table if exists camp.counselor cascade;
create table if not exists camp.counselor(
    counselor_id integer primary key,
    counselor_name varchar(50) not null,
    counselor_age integer not null check ( counselor_age between 18 and 35),
    counselor_phone varchar(50) check (regexp_match(counselor_phone, '^((8|\+7)[\- ]?)?(\(?\d{3}\)?[\- ]?)?[\d\- ]{7,10}$') notnull)
);

-- врач на базе отдыха
drop table if exists camp.doctor cascade;
create table if not exists camp.doctor(
    doctor_id integer primary key,
    centre_id integer references camp.recreation_centre(centre_id) on delete set null,
    doctor_name varchar(50) not null,
    doctor_phone varchar(50) check (regexp_match(doctor_phone, '^((8|\+7)[\- ]?)?(\(?\d{3}\)?[\- ]?)?[\d\- ]{7,10}$') notnull)
);

-- смена <-> дети
drop table if exists camp.session_x_child cascade;
create table if not exists camp.session_x_child(
    session_id integer references camp.session(session_id) on delete cascade,
    child_id integer not null references camp.child(child_id) on delete cascade,
    voucher_id serial not null unique,

    primary key (session_id, child_id)
);

-- вожатые <-> дети
drop table if exists camp.counselor_x_child cascade;
create table if not exists camp.counselor_x_child(
    counselor_id integer references camp.counselor(counselor_id) on delete cascade,
    child_id integer references camp.child(child_id) on delete cascade,

    primary key (counselor_id, child_id)
);

-- смена <-> вожатые
drop table if exists camp.session_x_counselor cascade;
create table if not exists camp.session_x_counselor(
    session_id integer references camp.session(session_id) on delete cascade,
    counselor_id integer references camp.counselor(counselor_id) on delete cascade,
    counselor_salary integer not null check ( counselor_salary >= 0 ),

    primary key (session_id, counselor_id)
);


-- task 4
set datestyle = 'DMY';

insert into camp.parent(parent_id, valid_from_date, parent_name, parent_phone, valid_to_date)
values (1, '01.12.2022', 'Иван Иванов', '+79329232389', '17.12.2022'),
       (3, '03.10.2021', 'Алексей Алексеев', '+79329043389', '15.12.2022');
insert into camp.parent(parent_id, parent_name, parent_phone, valid_to_date)
values (1, 'Иван Иванов', '+79211001010', '01.01.9999'),
       (2, 'Петр Петров', '+79112002020', '01.01.9999'),
       (3, 'Алексей Алексеев', '+79003003030', '01.01.9999'),
       (4, 'Ольга Андреева', '+78124004040', '01.01.9999'),
       (5, 'Анна Петрова', '+78125005050', '01.01.9999');

insert into camp.child(child_id, parent_id, child_name, child_age, child_gender)
values (1, 1, 'Андрей Иванов', 9, 'М'),
       (6, 1, 'Евгения Иванова', 10, 'Ж'),
       (2, 2, 'Алина Петрова', 11, 'Ж'),
       (3, 3, 'Олег Алексеев', 13, 'М'),
       (7, 3, 'Анастасия Алексеева', 16, 'Ж'),
       (4, 4, 'Анна Андреева', 15, 'Ж'),
       (5, 5, 'Александр Петров', 17, 'М');

insert into camp.director(director_id, director_name, director_age, director_phone)
values (1, 'Александр Иванов', 35, '+7(999)9999999'),
       (2, 'Алла Иванова', 45, '+7(888)8888888'),
       (3, 'Анастасия Баканова', 40, '+7(777)7777777'),
       (4, 'Ольга Заболотская', 50, '+76666666666'),
       (5, 'Александр Буянтуев', 65, '+79115055005');

insert into camp.recreation_centre(centre_id, centre_name, centre_location, centre_type)
values (1, 'Артек', 'Крым', 'МДЦ'),
       (2, 'АРТ Личность', 'Санкт-Петербург', 'Программный лагерь'),
       (3, 'Нить Ариадны', 'Санкт-Петербург', 'Программный лагерь'),
       (4, 'Байтик', 'Казань', 'ДОЛ'),
       (5, 'Орленок', 'Краснодарский край', 'ВДЦ');

insert into camp.session(session_id, director_id, centre_id, session_name, session_duration, session_price)
values (1, 1, 1, '1 смена Лето 2023', 14, 20000),
       (2, 2, 2, '2 смена Лето 2023', 21, 30000),
       (3, 3, 3, '3 смена Лето 2023', 21, 40000),
       (4, 4, 4, '4 смена Лето 2023', 14, 25000),
       (5, 5, 5, '5 смена Лето 2023', 21, 35000),
       (6, 5, 5, '6 смена Лето 2023', 14, 15000);

insert into camp.counselor(counselor_id, counselor_name, counselor_age, counselor_phone)
values (1, 'Дмитрий Ботев', 20, '+7(111)1231213'),
       (2, 'Полина Белоногова', 21, '+7(123)1111001'),
       (3, 'Софа Левашова', 22, '+7(987)6543210'),
       (4, 'Егор Ильин', 23, '+7(123)4567890'),
       (5, 'Антон Томшинский', 21, '+71000101010');

insert into camp.doctor(doctor_id, centre_id, doctor_name, doctor_phone)
values (1, 1, 'Екатерина Браун', '+7(921)1992910'),
       (2, 2, 'Михаил Малофеев', '+79329028145'),
       (3, 3, 'Никита Храмов', '+79320937653'),
       (4, 4, 'Владимир Туров', '+7(392)3208129'),
       (5, 5, 'Анастасия Горелова', '+7(290)3920832');

insert into camp.session_x_child(session_id, child_id)
values (1, 1),
       (2, 2),
       (3, 3),
       (4, 4),
       (5, 5),
       (3, 6),
       (2, 7);

insert into camp.counselor_x_child(counselor_id, child_id)
values (1, 1),
       (2, 2),
       (3, 3),
       (4, 4),
       (5, 5),
       (3, 6),
       (2, 7);

insert into camp.session_x_counselor(session_id, counselor_id, counselor_salary)
values (1, 1, 20000),
       (2, 2, 30000),
       (3, 3, 40000),
       (4, 4, 25000),
       (5, 5, 35000);

-- task 5
-- запросы к таблице camp.director
-- delete
delete from camp.director where director_id = 5;

-- insert
insert into camp.director(director_id, director_name, director_age, director_phone)
values (5, 'Лиза Вахромеева', 30, '+79210328813');
update camp.session set director_id = 5 where camp.session.director_id is null;

-- update
update camp.director
set director_age = 31
where director_id = 5;

-- select
select
    director_name, director_age
from camp.director
where director_age > 35;

-- запросы к таблице camp.counselor
-- insert
insert into camp.counselor(counselor_id, counselor_name, counselor_age, counselor_phone)
values (6, 'Марья Гришина', 22, '+74930029323');
insert into camp.session_x_counselor(session_id, counselor_id, counselor_salary)
values (3, 6, 120000);

-- delete
delete from camp.counselor where counselor_age < 22;

-- update
update camp.counselor
set counselor_phone = '+79202349208'
where counselor_id = 4;

-- select
select
    counselor_name, counselor_phone
from camp.counselor
where counselor_id % 2 = 0;


-- task 6
-- вывести имя и телефон всех родителей, у кого 2 и более ребенка, а также отсортировать их по имени.
-- query 1
select
    parent_name,
    parent_phone
from camp.parent p
inner join camp.child c on p.parent_id = c.parent_id and c.valid_from_date between p.valid_from_date and p.valid_to_date
group by parent_name, parent_phone
having count(c.child_id) >= 2
order by parent_name;

-- вывести название смены, кол-во мальчиков и девочек на этой смене, при этом на смене >1 девочки
-- query 2
select
    s.session_name,
    count(*) filter ( where c.child_gender = 'М' ) as boys_count,
    count(*) filter ( where c.child_gender = 'Ж' ) as girls_count
from camp.child c
full join camp.session_x_child sxc on c.child_id = sxc.child_id
full join camp.session s on sxc.session_id = s.session_id
group by s.session_id
having count(*) filter ( where c.child_gender = 'Ж' ) > 1;

-- вывести смену, имя вожатого, его зарплату и суммарную зарплату всех вожатых на этой смене
-- query 3
select
    s.session_name,
    c.counselor_name,
    sxc.counselor_salary,
    sum(sxc.counselor_salary) over (partition by s.session_id) as total_salary
from camp.session s
inner join camp.session_x_counselor sxc on s.session_id = sxc.session_id
inner join camp.counselor c on c.counselor_id = sxc.counselor_id;

-- вывести имя родителя, временной промежуток, в момент которого у родителя не был указан контакт,
-- длительность этого промежутока, предыдущий контакт и текущий
-- разрыв > 1 дня
-- query 4
select
    parent_name,
    (prev_valid_to_date, prev_parent_phone) as previous_contact,
    (valid_from_date, parent_phone) as current_contact,
    coalesce(valid_from_date - prev_valid_to_date, 0) as days_of_unknown_contact
from (
        select
            *,
            lag(valid_to_date) over (partition by parent_name order by valid_from_date) as prev_valid_to_date,
            lag(parent_phone) over (partition by parent_name order by valid_from_date) as prev_parent_phone
        from camp.parent
     ) t
where make_interval( days := valid_from_date - prev_valid_to_date ) > interval '1 day';

-- тип базы отдыха, количество баз отдыха такого типа и суммарное количество смен,
-- которое проводится на базах отдыха такого типа
-- группируем по типу базы, затем оставляем те, на которых прошло > 1 смены и сортируем записи по типу
-- query 5
select
    rc.centre_type,
    count(distinct(rc.centre_id)) as centres_count,
    count(s.session_id) as sessions_count
from camp.recreation_centre rc
inner join camp.session s on rc.centre_id = s.centre_id
group by rc.centre_type
having count(s.session_id) > 1
order by rc.centre_type;