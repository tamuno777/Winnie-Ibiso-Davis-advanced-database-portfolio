-- MIT 8103 Portfolio 3: Transactions and Concurrency
-- Case study: City University Library Management System
-- Database: library_db (PostgreSQL 17)


-- STAGE A: Successful borrow (COMMIT)
-- A borrow = insert a loan + reduce stock. Both must
-- succeed together.

-- A1. Stock BEFORE
SELECT book_id, title, copies_available FROM books WHERE book_id = 1;

-- A2. The transaction (run these 4 lines together)
BEGIN;
INSERT INTO loans (book_id, member_id, staff_id, due_date)
VALUES (1, 5, 1, CURRENT_DATE + 14);
UPDATE books SET copies_available = copies_available - 1 WHERE book_id = 1;
COMMIT;

-- A3. Check AFTER (run one at a time)
SELECT book_id, title, copies_available FROM books WHERE book_id = 1;
SELECT * FROM loans
WHERE member_id = 5 AND book_id = 1
ORDER BY loan_id DESC LIMIT 1;


-- STAGE B: ROLLBACK

-- B1. Manual rollback: undo a change on purpose
-- Run these 3 lines together:
BEGIN;
UPDATE books SET copies_available = copies_available - 1 WHERE book_id = 1;
SELECT copies_available FROM books WHERE book_id = 1;   -- temporary value

-- Then run:
ROLLBACK;

-- Then run to confirm the value is restored:
SELECT copies_available FROM books WHERE book_id = 1;

-- B2. Failed transaction: borrowing a book with 0 copies.
-- The CHECK (copies_available >= 0) rule makes it fail,
-- and the loan insert is undone too (atomicity).

-- Setup, then note the loan count:
UPDATE books SET copies_available = 0 WHERE book_id = 3;
SELECT COUNT(*) FROM loans;

-- Run these 3 lines together (the UPDATE is EXPECTED to give an error):
BEGIN;
INSERT INTO loans (book_id, member_id, staff_id, due_date)
VALUES (3, 7, 1, CURRENT_DATE + 14);
UPDATE books SET copies_available = copies_available - 1 WHERE book_id = 3;

-- After the error, run:
ROLLBACK;

-- Count is the same as before (loan was undone):
SELECT COUNT(*) FROM loans;


-- STAGE C: Concurrency problem (NO protection)
-- Needs TWO tabs: Tab A and Tab B.
-- Two users both see 1 copy and both borrow it.

-- Setup (Tab A, run alone):
UPDATE books SET copies_available = 1 WHERE book_id = 2;

-- C1. Tab A:
BEGIN;
SELECT copies_available FROM books WHERE book_id = 2;   -- shows 1

-- C2. Tab B:
BEGIN;
SELECT copies_available FROM books WHERE book_id = 2;   -- also shows 1

-- C3. Tab A:
INSERT INTO loans (book_id, member_id, staff_id, due_date)
VALUES (2, 999, 1, CURRENT_DATE + 14);
UPDATE books SET copies_available = 0 WHERE book_id = 2;
COMMIT;

-- C4. Tab B (still believes 1 copy exists):
INSERT INTO loans (book_id, member_id, staff_id, due_date)
VALUES (2, 1000, 1, CURRENT_DATE + 14);
UPDATE books SET copies_available = 0 WHERE book_id = 2;
COMMIT;

-- C5. Check the damage: two loans for a one-copy book
SELECT loan_id, book_id, member_id FROM loans
WHERE book_id = 2 ORDER BY loan_id DESC LIMIT 2;


-- STAGE D: Row locking with FOR UPDATE (the fix)
-- Needs TWO tabs. The second user must WAIT.

-- Setup (Tab A, run alone, with no BEGIN before it):
UPDATE books SET copies_available = 1 WHERE book_id = 2;

-- D1. Tab A: lock the row (do NOT commit yet)
BEGIN;
SELECT copies_available FROM books WHERE book_id = 2 FOR UPDATE;   -- shows 1

-- D2. Tab B: this FREEZES until Tab A finishes (screenshot it frozen)
BEGIN;
SELECT copies_available FROM books WHERE book_id = 2 FOR UPDATE;

-- D3. Tab A: complete the borrow and release the lock
INSERT INTO loans (book_id, member_id, staff_id, due_date)
VALUES (2, 999, 1, CURRENT_DATE + 14);
UPDATE books SET copies_available = copies_available - 1 WHERE book_id = 2;
COMMIT;

-- D4. Tab B now unfreezes and shows 0 (second user is refused). Then:
ROLLBACK;


-- STAGE E: Isolation levels

-- E1. Default level (shows: read committed)
SHOW transaction_isolation;

-- E2. Stricter level (run these 3 lines together; shows: serializable)
BEGIN ISOLATION LEVEL SERIALIZABLE;
SHOW transaction_isolation;
COMMIT;