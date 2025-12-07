///////////////////////////////////////////////////////////////////////////
// MODULE 0 — RESET
///////////////////////////////////////////////////////////////////////////

MATCH (n) DETACH DELETE n;

///////////////////////////////////////////////////////////////////////////
// MODULE 1 — SOCIAL + BOOK GRAPH
///////////////////////////////////////////////////////////////////////////

//////////////////////////////
// 1A — Create nodes
//////////////////////////////

// People
CREATE (:Person {name:'Alice', age:30});
CREATE (:Person {name:'Bob', age:28});
CREATE (:Person {name:'Carol', age:35});
CREATE (:Person {name:'Dave', age:22});
CREATE (:Person {name:'Ellen', age:41});
CREATE (:Person {name:'Frank', age:27});

// Authors
CREATE (:Author {name:'Martin Fowler'});
CREATE (:Author {name:'Michael Hunger'});
CREATE (:Author {name:'Sam Newman'});
CREATE (:Author {name:'Neal Ford'});

// Genres
CREATE (:Genre {name:'Technology'});
CREATE (:Genre {name:'Databases'});
CREATE (:Genre {name:'Software Architecture'});
CREATE (:Genre {name:'Programming'});

// Books
CREATE (:Book {title:'Graph Databases', year:2020});
CREATE (:Book {title:'Cypher 101', year:2021});
CREATE (:Book {title:'Microservices Patterns', year:2019});
CREATE (:Book {title:'Refactoring', year:2018});
CREATE (:Book {title:'Clean Code', year:2010});
CREATE (:Book {title:'Data Modeling for Beginners', year:2022});


//////////////////////////////
// 1B — Create relationships via MATCH
//////////////////////////////

// Authorship
MATCH (a:Author {name:'Michael Hunger'}), (b:Book {title:'Graph Databases'})
CREATE (a)-[:AUTHORED]->(b);
MATCH (a:Author {name:'Michael Hunger'}), (b:Book {title:'Cypher 101'})
CREATE (a)-[:AUTHORED]->(b);
MATCH (a:Author {name:'Sam Newman'}), (b:Book {title:'Microservices Patterns'})
CREATE (a)-[:AUTHORED]->(b);
MATCH (a:Author {name:'Martin Fowler'}), (b:Book {title:'Refactoring'})
CREATE (a)-[:AUTHORED]->(b);
MATCH (a:Author {name:'Neal Ford'}), (b:Book {title:'Data Modeling for Beginners'})
CREATE (a)-[:AUTHORED]->(b);

// Genre tags
MATCH (b:Book {title:'Graph Databases'}), (g:Genre {name:'Databases'})
CREATE (b)-[:IN_GENRE]->(g);
MATCH (b:Book {title:'Cypher 101'}), (g:Genre {name:'Databases'})
CREATE (b)-[:IN_GENRE]->(g);
MATCH (b:Book {title:'Microservices Patterns'}), (g:Genre {name:'Software Architecture'})
CREATE (b)-[:IN_GENRE]->(g);
MATCH (b:Book {title:'Refactoring'}), (g:Genre {name:'Programming'})
CREATE (b)-[:IN_GENRE]->(g);
MATCH (b:Book {title:'Clean Code'}), (g:Genre {name:'Programming'})
CREATE (b)-[:IN_GENRE]->(g);
MATCH (b:Book {title:'Data Modeling for Beginners'}), (g:Genre {name:'Databases'})
CREATE (b)-[:IN_GENRE]->(g);

