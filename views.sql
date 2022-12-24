-- task 7

drop schema if exists camp_views cascade;
create schema camp_views;

drop view if exists camp_views.parents;
create view camp_views.parents as (
select
    overlay(p.parent_name placing '**********' from 2 for 50) as name,
    overlay(p.parent_phone placing '**********' from 3 for 50) as phone_number,
    overlay(p.valid_from_date::text placing '****-**-**' from 1) as valid_from_date,
    overlay(p.valid_to_date::text placing '****-**-**' from 1) as valid_to_date
from
    camp.parent p
);
select * from camp_views.parents;

drop view if exists camp_views.children;
create view camp_views.children as (
select
    overlay(c.child_name placing '**********' from 2 for 50) as name,
    overlay(c.child_gender placing '*' from 1) as gender,
    overlay(c.child_age::text placing '**' from 1) as age
from
    camp.child c
);
select * from camp_views.children;

drop view if exists camp_views.directors;
create view camp_views.directors as (
select
    overlay(d.director_name placing '**********' from 2 for 50) as name,
    overlay(d.director_age::text placing '**' from 1) as age,
    overlay(d.director_phone::text placing '**********' from 3 for 50) as phone_number
from
    camp.director d
);
select * from camp_views.directors;

drop view if exists camp_views.recreation_centres;
create view camp_views.recreation_centres as (
select
    rc.centre_name,
    overlay(rc.centre_location placing '******' from 1 for 50) as location,
    overlay(rc.centre_type placing '*****' from 1 for 50) as type
from
    camp.recreation_centre rc
);
select * from camp_views.recreation_centres;

drop view if exists camp_views.sessions;
create view camp_views.sessions as (
select
    s.session_name,
    s.session_duration,
    overlay(s.session_price::text placing '*****' from 1 for 50) as session_price
from
    camp.session s
);
select * from camp_views.sessions;

drop view if exists camp_views.counselors;
create view camp_views.counselors as (
select
    overlay(c.counselor_name placing '**********' from 2 for 50) as name,
    overlay(c.counselor_age::text placing '**' from 1) as age,
    overlay(c.counselor_phone::text placing '**********' from 3 for 50) as phone_number
from
    camp.counselor c
);
select * from camp_views.counselors;

drop view if exists camp_views.doctors;
create view camp_views.doctors as (
select
    overlay(d.doctor_name placing '**********' from 2 for 50) as name,
    overlay(d.doctor_phone::text placing '**********' from 3 for 50) as phone_number
from
    camp.doctor d
);
select * from camp_views.doctors;

drop view if exists camp_views.sessions_x_children;
create view camp_views.sessions_x_children as (
select
    sxc.session_id,
    sxc.child_id,
    overlay(sxc.voucher_id::text placing '**********' from 1 for 1000) as voucher_id
from
    camp.session_x_child sxc
);
select * from camp_views.sessions_x_children;

drop view if exists camp_views.counselors_x_children;
create view camp_views.counselors_x_children as (
select
    *
from
    camp.counselor_x_child cxc
);
select * from camp_views.counselors_x_children;

drop view if exists camp_views.sessions_x_counselors;
create view camp_views.sessions_x_counselors as (
select
    sxc.session_id,
    sxc.counselor_id,
    overlay(sxc.counselor_salary::text placing '*******' from 1 for 50) as counselor_salary
from
    camp.session_x_counselor sxc
);
select * from camp_views.sessions_x_counselors;

