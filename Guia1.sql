create table customers(
    customer_id  integer generated  by default on null as identity constraint customers_pk primary key ,
    email_address  varchar2(255 char) not null constraint customers_email_u unique,
    full_name  varchar2(255 char) not null
);


create table stores (
    store_id integer generated  by default on null as identity constraint stores_pk primary key ,
    store_name varchar2(255 char) constraint store_name_u unique not null,
    web_address varchar2(100 char),
    physical_address varchar2(512 char),
    latitude number,
    longitude number,
    logo blob,
    logo_mime_type varchar2(512 char),
    logo_filename varchar2(512 char),
    logo_charset varchar2(512 char),
    logo_last_updated date,
    constraint store_at_least_one_address_c
                    check ( coalesce( web_address,physical_address) is not null )
);