// Reading activity
MATCH (p:Person {name:'Alice'}), (b:Book {title:'Graph Databases'})
CREATE (p)-[:READ]->(b);
MATCH (p:Person {name:'Alice'}), (b:Book {title:'Refactoring'})
CREATE (p)-[:READ]->(b);
MATCH (p:Person {name:'Bob'}), (b:Book {title:'Graph Databases'})
CREATE (p)-[:READ]->(b);
MATCH (p:Person {name:'Bob'}), (b:Book {title:'Cypher 101'})
CREATE (p)-[:READ]->(b);
MATCH (p:Person {name:'Carol'}), (b:Book {title:'Microservices Patterns'})
CREATE (p)-[:READ]->(b);
MATCH (p:Person {name:'Carol'}), (b:Book {title:'Clean Code'})
CREATE (p)-[:READ]->(b);
MATCH (p:Person {name:'Dave'}), (b:Book {title:'Graph Databases'})
CREATE (p)-[:READ]->(b);
MATCH (p:Person {name:'Dave'}), (b:Book {title:'Data Modeling for Beginners'})
CREATE (p)-[:READ]->(b);
MATCH (p:Person {name:'Ellen'}), (b:Book {title:'Clean Code'})
CREATE (p)-[:READ]->(b);
MATCH (p:Person {name:'Frank'}), (b:Book {title:'Microservices Patterns'})
CREATE (p)-[:READ]->(b);

// Social graph
MATCH (a:Person {name:'Alice'}), (b:Person {name:'Bob'})
CREATE (a)-[:FRIENDS_WITH]->(b);
MATCH (b:Person {name:'Bob'}), (c:Person {name:'Carol'})
CREATE (b)-[:FRIENDS_WITH]->(c);
MATCH (c:Person {name:'Carol'}), (e:Person {name:'Ellen'})
CREATE (c)-[:FRIENDS_WITH]->(e);
MATCH (e:Person {name:'Ellen'}), (f:Person {name:'Frank'})
CREATE (e)-[:FRIENDS_WITH]->(f);
MATCH (d:Person {name:'Dave'}), (a:Person {name:'Alice'})
CREATE (d)-[:FRIENDS_WITH]->(a);



///////////////////////////////////////////////////////////////////////////
// MODULE 2 — E-COMMERCE GRAPH
///////////////////////////////////////////////////////////////////////////

//////////////////////////////
// 2A — Create nodes
//////////////////////////////

// Customers
CREATE (:Customer {name:'Alex'});
CREATE (:Customer {name:'Beatrice'});
CREATE (:Customer {name:'Chris'});
CREATE (:Customer {name:'Diana'});
CREATE (:Customer {name:'Evan'});

// Products
CREATE (:Product {name:'Laptop', price:1200});
CREATE (:Product {name:'Mouse', price:25});
CREATE (:Product {name:'Mechanical Keyboard', price:150});
CREATE (:Product {name:'USB-C Cable', price:10});
CREATE (:Product {name:'Standing Desk', price:350});

// Categories
CREATE (:Category {name:'Computers'});
CREATE (:Category {name:'Accessories'});
CREATE (:Category {name:'Office Furniture'});


//////////////////////////////
// 2B — Create relationships via MATCH
//////////////////////////////

// Category assignments
MATCH (p:Product {name:'Laptop'}), (c:Category {name:'Computers'})
CREATE (p)-[:IN_CATEGORY]->(c);
MATCH (p:Product {name:'Mouse'}), (c:Category {name:'Accessories'})
CREATE (p)-[:IN_CATEGORY]->(c);
MATCH (p:Product {name:'Mechanical Keyboard'}), (c:Category {name:'Accessories'})
CREATE (p)-[:IN_CATEGORY]->(c);
MATCH (p:Product {name:'USB-C Cable'}), (c:Category {name:'Accessories'})
CREATE (p)-[:IN_CATEGORY]->(c);
MATCH (p:Product {name:'Standing Desk'}), (c:Category {name:'Office Furniture'})
CREATE (p)-[:IN_CATEGORY]->(c);

