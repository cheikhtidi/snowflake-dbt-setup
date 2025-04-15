--use the accountadmin role to execute the following script within snwowflake
--create a database raw and schemas jaffle_shop and stripe
create database raw;
create schema raw.jaffle_shop;
create schema raw.stripe;

--create the table definition for the the table jaffle_shop.customers
create table raw.jaffle_shop.customers 
( id integer,
  first_name varchar,
  last_name varchar
);

--load the data from the csv file into the table jaffle_shop.customers
--the csv file is stored in an s3 bucket and the snowflake account has access to it
copy into raw.jaffle_shop.customers (id, first_name, last_name)
from 's3://dbt-tutorial-public/jaffle_shop_customers.csv'
file_format = (
    type = 'CSV'
    field_delimiter = ','
    skip_header = 1
    );

--create the table definition for the the table jaffle_shop.orders
create table raw.jaffle_shop.orders
( id integer,
  user_id integer,
  order_date date,
  status varchar,
  _etl_loaded_at timestamp default current_timestamp
);

--load the data from the csv file into the table jaffle_shop.orders
--the csv file is stored in an s3 bucket and the snowflake account has access to it
copy into raw.jaffle_shop.orders (id, user_id, order_date, status)
from 's3://dbt-tutorial-public/jaffle_shop_orders.csv'
file_format = (
    type = 'CSV'
    field_delimiter = ','
    skip_header = 1
    );


--create the table definition for the the table stripe.payment
create table raw.stripe.payment 
( id integer,
  orderid integer,
  paymentmethod varchar,
  status varchar,
  amount integer,
  created date,
  _batched_at timestamp default current_timestamp
);

--load the data from the csv file into the table stripe.payment
--the csv file is stored in an s3 bucket and the snowflake account has access to it
copy into raw.stripe.payment (id, orderid, paymentmethod, status, amount, created)
from 's3://dbt-tutorial-public/stripe_payments.csv'
file_format = (
    type = 'CSV'
    field_delimiter = ','
    skip_header = 1
    );

--verify the data loaded into the tables
--select the data from the tables to verify the data loaded correctly
select * from raw.jaffle_shop.customers;
select * from raw.jaffle_shop.orders;
select * from raw.stripe.payment;