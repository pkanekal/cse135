CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    role TEXT,
    age TEXT,
   state TEXT
);

CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
   name TEXT NOT NULL UNIQUE,
   description TEXT
);

CREATE TABLE products(
   id SERIAL PRIMARY KEY,
  SKU TEXT UNIQUE,
  category TEXT REFERENCES categories(NAME) NOT NULL,
 productname TEXT,
  price TEXT
 );

CREATE TABLE shoppingcart (
id SERIAL PRIMARY KEY, customer TEXT  REFERENCES users(name),
product TEXT REFERENCES products(sku),
quantity INTEGER);
