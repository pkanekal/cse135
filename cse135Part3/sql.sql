﻿DROP TABLE users CASCADE;
DROP TABLE categories CASCADE;
DROP TABLE products CASCADE;
DROP TABLE sales CASCADE;

CREATE TABLE users (
    id          SERIAL PRIMARY KEY,
    name        TEXT NOT NULL UNIQUE,
    role        TEXT NOT NULL,
    age   	INTEGER NOT NULL,
    state  	TEXT NOT NULL
);

CREATE TABLE categories (
    id          SERIAL PRIMARY KEY,
    name        TEXT NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE products (
    id          SERIAL PRIMARY KEY,
    cid         INTEGER REFERENCES categories (id) ON DELETE CASCADE,
    name        TEXT NOT NULL,
    SKU         TEXT NOT NULL UNIQUE,
    price       INTEGER NOT NULL
);

CREATE TABLE sales (
    id          SERIAL PRIMARY KEY,
    uid         INTEGER REFERENCES users (id) ON DELETE CASCADE,
    pid         INTEGER REFERENCES products (id) ON DELETE CASCADE,
    quantity    INTEGER NOT NULL,
    price	INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS state (
    id      SERIAL PRIMARY KEY,
    name    TEXT UNIQUE NOT NULL
);

CREATE INDEX userIndex ON (sales.uid);
CREATE INDEX products ON (sales.pid);

CREATE TABLE precomputeProdUser (
    id       SERIAL PRIMARY KEY,
    userID   INTEGER REFERENCES users (id) ON DELETE CASCADE,
    prodID   INTEGER REFERENCES products (id) ON DELETE CASCADE,
    sum      INTEGER NOT NULL
)

CREATE TABLE precomputeCategoryUser (
	id	SERIAL PRIMARY KEY,
	userID  INTEGER REFERENCES users (id) ON DELETE CASCADE,
	cid	INTEGER REFERENCES categories (id) ON DELETE CASCADE,
	sum     INTEGER NOT NULL
)

INSERT INTO precomputeProdUser(userID, prodID, sum)
SELECT u.id, p.id, sum(s.quantity*s.price)
FROM products p, users u, sales s
WHERE p.id = s.pid AND u.id = s.uid
GROUP BY p.id, u.id
ORDER BY u.id


INSERT INTO precomputeCategoryUser(userID, cid, sum)
SELECT u.id, c.id, sum(s.quantity*s.price)
FROM categories c, users u, products p, sales s
WHERE c.id = p.cid AND u.id = s.uid
GROUP BY c.id, u.id
ORDER BY u.id 

INSERT INTO state(name)
VALUES
('Alabama'),
('Alaska'),
('Arizona'),
('Arkansas'),
('California'),
('Colorado'),
('Connecticut'),
('Delaware'),
('Florida'),
('Georgia'),
('Hawaii'),
('Idaho'),
('Illinois'),
('Indiana'),
('Iowa'),
('Kansas'),
('Kentucky'),
('Louisiana'),
('Maine'),
('Maryland'),
('Massachusetts'),
('Michigan'),
('Minnesota'),
('Mississippi'),
('Missouri'),
('Montana'),
('Nebraska'),
('Nevada'),
('New Hampshire'),
('New Jersey'),
('New Mexico'),
('New York'),
('North Carolina'),
('North Dakota'),
('Ohio'),
('Oklahoma'),
('Oregon'),
('Pennsylvania'),
('Rhode Island'),
('South Carolina'),
('South Dakota'),
('Tennessee'),
('Texas'),
('Utah'),
('Vermont'),
('Virginia'),
('Washington'),
('West Virginia'),
('Wisconsin'),
('Wyoming');
