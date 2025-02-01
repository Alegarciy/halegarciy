# 📌 Guide: Writing Responsible Transactions in PostgreSQL

A transaction is a sequence of SQL statements executed as a single unit of work. It ensures that all statements within it either succeed completely or fail together, maintaining **ACID** properties (**Atomicity, Consistency, Isolation, Durability**).

---

## 🏁 1. Starting a Transaction Properly

### ✅ Basic Transaction Syntax

```sql
BEGIN;  -- Start a transaction

-- Your SQL statements here
COMMIT; -- Save changes permanently
```

**OR**

```sql
BEGIN;  -- Start a transaction

-- Your SQL statements here

ROLLBACK; -- Undo changes if something goes wrong
```

---

## 🚦 2. Example: Safe Insert and Update

### 🛠 Scenario: Banking System - Transferring Money

Imagine a **money transfer** between two accounts:
- Deduct **$100** from **Account A**.
- Add **$100** to **Account B**.
- If either fails, **rollback everything**.

### ✅ Correct Approach Using Transactions

```sql
BEGIN;  -- Start transaction

-- Deduct from sender
UPDATE accounts
SET balance = balance - 100
WHERE id = 1;

-- Add to receiver
UPDATE accounts
SET balance = balance + 100
WHERE id = 2;

-- If everything is successful, commit
COMMIT;
```

- If **both statements succeed**, the transaction is **committed**.
- If **any step fails**, use `ROLLBACK;` instead of `COMMIT;`.

---

## 🚨 3. Handling Errors with ROLLBACK

If something goes wrong in the transaction (e.g., **insufficient funds**), we can **undo all changes**.

### ❌ Bad Example (No Rollback)

```sql
BEGIN;

UPDATE accounts SET balance = balance - 100 WHERE id = 1;
-- Oops! Next line fails due to constraint violation
UPDATE accounts SET balance = balance + 100 WHERE id = 999;  -- Invalid ID

COMMIT; -- 💥 ERROR: The first update is already applied!
```

- The first update **succeeded**, but the second **failed**.
- **Account A lost $100, but Account B never received it!** ❌

### ✅ Correct Way (Using ROLLBACK)

```sql
BEGIN;

UPDATE accounts SET balance = balance - 100 WHERE id = 1;

-- Simulate an error (e.g., invalid account ID)
UPDATE accounts SET balance = balance + 100 WHERE id = 999;

-- If something goes wrong, rollback everything
ROLLBACK;
```

Now **nothing is applied** if an error occurs.

---

## 🔄 4. Using Savepoints for Partial Rollbacks

Sometimes, you want to **partially undo** changes instead of rolling back the entire transaction. **Savepoints** help with that.

### ✅ Example: Multiple Updates with Savepoints

```sql
BEGIN;

SAVEPOINT sp1;

UPDATE accounts SET balance = balance - 100 WHERE id = 1;

SAVEPOINT sp2;

UPDATE accounts SET balance = balance + 100 WHERE id = 2;

-- Oops! Something goes wrong
ROLLBACK TO SAVEPOINT sp2;  -- Undo only the last change

-- Continue transaction
COMMIT;
```

- **Savepoints** allow rolling back **only part of the transaction** instead of everything.
- Useful when dealing with **batch processing**.

---

## ⏳ 5. Avoiding Deadlocks and Performance Issues

Deadlocks occur when **two transactions wait for each other** to release locks. To avoid them:

### ✅ Best Practices
1. **Access tables in the same order** in all transactions.
2. **Keep transactions short** to avoid holding locks too long.
3. **Use `FOR UPDATE` to lock rows explicitly**:

```sql
SELECT * FROM accounts WHERE id = 1 FOR UPDATE;
```

This prevents another transaction from modifying the same row simultaneously.

---

## 🎯 6. Using Isolation Levels

PostgreSQL provides **four transaction isolation levels** to control how transactions interact.

### 💮 Isolation Levels

| Level | Dirty Reads | Non-Repeatable Reads | Phantom Reads |
|--------|------------|----------------------|---------------|
| **READ UNCOMMITTED** | ✅ Allowed | ✅ Allowed | ✅ Allowed |
| **READ COMMITTED (default)** | ❌ Not Allowed | ✅ Allowed | ✅ Allowed |
| **REPEATABLE READ** | ❌ Not Allowed | ❌ Not Allowed | ✅ Allowed |
| **SERIALIZABLE** | ❌ Not Allowed | ❌ Not Allowed | ❌ Not Allowed |

### ✅ Example: Setting an Isolation Level

```sql
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN;

-- Your SQL statements here

COMMIT;
```

- **Use `REPEATABLE READ`** for consistency in reports.
- **Use `SERIALIZABLE`** to avoid concurrency issues but expect performance trade-offs.

---

## 🏆 7. Best Practices for Responsible Transactions

✅ **Keep transactions short**: Avoid holding locks longer than necessary.  
✅ **Always use `ROLLBACK` for error handling**: Prevent incomplete changes.  
✅ **Use `SAVEPOINT` for partial rollbacks**: Avoid restarting entire transactions.  
✅ **Lock rows explicitly** if updating the same records in multiple transactions.  
✅ **Test transactions with a `ROLLBACK` first** before applying `COMMIT`.  

---

## 🌟 Final Example: A Well-Structured Transaction

```sql
BEGIN;

-- Step 1: Deduct funds
UPDATE accounts
SET balance = balance - 100
WHERE id = 1;

-- Step 2: Savepoint before updating receiver
SAVEPOINT before_receiver_update;

-- Step 3: Add funds to the receiver
UPDATE accounts
SET balance = balance + 100
WHERE id = 2;

-- Step 4: Check if everything is good, commit
COMMIT;
```

If anything fails before `COMMIT`, simply:

```sql
ROLLBACK;
```

Or, if only the last step fails:

```sql
ROLLBACK TO SAVEPOINT before_receiver_update;
```

---

## ✅ Conclusion

With this guide, you now know how to **write safe, responsible transactions** in PostgreSQL to:
- Prevent **data corruption**.
- Handle **errors properly**.
- Avoid **deadlocks and performance issues**.
- Use **savepoints for granular control**.

Let me know if you want a more specific case covered! 🚀

## Links

- [AUTOCOMMIT;COMMIT;ROLLBACK](https://www.youtube.com/watch?v=GOQVlrQohtM&ab_channel=BroCode)
