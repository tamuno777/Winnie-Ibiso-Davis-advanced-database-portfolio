INSERT INTO members (full_name, email)
SELECT 'Member '||g, 'member'||g||'@mail.com'
FROM generate_series(1,1000) g;

INSERT INTO staff (full_name, role)
VALUES ('Ada Obi','Librarian'), ('Tunde Bello','Assistant');

INSERT INTO books (title, author, category, isbn, copies_available)
SELECT 'Book '||g, 'Author '||(g%100),
  (ARRAY['Science','Fiction','History','Tech'])[1+g%4],
  'ISBN'||g, 3
FROM generate_series(1,500) g;

INSERT INTO loans (book_id, member_id, staff_id, loan_date, due_date, return_date)
SELECT 1+(random()*499)::int, 1+(random()*999)::int, 1+(random()*1)::int,
  d, d+14, CASE WHEN random()<0.8 THEN d+(random()*20)::int ELSE NULL END
FROM (SELECT CURRENT_DATE - (random()*365)::int AS d
      FROM generate_series(1,100000)) t;

INSERT INTO fines (loan_id, amount)
SELECT loan_id, (return_date - due_date) * 50
FROM loans
WHERE return_date > due_date;

ANALYZE;