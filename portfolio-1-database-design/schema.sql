CREATE TABLE members (
  member_id SERIAL PRIMARY KEY,
  full_name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  join_date DATE DEFAULT CURRENT_DATE
);

CREATE TABLE staff (
  staff_id SERIAL PRIMARY KEY,
  full_name VARCHAR(100) NOT NULL,
  role VARCHAR(50)
);

CREATE TABLE books (
  book_id SERIAL PRIMARY KEY,
  title VARCHAR(200) NOT NULL,
  author VARCHAR(100) NOT NULL,
  category VARCHAR(50),
  isbn VARCHAR(20) UNIQUE,
  copies_available INT NOT NULL CHECK (copies_available >= 0)
);

CREATE TABLE loans (
  loan_id SERIAL PRIMARY KEY,
  book_id INT NOT NULL REFERENCES books(book_id),
  member_id INT NOT NULL REFERENCES members(member_id),
  staff_id INT REFERENCES staff(staff_id),
  loan_date DATE DEFAULT CURRENT_DATE,
  due_date DATE NOT NULL,
  return_date DATE
);

CREATE TABLE fines (
  fine_id SERIAL PRIMARY KEY,
  loan_id INT NOT NULL REFERENCES loans(loan_id),
  amount NUMERIC(8,2) CHECK (amount >= 0),
  paid BOOLEAN DEFAULT FALSE
);