DROP TABLE users CASCADE;
DROP TABLE categories CASCADE;
DROP TABLE products CASCADE;
DROP TABLE sales CASCADE;
DROP TABLE carts CASCADE;
DROP TABLE precomputeProdUser CASCADE;
DROP TABLE precomputeProdState CASCADE;
DROP TABLE precomputeUsers CASCADE;
DROP TABLE precomputeProducts CASCADE;

DROP INDEX uIndex;
DROP INDEX pIndex;
DROP INDEX pNdx;
DROP INDEX sNdx;
DROP INDEX userIndex;
DROP INDEX productIndex;

CREATE TABLE state (
    id      SERIAL PRIMARY KEY,
    name    TEXT UNIQUE NOT NULL
);

CREATE TABLE users (
    id          SERIAL PRIMARY KEY,
    name        TEXT NOT NULL UNIQUE,
    role        TEXT NOT NULL,
    age   	INTEGER NOT NULL,
    state  	INTEGER REFERENCES state (id) ON DELETE CASCADE
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

CREATE TABLE carts (
    id          SERIAL PRIMARY KEY,
    uid         INTEGER REFERENCES users (id) ON DELETE CASCADE,
    pid         INTEGER REFERENCES products (id) ON DELETE CASCADE,
    quantity    INTEGER NOT NULL,
    price	INTEGER NOT NULL
);


CREATE INDEX userIndex ON sales(uid);
CREATE INDEX productIndex ON sales(pid);

CREATE TABLE precomputeProdUser (
    id       SERIAL PRIMARY KEY,
    userID   INTEGER REFERENCES users (id) ON DELETE CASCADE,
    prodID   INTEGER REFERENCES products (id) ON DELETE CASCADE,
    sum      INTEGER NOT NULL
);

CREATE TABLE precomputeProdState (
	id	SERIAL PRIMARY KEY,
	stateID  INTEGER REFERENCES state (id) ON DELETE CASCADE,
	prodID  INTEGER REFERENCES products (id) ON DELETE CASCADE,
	sum     INTEGER NOT NULL
);

CREATE TABLE precomputeUsers (
	id	SERIAL PRIMARY KEY,
	userID  INTEGER REFERENCES users (id) ON DELETE CASCADE,
	sum     INTEGER NOT NULL
);

CREATE TABLE precomputeProducts (
	id	SERIAL PRIMARY KEY,
	productID  INTEGER REFERENCES products (id) ON DELETE CASCADE,
	sum     INTEGER NOT NULL
);

INSERT INTO precomputeProdUser(userID, prodID, sum)
SELECT u.id, p.id, sum(s.quantity*s.price)
FROM products p, users u, sales s
WHERE p.id = s.pid AND u.id = s.uid
GROUP BY p.id, u.id
ORDER BY sum desc;

CREATE INDEX uIndex ON precomputeProdUser(userID);
CREATE INDEX pIndex ON precomputeProdUser(productID);

INSERT INTO precomputeProdState(prodid, stateid, sum)
SELECT p.id, st.id, sum(s.quantity*s.price)
FROM products p,sales s, state st, users u
WHERE p.id = s.pid AND u.id = s.uid AND u.state = st.id
GROUP BY p.id, st.id 
ORDER BY sum desc;

CREATE INDEX pNdx ON precomputeProdState(prodid);
CREATE INDEX sNdx ON precomputeProdState(stateid);

INSERT INTO precomputeUsers(userID, sum)
SELECT pu.userid, sum(pu.sum) 
FROM precomputeproduser pu
GROUP BY pu.userid 
ORDER BY sum desc;

INSERT INTO precomputeProducts(productID, sum)
SELECT pu.prodid, sum(pu.sum) 
FROM precomputeproduser pu
GROUP BY pu.prodid 
ORDER BY sum desc;

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

