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


create table products(
    product_id integer generated  by default on null as identity constraint products_pk primary key ,
    product_name varchar2(255 char) not null,
    unit_price number(10,2),
    product_details blob constraint products_json_c check ( product_details is json ),
    product_image blob,
    image_mime_type varchar2(512 char),
    image_filename varchar2(512 char),
    image_charset varchar2(512 char),
    image_last_updated date

);


create table orders (
    order_id integer generated  by default on null as identity constraint orders_pk primary key ,
    order_datetime timestamp not null,
    customer_id integer constraint orders_customer_id_fk references CUSTOMERS not null,
    order_status varchar2(10 char) constraint orders_status_c check
        ( order_status in ('CANCELLED' , 'COMPLETE','OPEN','PAID','REFUNDED','SHIPPED') ) not null,
    store_id integer constraint orders_store_id_fk references STORES not null
);



create table order_items (
    order_id  integer constraint order_items_order_id_fk references ORDERS,
    line_item_id integer,
    product_id integer constraint order_items_product_id_fk references PRODUCTS not null,
    unit_price number(10,2) not null,
    quantity integer not null,
    constraint order_items_pk primary key (order_id,line_item_id),
    constraint order_items_product_u unique (product_id,order_id)

  );


  -- creacion de indices
  create index customers_name_i on CUSTOMERS(FULL_NAME);
create index orders_customers_id_i on ORDERS (CUSTOMER_ID);
create index orders_store_id_i on ORDERS(STORE_ID);


    ------------ CONSULTAS


-- 1.   Obtener el top 5 de tiendas con más ordenes en 2018
    SELECT * FROM (
    SELECT STORE_NAME, EXTRACT(YEAR FROM ORDER_DATETIME) DT, COUNT(*) ORDER# FROM ORDERS O
    INNER JOIN STORES S ON O.STORE_ID = S.STORE_ID
    WHERE EXTRACT(YEAR FROM ORDER_DATETIME)=2018 
    GROUP BY STORE_NAME,  EXTRACT(YEAR FROM ORDER_DATETIME)
    ORDER BY COUNT(*) DESC)
WHERE ROWNUM <=5;

--2.  Obtener la tienda con menos ordenes en 2019

SELECT * FROM (
    SELECT STORE_NAME, EXTRACT(YEAR FROM ORDER_DATETIME) DT, COUNT(*) ORDER# FROM ORDERS O
    INNER JOIN STORES S ON O.STORE_ID = S.STORE_ID
    WHERE EXTRACT(YEAR FROM ORDER_DATETIME)=2019
    GROUP BY STORE_NAME,  EXTRACT(YEAR FROM ORDER_DATETIME)
    ORDER BY COUNT(*) )
WHERE ROWNUM <=1;