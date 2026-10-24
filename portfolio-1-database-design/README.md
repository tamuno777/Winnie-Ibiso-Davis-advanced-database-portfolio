# Portfolio 1: Database Design and Modelling

## Case Study

The project is a Library Management System for City University. The system is designed to help librarians manage books and keep records of members who borrow them. It also helps with recording loans, processing returns, calculating fines for late returns and searching for books in the library catalogue.

## Files Created

- **schema.sql:** Contains the SQL commands used to create the five tables in the database.
- **er_diagram.png:** Shows the relationships between the tables and how the database is structured.

## Tables Used

The database contains five tables, and each one is responsible for storing a particular type of information.

- **Members:** Stores the details of people who register to borrow books from the library.
- **Staff:** Contains information about the librarians who handle borrowing and returning books.
- **Books:** Stores book information, including details used to identify and search for books.
- **Loans:** Keeps records of books borrowed by members and the staff who process the transactions.
- **Fines:** Stores information about fines owed when books are returned late.

I separated the information into different tables so that the database would be easier to manage and unnecessary duplication would be reduced.

## Keys and Constraints

Each table has a primary key, which is an auto-generated ID used to identify each record. This helps ensure that every record can be identified separately.

The loans table has foreign keys that link it to the members, books and staff tables. This means that a loan record can be connected to the member who borrowed the book, the book itself and the staff member who handled the transaction. The fines table also has a foreign key that connects each fine to the relevant loan.

I included some constraints to help maintain the quality of the data. For example, email addresses and ISBN numbers must be unique, so the same email or ISBN cannot be entered more than once in the relevant table. Required fields are marked as NOT NULL to prevent them from being left empty.

I also used CHECK constraints to prevent negative values from being entered for book copies and fine amounts. These rules help reduce incorrect entries and keep the database more reliable.

## Normalisation

The database design follows the principles of Third Normal Form (3NF). I used normalisation to organise the data properly and avoid storing the same information unnecessarily in different places.

First Normal Form (1NF) means that each field contains a single value and that there are no repeating groups. Second Normal Form (2NF) requires non-key attributes to depend on the whole primary key. Third Normal Form (3NF) means that non-key attributes should not depend on other non-key attributes.

For example, member details are stored in the members table instead of being repeated every time that person borrows a book. The loans table uses the member's ID to link the borrowing record to the member's information. This makes it easier to update details without having to change several loan records.

Overall, the design helps keep the data organised and reduces the chances of inconsistencies when records are added or updated.

## How I Tested the Database

I tested the database using pgAdmin with PostgreSQL 17. I ran the schema.sql file and checked that all five tables were created successfully.

This confirmed that the SQL script could create the main database structure. However, this test was mainly focused on table creation. Further testing with sample records would be useful to confirm that the relationships and constraints work as expected, including whether duplicate emails, duplicate ISBNs and negative values are rejected.