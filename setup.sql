-- Run the following line in the terminal:
-- psql -U freecodecamp -d postgres -f ./setup.sql
-- =~==~=~~=~=~=~=~=~=~==~=~=~=~=~=~=~=~~=~=

-- connect to postgres
\c postgres;

-- drop database if exists
DROP DATABASE IF EXISTS salon;

-- You should create a database named salon
CREATE DATABASE salon;

-- You should connect to your database, 
\c salon;

-- then create tables named customers, appointments, and services
CREATE TABLE customers (
  customer_id SERIAL PRIMARY KEY
);

CREATE TABLE appointments (
  appointment_id SERIAL PRIMARY KEY
);

CREATE TABLE services (
  service_id SERIAL PRIMARY KEY
);

-- Your appointments table should have a customer_id foreign key that
-- references the customer_id column from the customers table
ALTER TABLE appointments
ADD COLUMN customer_id INT,
ADD CONSTRAINT fk_customer
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);

-- Your appointments table should have a service_id foreign key that
-- references the service_id column from the services table
ALTER TABLE appointments
ADD COLUMN service_id INT,
ADD CONSTRAINT fk_service
FOREIGN KEY (service_id)
REFERENCES services(service_id);

-- Your customers table should have phone that is a VARCHAR and must be unique
ALTER TABLE customers
ADD COLUMN phone VARCHAR(15) UNIQUE;

-- Your customers and services tables should have a name column
ALTER TABLE customers
ADD COLUMN name VARCHAR(30);
ALTER TABLE services
ADD COLUMN name VARCHAR(30);

-- Your appointments table should have a time column that is a VARCHAR
ALTER TABLE appointments
ADD COLUMN time VARCHAR;

-- You should have at least three rows in your services table 
-- for the different services you offer, one with a service_id of 1
INSERT INTO services(name)
VALUES
('haircut'),
('hair coloring'),
('makeup');

-- add available column to services to make the query easier
ALTER TABLE services
ADD COLUMN available BOOLEAN
DEFAULT true;