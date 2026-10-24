## Optimisation and Performance Analysis

### Test Query

```sql
SELECT * FROM loans WHERE member_id = 42;
```

I used this query to check how PostgreSQL searches for a member's loan records in a table containing 100,000 loans.

### Before Adding the Index

Before I created the index, PostgreSQL used a Sequential Scan (Seq Scan). This means it checked all 100,000 rows in the loans table to find the records belonging to member 42.

Out of the 100,000 rows, 99,906 did not match the condition, leaving 94 records that matched.

The execution time was 21.548 ms, with an estimated cost of 1968.00. This showed that the database was doing more work than necessary for this particular query.

### After Adding the Index

I created an index on the member_id column using the following SQL command:

```sql
CREATE INDEX idx_loans_member ON loans(member_id);
```

After adding the index, PostgreSQL used a Bitmap Index Scan followed by a Bitmap Heap Scan. Instead of checking every row, it used the index to locate the matching records and then retrieved the relevant data from the table.

The query took 1.255 ms to execute, while the estimated cost dropped to 277.89. The execution plan also showed that 83 data blocks were accessed.

### Comparison of Results

| Measure | Before Index | After Index |
|---|---|---|
| Scan type | Sequential Scan | Bitmap Index Scan and Bitmap Heap Scan |
| Estimated cost | 1968.00 | 277.89 |
| Execution time | 21.548 ms | 1.255 ms |

From the results, the query became approximately 17 times faster after I added the index. The execution time reduced by about 94%, while the estimated cost dropped by roughly 86%.

### Explanation of the Results

Without an index, PostgreSQL had to examine the entire table to find the records for member 42. This can take more time as the table grows.

An index works a bit like the index at the back of a textbook. Instead of reading every page to find a topic, you use the index to locate where the information is stored.

In this case, PostgreSQL used the index to locate the matching loan records. It returned the same 94 rows as before, but it found them much faster.

PostgreSQL selected a bitmap scan rather than a regular Index Scan because there were multiple matching records. The bitmap approach collects the locations of matching rows and then reads the relevant table blocks. This can be more efficient when several rows need to be retrieved.

### Trade-offs of Indexing

Although indexes improve search performance, they also have some disadvantages.

- **Storage:** An index requires additional disk space.
- **Write operations:** INSERT, UPDATE and DELETE operations may take slightly longer because the index sometimes needs to be updated as well.
- **Table size:** Indexes are usually more useful for large tables. On a small table, PostgreSQL may decide that a Sequential Scan is faster.

For this library system, indexing member_id makes sense because librarians may need to check a member's borrowing history regularly. However, the benefits should be considered alongside the extra storage and maintenance required.

### Second Example: ISBN Lookup

I also tested a query to search for a book using its ISBN.

```sql
SELECT * FROM books WHERE isbn = 'ISBN250';
```

This query used an Index Scan on books_isbn_key and completed in 0.210 ms. I did not create this index separately. PostgreSQL created it automatically when the UNIQUE constraint was added to the isbn column.

This was useful to observe because the constraint prevents duplicate ISBN values, while the associated index also helps PostgreSQL find a book more quickly.

### Conclusion

From my tests, adding an index to loans(member_id) improved the performance of the loan lookup considerably. The execution time dropped from 21.548 ms to 1.255 ms, which is a significant improvement for this query.

For a library system that frequently searches for members' loan histories, this is a useful optimisation. However, indexes should be added based on how the database is actually used, since they also require storage and can affect write performance.