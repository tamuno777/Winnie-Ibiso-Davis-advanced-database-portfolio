# Transactions and Concurrency

## 1. COMMIT

I tested how a transaction works when a member borrows a book. The process involved inserting a new loan record and reducing the number of available copies in the books table.

Both operations were carried out in one transaction. After I executed COMMIT, the changes were saved to the database. The available copies went from 3 to 2, and the loan record was also saved.

This showed me that COMMIT is used to save changes made during a transaction. It is important because both operations need to be completed together for the borrowing process to be recorded correctly.

## 2. ROLLBACK

I also tested ROLLBACK to see what happens when changes should not be saved.

In my first example, I made changes within a transaction and then executed ROLLBACK. The changes were undone, meaning the database returned to the state it was in before the transaction started.

In the second example, I tested a borrowing operation that violated a CHECK constraint. The constraint prevented the available copies from becoming a negative number. Since the operation failed, the loan insertion was also undone as part of the failed transaction. The loan count stayed the same.

This helped me understand that transactions are not just for saving changes. They also help prevent incomplete operations from leaving the database in an incorrect state.

## 3. Concurrency Problem

For this test, I used two database sessions to simulate two members trying to borrow the same book at almost the same time.

The book had only one available copy. Both sessions read the available copies as 1 before either transaction completed. Because they both saw that a copy was available, both proceeded with inserting a loan record.

This created a problem because two members were recorded as borrowing a book when only one copy was available. This is an example of a concurrency problem, where transactions running at the same time interfere with each other and produce an incorrect result.

I could see why checking the available copies alone was not enough. The system also needed a way to control what happens when multiple users try to borrow the same book at once.

## 4. Control Mechanism: Row Locking

To solve the problem, I used `SELECT ... FOR UPDATE` to lock the relevant book record while the borrowing transaction was in progress.

With this approach, the first session locked the row before checking and updating the available copies. When the second session tried to lock the same row, it had to wait until the first transaction committed.

After the first transaction completed, the second session continued and saw that the available copies had dropped to 0. The borrowing request was then refused because there were no copies left.

This prevented both sessions from successfully borrowing the same available copy. I learnt that row locking is useful when a transaction needs to read and update the same record without another transaction changing it at the wrong time.

## 5. Isolation

PostgreSQL uses READ COMMITTED as its default transaction isolation level. In simple terms, a query can see data committed by other transactions before that query begins. It does not normally see changes that another transaction has not committed.

However, READ COMMITTED does not automatically prevent every concurrency problem. For example, two sessions can still read the same available-copy value before either one updates it. This is why row locking or another suitable control is needed for the borrowing process.

Another isolation level is SERIALIZABLE. It provides stronger protection by making PostgreSQL check whether concurrent transactions could produce a result that would be impossible if the transactions had run one after another. If PostgreSQL detects a conflict that cannot safely be resolved, one transaction may fail and need to be tried again.

SERIALIZABLE can help protect more complex operations, but it may require retrying transactions. For a library borrowing system, row locking is a practical way to protect the available-copy check and update.

## Reflection

One of the things I found interesting while doing this exercise was seeing how two sessions could read the same value and still produce an incorrect result. Before testing it, I understood that a transaction groups database operations together, but I had not fully considered what could happen when two people tried to borrow the same book at the same time.

The most challenging part was understanding why checking the available copies was not enough on its own. I learnt that the database needs to control access to the record while the borrowing operation is taking place.

Transactions are important in a library system because borrowing a book involves more than just inserting a loan record. The available copies must also be updated correctly. If one operation succeeds and the other fails, the records may no longer agree.

Overall, this exercise helped me understand how COMMIT, ROLLBACK, row locking and isolation work together to keep database records consistent, especially when several users are using the system at the same time.