# Advanced Database Systems Portfolio (MIT 8103)

**Name:** Winnie Ibiso Davis
**Course:** MIT 8103 Advanced Database Systems, MIVA Open University
**Session:** 2026/2027, First Semester Continuous Assessment

## Selected case study

I chose a **City University Library Management System**. It is used
by librarians and members to manage books and borrowing.

- **Users:** librarians (staff) and library members
- **Data stored:** books, members, staff, loans and fines
- **Main operations:** borrow a book, return a book, calculate fines
  and search the catalogue

I used this same case study in all five portfolio activities.

## Tools I used

- PostgreSQL 17 and pgAdmin (relational database, Parts 1 to 3)
- MongoDB Atlas (free cluster) and MongoDB Compass (Parts 4 and 5)
- GitHub Desktop (to commit my work as I went)
- Claude, as a learning aid (see the AI use declaration below)

## Repository structure

```
winnie-ibiso-davis-advanced-database-portfolio/
├── portfolio-1-database-design/
├── portfolio-2-query-optimisation/
├── portfolio-3-transactions-concurrency/
├── portfolio-4-nosql/
├── portfolio-5-distributed-cloud/
└── README.md
```

Each folder has its own README that explains what I did and how I
tested it.

## What is in each part

**Portfolio 1: Database design and modelling**
I designed five tables (members, staff, books, loans, fines) in
PostgreSQL with primary keys, foreign keys and constraints. The folder
has the schema script, the ER diagram and my normalisation
explanation (3NF).

**Portfolio 2: Query processing and optimisation**
I loaded test data (1,000 members, 500 books, 100,000 loans) and wrote
five queries. I used EXPLAIN ANALYZE to compare a search on loans
before and after adding an index. The time dropped from about 21.5 ms
to about 1.3 ms.

**Portfolio 3: Transactions and concurrency**
I showed COMMIT and ROLLBACK using the borrow-a-book process, a
failed transaction caused by a CHECK constraint, and a row lock
(SELECT ... FOR UPDATE) that stops two users taking the last copy of a
book. I also checked the isolation level.

**Portfolio 4: NoSQL and advanced data models**
I modelled the book catalogue in MongoDB as documents, with reviews
nested inside each book. The folder has the JSON data, my queries, an
aggregation and an explanation of why a document database suits this
part of the system.

**Portfolio 5: Distributed and cloud database**
My Atlas cluster runs as a 3-node replica set on AWS (Paris). The
folder has evidence of the deployment, a test of a majority write, a
sharding design and a discussion of consistency versus availability.

## How to check or re-run my work

1. **Parts 1 to 3:** create a database called library_db in
   PostgreSQL, then run the SQL files from each folder in this order:
   schema, sample data, queries, transactions.
2. **Part 4:** import books.json into a collection called books in a
   database called library, then run the queries listed in queries.js.
3. **Part 5:** this one is evidence and discussion, so see the
   screenshots and the README in that folder.

I have not put any passwords or connection strings in this repository.

## Development history

I committed my work after finishing each stage, so the commit history
shows how the portfolio developed through the semester.

## AI use declaration

- **Tool used:** Claude (Anthropic)
- **What I used it for:**  explaining database concepts in plain language, giving me step-by-step guide on fixing errors, suggesting example SQL and MongoDB commands, and helping me draft README which I rewrote.
- **How I checked it:**  I ran every command myself in pgAdmin, Compass and Atlas, and took the screenshots from my own results. I fixed the problems that came up along the way, and I wrote the explanations and reflection in my own words. I can explain each query, diagram and design choice in this portfolio.



## References

- PostgreSQL documentation: https://www.postgresql.org/docs/
- MongoDB documentation: https://www.mongodb.com/docs/