// Purchases
MATCH (c:Customer {name:'Alex'}), (p:Product {name:'Laptop'})
CREATE (c)-[:PURCHASED {date:'2024-01-12'}]->(p);
MATCH (c:Customer {name:'Alex'}), (p:Product {name:'Mouse'})
CREATE (c)-[:PURCHASED {date:'2024-01-12'}]->(p);
MATCH (c:Customer {name:'Beatrice'}), (p:Product {name:'Mechanical Keyboard'})
CREATE (c)-[:PURCHASED {date:'2024-01-15'}]->(p);
MATCH (c:Customer {name:'Chris'}), (p:Product {name:'Mouse'})
CREATE (c)-[:PURCHASED {date:'2024-01-20'}]->(p);
MATCH (c:Customer {name:'Chris'}), (p:Product {name:'Standing Desk'})
CREATE (c)-[:PURCHASED {date:'2024-02-01'}]->(p);
MATCH (c:Customer {name:'Diana'}), (p:Product {name:'USB-C Cable'})
CREATE (c)-[:PURCHASED {date:'2024-03-01'}]->(p);
MATCH (c:Customer {name:'Evan'}), (p:Product {name:'Mechanical Keyboard'})
CREATE (c)-[:PURCHASED {date:'2024-03-12'}]->(p);
MATCH (c:Customer {name:'Evan'}), (p:Product {name:'Standing Desk'})
CREATE (c)-[:PURCHASED {date:'2024-03-12'}]->(p);



///////////////////////////////////////////////////////////////////////////
// MODULE 3 — FRAUD GRAPH
///////////////////////////////////////////////////////////////////////////

// Accounts
UNWIND range(1,10) AS n
CREATE (:Account {id:'ACC'+n});

// Transfers
MATCH (a1:Account {id:'ACC1'}), (a2:Account {id:'ACC2'})
CREATE (a1)-[:TRANSFERS {amount:400}]->(a2);
MATCH (a3:Account {id:'ACC3'}), (a2:Account {id:'ACC2'})
CREATE (a3)-[:TRANSFERS {amount:500}]->(a2);
MATCH (a4:Account {id:'ACC4'}), (a2:Account {id:'ACC2'})
CREATE (a4)-[:TRANSFERS {amount:450}]->(a2);

// Loop
MATCH (a5:Account {id:'ACC5'}),
      (a6:Account {id:'ACC6'}),
      (a7:Account {id:'ACC7'}),
      (a8:Account {id:'ACC8'})
CREATE (a5)-[:TRANSFERS {amount:2000}]->(a6),
       (a6)-[:TRANSFERS {amount:2000}]->(a7),
       (a7)-[:TRANSFERS {amount:2000}]->(a8),
       (a8)-[:TRANSFERS {amount:2000}]->(a5);



///////////////////////////////////////////////////////////////////////////
// MODULE 4 — KNOWLEDGE GRAPH
///////////////////////////////////////////////////////////////////////////

// Nodes
CREATE (:Topic {name:'Graphs'});
CREATE (:Topic {name:'Databases'});
CREATE (:Topic {name:'Cypher'});
CREATE (:Topic {name:'Data Modeling'});
CREATE (:Topic {name:'Machine Learning'});
CREATE (:Topic {name:'Neural Networks'});
CREATE (:Topic {name:'Software Architecture'});
CREATE (:Topic {name:'Programming Languages'});

// Relationships
MATCH (a:Topic {name:'Graphs'}), (b:Topic {name:'Databases'})
CREATE (a)-[:RELATED_TO]->(b);
MATCH (a:Topic {name:'Graphs'}), (b:Topic {name:'Cypher'})
CREATE (a)-[:RELATED_TO]->(b);
MATCH (a:Topic {name:'Cypher'}), (b:Topic {name:'Programming Languages'})
CREATE (a)-[:RELATED_TO]->(b);
MATCH (a:Topic {name:'Data Modeling'}), (b:Topic {name:'Graphs'})
CREATE (a)-[:RELATED_TO]->(b);
MATCH (a:Topic {name:'Machine Learning'}), (b:Topic {name:'Neural Networks'})
CREATE (a)-[:RELATED_TO]->(b);
MATCH (a:Topic {name:'Neural Networks'}), (b:Topic {name:'Software Architecture'})
CREATE (a)-[:RELATED_TO]->(b);
MATCH (a:Topic {name:'Software Architecture'}), (b:Topic {name:'Cypher'})
CREATE (a)-[:RELATED_TO]->(b);



