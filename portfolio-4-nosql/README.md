# Portfolio 4: NoSQL and Advanced Data Models

## Model chosen
I used a document database: MongoDB Atlas (the free cloud cluster),
which I connected to through MongoDB Compass. It's the same case
study as the other parts, the City University Library Management
System.

## Design
I made one collection called books. Each document holds the details
of one book (title, author, category, ISBN, copies available), and
the reviews for that book sit inside the same document as an array.
The documents don't all have the same fields. Only some books have
tags, and one has an edition number, which is fine in MongoDB.

## Files
- books.json: the 5 documents I inserted
- queries.js: the queries and the aggregation I ran

## Implementation evidence
- Created the library database and the books collection in Compass
- Inserted 5 book documents
- Ran 4 queries (by category, copies >= 2, nested review rating = 5,
  and out-of-stock books)
- Updated one document (changed copies_available on Learning Python)
- Ran 1 aggregation with $group to count books and copies per category

## Why a document database suits this data
- A book and its reviews are almost always read together, so storing
  them in one document means no JOIN is needed and a catalogue lookup
  is a single read.
- Books don't all have the same attributes (tags, edition and so on).
  A flexible schema avoids having lots of empty columns like I would
  in a SQL table.
- A catalogue is read far more than it is changed, which fits how
  MongoDB scales.

## Where SQL is still better
- Loans and fines need strict rules and transactions. In Part 3, a
  loan and the stock update had to succeed together, and the CHECK
  constraint stopped the stock going below zero. MongoDB can't enforce
  that kind of relationship as simply, so I kept loans in PostgreSQL.
- So the design that makes the most sense for this library is both:
  PostgreSQL for loans, members and fines, and MongoDB for the
  catalogue.

## Reflection
The biggest difference from SQL was how I thought about the data. In
PostgreSQL I split everything into separate tables and joined them
back together. In MongoDB I put the reviews inside the book, so I was
thinking about how the data gets read, not how to avoid repeating it.
Searching inside the nested reviews (reviews.rating) was easier than I
expected, because it didn't need a join.

What I found easy: inserting documents and running simple filters in
Compass, because the filter box is close to the JSON I already knew.

What I found hard was getting connected. I had two Atlas accounts, and
Compass had an old saved connection that kept failing with "bad auth:
authentication failed". The problem was the password. I fixed it by
resetting the database user's password in Atlas, checking my IP was on
the Network Access list, and updating the connection string in Compass.
It taught me that a lot of "database problems" are really access and
network settings. The aggregation syntax was also strange at first,
since it's written as stages instead of a single SQL statement.

The main lesson is that SQL and NoSQL aren't competitors. Each is
better for different jobs, and one system can use both. 