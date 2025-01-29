# SQL Cook Book Notes: 

## Chapter 1:  SQL Retrieving Records

For initializing the project run the following command:

```bash
psql -U postgres -h localhost -p 5432 -d postgres -f init_setup.sql
```

### 1.6 Referencing and Aliased Column in the WHERE Clause

This is a interesting example because referencing aliased columns will fail unless you wrap it around another query:
```sql
select *
  from (
    select sal as salary, comm as commission
    from emp
  ) x
  where salary < 5000
```

This works because the order of clauses is the next one:

1. FROM CLAUSE
2. SELECT CLAUSE
3. WHERE CLAUSE

This well lead to new concepts:

1. Aggregated Functions
2. Scalar Subqueries
3. Windowing functions
4. Aliases


### 1.10 Returning n Random Records from a Table

This is an interesting example for creating programs with different data executions samples:

```sql
select ename, job
  from emp
order by random() limit 5
```

The ORDER BY clause can accept a function's return value and use it to change the order of the result set.

1. FUNCTION EXAMPLE -> random()
2. ORDER CLAUSE
3. LIMIT CLAUSE


## Chapter 2: Sorting Query Results

### 2.2 Sorting multiple fields

> The order of PRECEDENCE in ORDER BY is from left to right

This means that groups are first form for the sorted [select_list_element_pos0] and then evaluate the other list items moving forward. (e.g) 

```sql
select empno, deptno, sal, ename, job 
	from emp
order by deptno , sal desc
```

In this case, the order would be priority 0 `deptno` and then sort those "groups" by `sal`.

> You are generally permitted to order by a column not in the SELECT list, but to do so you must explicitly name the column. However, if you are using GROUP BY or DISTINCT in your query, you cannot order by columns that are not in the SELECT list.

### 2.5 Dealing with NULL while sorting

Normally if you are not using oracle the standard solution is to create an extra column:

```sql
select ename, sal, comm, is_null
 from (
 	select ename, sal, comm, 
 	case 
	    when comm is null then 0 
 		else 1 
 	end as is_null
 	from emp
 ) x
 order by is_null desc, comm desc
```

### 2.6 Sorting on a Data-Dependent Key

You can sort by a data dependent key by applying conditionals in the ORDER CLAUSE:

```sql
  select ename, sal, job, comm from emp
  order by (
  	case 
	  	when job='SALESMAN' then comm
  		else sal
	end
  )
```


## Chapter 3: Working with Multiple Tables

### 3.1 Stacking one row set atop another

This is an interesting analogy where the UNION ALL clause is compared to stacking tables by its shared datatype.

1. UNION ALL: will allow repetition
2. UNION: will filter out repeated results

> As with all set operations, the items in all the SELECT lists must match in number and data type.

Look out for performance improvements on any **de-duplication** process:
```text
Before using DISTINCT you need to ask yourself why do you need distinct to deduplicate a dataset... and the answer is almost always because of a bad join, missing constraints and/or dirty data.
```

### 3.2 Combining Related Rows

Is the basics of the inner join, but also i want to highlight how are different representations of it and the Cartesian product:

```sql
select count(*) from dept d , emp e 
-- cartesian product: 56

select count(*) from emp e 
	inner join dept d on e.deptno = d.deptno
-- cartesian product: 14 when the department matched
	
select count(*) from dept d, emp e 
	where d.deptno = e.deptno 
-- cartesian product: 14 this is the 'equi-join'
```

### 3.4 Retrieving value from on table that do not exist in another

In Postgresql you have the `except` operator:

```sql
select deptno from dept
except
select deptno from emp
```


Links:

- Documentations:
[Postgres: String Function](https://www.postgresql.org/docs/9.1/functions-string.html)

- Articles:
[Reddit: Is SELECT DISTINCT really that bad?](https://www.reddit.com/r/dataengineering/comments/17qge22/is_select_distinct_really_that_bad/)
- Videos:
[Cartesian Product](https://www.youtube.com/watch?v=ufjEv-5nmcA&ab_channel=Dr.TreforBazett)

202411070009
