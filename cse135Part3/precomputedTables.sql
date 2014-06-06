INSERT INTO precomputeProdUser(userID, prodID, sum)
SELECT u.id, p.id, sum(s.quantity*s.price)
FROM products p, users u, sales s
WHERE p.id = s.pid AND u.id = s.uid
GROUP BY p.id, u.id
ORDER BY sum desc;


INSERT INTO precomputeProdState(prodid, stateid, sum)
SELECT p.id, st.id, sum(s.quantity*s.price)
FROM products p,sales s, state st, users u
WHERE p.id = s.pid AND u.id = s.uid AND u.state = st.id
GROUP BY p.id, st.id 
ORDER BY sum desc;

// state no filter
SELECT state.name, sum(precomputeprodstate.sum) 
FROM precomputeprodstate, state 
WHERE precomputeprodstate.stateid = state.id
GROUP BY state.id
ORDER BY state.name; 

// user no filter
SELECT u.name, sum(precomputeproduser.sum) 
FROM precomputeproduser, users u 
WHERE precomputeproduser.userid = u.id
GROUP BY u.id
ORDER BY u.name;

// product no filter
SELECT p.name, sum(precomputeproduser.sum) 
FROM precomputeproduser, products p 
WHERE precomputeproduser.prodid = p.id
GROUP BY p.id
ORDER BY p.name;

// product with state filter
SELECT p.name, sum(precomputeprodstate.sum) 
FROM precomputeprodstate, products p 
WHERE precomputeprodstate.prodid = p.id 
AND precomputeprodstate.stateid = '1'
GROUP BY p.id
ORDER BY p.name;

// product with category filter
SELECT p.name, sum(precomputeproduser.sum) 
FROM precomputeproduser, products p, categories c 
WHERE precomputeproduser.prodid = p.id AND p.cid = c.id AND c.name = 'C1'
GROUP BY p.id
ORDER BY p.name;

// product with state and category filter
SELECT p.name, sum(ps.sum) 
FROM precomputeprodstate ps, state, products p, categories c
WHERE ps.stateid = state.id AND ps.prodid = p.id AND p.cid = c.id AND c.name = 'C1' AND state.name = 'Alabama'
GROUP BY p.name
ORDER BY p.name; 

// user table with state filter
SELECT u.name, sum(pu.sum) 
FROM state, precomputeproduser pu, users u 
WHERE pu.userid = u.id AND u.state = state.id AND u.state = '1'
GROUP BY u.id
ORDER BY u.name;

// user table with category filter
SELECT u.name, sum(precomputeproduser.sum) 
FROM precomputeproduser, users u, products p, categories
WHERE precomputeproduser.userid = u.id AND precomputeproduser.prodid = p.id AND p.cid = categories.id AND categories.name = 'C1'
GROUP BY u.id
ORDER BY u.name;

// user table with state and category filter
SELECT u.name, sum(pu.sum) 
FROM precomputeproduser pu, users u, state, products p, categories c 
WHERE pu.userid = u.id AND pu.prodid = p.id AND p.cid = c.id AND u.state = state.id AND c.name = 'C1' AND state.name = 'Alabama'
GROUP BY u.id
ORDER BY u.name;

//state table with state filter
SELECT state.name, sum(precomputeprodstate.sum) 
FROM state, precomputeprodstate 
WHERE precomputeprodstate.stateid = state.id AND state.name = 'Alabama'
GROUP BY state.id
ORDER BY state.name; 

//state table with category filter
SELECT state.name, sum(precomputeprodstate.sum) 
FROM precomputeprodstate, state, categories, products p
WHERE precomputeprodstate.stateid = state.id AND precomputeprodstate.prodid = p.id AND p.cid = categories.id AND categories.name = 'C5'
GROUP BY state.id
ORDER BY state.name; 

//state table with category and state filter
SELECT state.name, sum(precomputeprodstate.sum) 
FROM state, precomputeprodstate, categories, products p
WHERE precomputeprodstate.stateid = state.id AND precomputeprodstate.prodid = p.id AND p.cid = categories.id AND categories.name = 'C5' AND state.name = 'Alabama'
GROUP BY state.id
ORDER BY state.name; 