///////////////////////////////////////////////////////////////////////////
// MODULE 5 — ORG CHART + SKILLS
///////////////////////////////////////////////////////////////////////////

// Employees
CREATE (:Employee {name:'Sara', role:'Manager'});
CREATE (:Employee {name:'Tom', role:'Engineer'});
CREATE (:Employee {name:'Lila', role:'Engineer'});
CREATE (:Employee {name:'Mike', role:'Data Scientist'});
CREATE (:Employee {name:'Nina', role:'Designer'});

// Skills
CREATE (:Skill {name:'Python'});
CREATE (:Skill {name:'Machine Learning'});
CREATE (:Skill {name:'UI Design'});
CREATE (:Skill {name:'Cloud Architecture'});
CREATE (:Skill {name:'Neo4j'});

// Management relationships
MATCH (m:Employee {name:'Sara'}), (e:Employee {name:'Tom'})
CREATE (m)-[:MANAGES]->(e);
MATCH (m:Employee {name:'Sara'}), (e:Employee {name:'Lila'})
CREATE (m)-[:MANAGES]->(e);
MATCH (m:Employee {name:'Sara'}), (e:Employee {name:'Mike'})
CREATE (m)-[:MANAGES]->(e);

// Collaboration
MATCH (a:Employee {name:'Tom'}), (b:Employee {name:'Lila'})
CREATE (a)-[:COLLABORATES_WITH]->(b);
MATCH (a:Employee {name:'Mike'}), (b:Employee {name:'Nina'})
CREATE (a)-[:COLLABORATES_WITH]->(b);

// Skills
MATCH (e:Employee {name:'Tom'}), (s:Skill {name:'Python'})
CREATE (e)-[:HAS_SKILL]->(s);
MATCH (e:Employee {name:'Mike'}), (s:Skill {name:'Python'})
CREATE (e)-[:HAS_SKILL]->(s);
MATCH (e:Employee {name:'Mike'}), (s:Skill {name:'Machine Learning'})
CREATE (e)-[:HAS_SKILL]->(s);
MATCH (e:Employee {name:'Nina'}), (s:Skill {name:'UI Design'})
CREATE (e)-[:HAS_SKILL]->(s);
MATCH (e:Employee {name:'Lila'}), (s:Skill {name:'Neo4j'})
CREATE (e)-[:HAS_SKILL]->(s);
MATCH (e:Employee {name:'Tom'}), (s:Skill {name:'Neo4j'})
CREATE (e)-[:HAS_SKILL]->(s);

///////////////////////////////////////////////////////////////////////////
// MODULE 6 — QUERY PACK
///////////////////////////////////////////////////////////////////////////

//////////////////////////////
// 6.1 — SOCIAL + BOOK GRAPH
//////////////////////////////

// 6.1.1 — Books Alice read
MATCH (:Person {name:'Alice'})-[:READ]->(b:Book)
RETURN b.title AS booksAliceRead;

// 6.1.2 — Most popular books
MATCH (p:Person)-[:READ]->(b:Book)
RETURN b.title AS book, COUNT(p) AS readers
ORDER BY readers DESC
LIMIT 10;

// 6.1.3 — Book recommendations for Alice
MATCH (me:Person {name:'Alice'})-[:READ]->(b1)<-[:READ]-(other)-[:READ]->(b2)
WHERE NOT (me)-[:READ]->(b2)
RETURN DISTINCT b2.title AS recommendedBook;

// 6.1.3 — Genres each person reads
MATCH (p:Person)-[:READ]->(:Book)-[:IN_GENRE]->(g:Genre)
RETURN p.name AS person, COLLECT(DISTINCT g.name) AS genresRead;


//////////////////////////////
// 6.2 — E-COMMERCE GRAPH
//////////////////////////////

