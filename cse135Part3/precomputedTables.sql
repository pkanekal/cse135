INSERT INTO precomputeProdUser(userID, prodID, sum)
SELECT u.id, p.id, sum(s.quantity*s.price)
FROM products p, users u, sales s
WHERE p.id = s.pid AND u.id = s.uid
GROUP BY p.id, u.id
ORDER BY sum


INSERT INTO precomputeProdState(userID, prodID, sum)
SELECT p.id, st.id, sum(s.quantity*s.price)
FROM products p,sales s, state st, users u
WHERE p.id = s.pid AND u.id = s.uid AND u.state = st.id
GROUP BY p.id, st.id 
ORDER BY sum desc

SELECT state.name, sum(precomputeprodstate.sum) from precomputeprodstate, state WHERE precomputeprodstate.stid = state.id
GROUP BY state.id
ORDER BY state.name 

SELECT u.name, sum(precomputeproduser.sum) from precomputeproduser, users u WHERE precomputeproduser.userid = u.id
GROUP BY u.id
ORDER BY u.name

SELECT p.name, sum(precomputeproduser.sum) from precomputeproduser, products p WHERE precomputeproduser.prodid = p.id
GROUP BY p.id
ORDER BY p.name