// 6.2.1 — Customers who bought the same product
MATCH (c1:Customer)-[:PURCHASED]->(p:Product)<-[:PURCHASED]-(c2:Customer)
WHERE c1 <> c2
RETURN c1.name AS customer, p.name AS product, c2.name AS similarCustomer;

// 6.2.2 — Top-selling products
MATCH (c:Customer)-[:PURCHASED]->(p:Product)
RETURN p.name AS product, COUNT(c) AS unitsSold
ORDER BY unitsSold DESC;

// 6.2.3 — Product sales by category
MATCH (c:Customer)-[:PURCHASED]->(p:Product)-[:IN_CATEGORY]->(cat:Category)
RETURN cat.name AS category, p.name AS product, COUNT(c) AS purchases
ORDER BY category, purchases DESC;

// 6.2.4 — Customers with similar buying categories
MATCH (c1:Customer)-[:PURCHASED]->(:Product)-[:IN_CATEGORY]->(cat)<-[:IN_CATEGORY]-(:Product)<-[:PURCHASED]-(c2:Customer)
WHERE c1 <> c2
RETURN DISTINCT c1.name AS customer, c2.name AS similarCustomer, cat.name AS category;


//////////////////////////////
// 6.3 — KNOWLEDGE GRAPH
//////////////////////////////

// 6.3.1 — Direct related topics
MATCH (t:Topic {name:'Graphs'})-[:RELATED_TO]->(rel)
RETURN rel.name AS relatedTopics;

// 6.3.2 — Two-hop topic exploration
MATCH (:Topic {name:'Cypher'})-[:RELATED_TO*1..2]->(other)
RETURN DISTINCT other.name AS topic;

// 6.3.3 — Topic paths
MATCH path = (a:Topic {name:'Graphs'})-[:RELATED_TO*..3]->(b:Topic)
RETURN path
LIMIT 10;


//////////////////////////////
// 6.4 — ORG CHART + SKILLS
//////////////////////////////

// 6.4.1 — Employees and skills
MATCH (e:Employee)-[:HAS_SKILL]->(s:Skill)
RETURN e.name AS employee, COLLECT(s.name) AS skills;

// 6.4.2 — Sara’s direct reports
MATCH (:Employee {name:'Sara'})-[:MANAGES]->(e:Employee)
RETURN e.name AS directReports;

// 6.4.3 — Employee collaborations
MATCH (e1:Employee)-[:COLLABORATES_WITH]->(e2:Employee)
RETURN e1.name AS employee, e2.name AS collaborator;

// 6.4.4 — Neo4j experts
MATCH (e:Employee)-[:HAS_SKILL]->(:Skill {name:'Neo4j'})
RETURN e.name AS neo4jExperts;

// 6.4.5 — Cross-functional team candidates
MATCH (py:Employee)-[:HAS_SKILL]->(:Skill {name:'Python'}),
      (ml:Employee)-[:HAS_SKILL]->(:Skill {name:'Machine Learning'}),
      (ui:Employee)-[:HAS_SKILL]->(:Skill {name:'UI Design'})
RETURN py.name AS pythonDev, ml.name AS mlDev, ui.name AS designer;


//////////////////////////////
// 6.5 — FRAUD DETECTION
//////////////////////////////

// 6.5.1 — Mule detection: many incoming transfers
MATCH (src:Account)-[:TRANSFERS]->(dest:Account)
WITH dest, COUNT(src) AS sends
WHERE sends >= 3
RETURN dest.id AS muleCandidate, sends;

// 6.5.2 — Circular laundering rings
MATCH p = (a:Account)-[:TRANSFERS*3..6]->(a)
RETURN p
LIMIT 5;

// 6.5.3 — Large transfers
MATCH (a1:Account)-[t:TRANSFERS]->(a2:Account)
WHERE t.amount >= 1000
RETURN a1.id AS from, a2.id AS to, t.amount AS amount;