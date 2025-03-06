# SQL Cook Book Notes: 

## Chapter 1: Retrieving Records

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

### 3.8 Identifying and Avoiding Cartesian Products

For this section, most of the SQL i will work with, will already be created so this process of analyzing and depicting the Cartesian products should be apply whenever I see a table.

A couple of rules for cardinality:

```
Generally, to avoid a Cartesian product, you would apply the n-1 rule where n represents the number of tables in the FROM clause and n-1 represents the minimun number of joins necessary to avoid a Cartesian product. Depending on what the keys and join columns in your tables are, you may very well need more than n-1 joins but n-1 is a good place to start when writing queries.
```
**Cartesian Product Usefulness:**

> When used  properly, Cartesian products can be useful. Common uses of Cartesian products include transposing or pivoting (and unpivoting) a result set, generating a sequence of values, and mimicking a loop (although the last may also be accomplished using a recursive CTE).

### 3.9 Performing Join When Using Aggregates

**I believe this is one of the trickiest parts of building good data and is avoiding at ALL COST repetition while creating joins and aggregates with repeated data.**

An example case of this is whenever you in a Cartesian  product have a repeated row say two times the row in which ONE employee has salary. Then if you do an aggregate of the salary it will counts two times that person salary. 

In this kind of cases the solution that is viable is to create a grouping before it like a view or a nested table on the query that will make the salaries unique for the inner join (an aggregation before the real aggregation).

Example 01: In this example we are making sure the bonus row is aggregated before the aggregation of the salary otherwise we  will aggregate the bonus correctly but the salary would be doubled.

```sql
select 
	x.deptno,
	sum(x.sal),
	sum(x.bonus)
from (	
	select 
		e.empno,
		e.sal,
		e.deptno,
		sum(e.sal * case when eb."type" = 1 then .1
					 when eb."type" = 2 then .2
					 else .3
				end
		) as bonus
	from 
		emp e,
		emp_bonus eb 
	where
		e.empno = eb.empno 
		and e.deptno = 10
	group by e.empno , e.sal, e.deptno 
		
) x group by deptno
```

As an alternative you can create the new table because in the previous example we are creating the column and the grouping by removing duplicates:

```sql
select 
	d.deptno,
	d.total_sal,
	sum(e.sal * case when eb."type" = 1 then .1
					 when eb."type" = 2 then .2
					 else .3
				end
		) as bonus
from 
	emp e,
	emp_bonus eb,
	(
		select deptno, sum(sal) as total_sal
		from emp
		where
			deptno = 10
		group by 
			deptno 
	) d
where e.deptno = d.deptno
	and e.empno = eb.empno 
group by d.deptno, d.total_sal
	
```
### 3.10: Performing Outer Joins When Using Aggregates

This is the same example but assuming you there are people with NULL bonuses  so on the left outer join and the case you need to be aware of that:

```sql
select 
	x.deptno,
	sum(x.sal),
	sum(x.bonus)
from (
select 
e.empno,
e.sal,
e.deptno,
sum(
	e.sal * case
		when eb."type" = 1 then .1
		when eb."type" = 2 then .2
		when eb."type" = 3 then .3
		else 0
	end
	
) as bonus
from emp e 
	left outer join emp_bonus eb on eb.empno = e.empno
	inner join dept d on e.deptno = d.deptno 
where d.deptno = 10
group by e.empno , e.sal, e.deptno
) x group by deptno
```
## Chapter 4: Inserting, Updating, and Deleting

### 4.1 Inserting records (tips)

You can do multiple inserts at the same time:

```sql
/* multi row insert */
insert into dept (deptno,dname,loc)
values (1,'A','B'), (2,'B','C')
```

Also if you want to insert a column default value you will do:

### 4.2 Inserting Default Values

All brands support the use of the DEFAULT keyword.

```sql
insert into D values (values)
```

Also for tables with default values in multiple columns excluding the column will mean the brand of database will automatically insert the default value for that column.

### 4.3 Overriding a default value with NULL

```sql
/* table: create table (id integer default 0, foo varchar(20))
insert into d (id,foo) values (null, 'Brighten')
```

### 4.4 Copying the rows from one table into another (Very Useful)

So far one of the most useful commands for data recovery and upgrading existing tables:

```sql
insert into dept_east (deptno, dname, loc)
select deptno, dname, loc
  from dept
where loc in ('NEW YORK', 'BOSTON')
```

### 4.5 Copying a Table Definition (Very Useful)

You want to create a table having the same set of column as the existing columns, but **no rows**:

```sql
create table dept_2
as 
select *
  from dept
where 1=0
```

When using **CTAS - Create Table as Select**, all rows from your query will be used to populate the new table you are creating unless you specify a false condition in the WHERE clause.


### 4.8 Modifying Records in a Table

Use the UPDATE statement to modify existing rows in a database table. For example:

```sql
update emp
  set sal = sal*1.10
where deptno = 20
```

### 4.9 Updating when corresponding rows exists

```sql
update emp
  set sal=sal*1.10
where empno in (select empno from emp_bonus)
```

### 4.10 Updating with Values from Another Table

In `PostgreSQL` you can do the next method to conveniently update joining with another table:

```sql
update emp
  set 
    sal = ns.sal,
    comm = ns.sal/2
  from new_sal ns
where ns.deptno = emp.deptno
```

### 4.15 Deleting Referential Integrity Violations

Using the NOT IN alternative I find it more readable

```sql
delete from emp
where deptno not in (select deptno from dept)
```

### 4.17 Deleting Records Referenced from Another Table

Using a subquery and the aggregation functions like count you can find the departments with three or more accidents. Then delete all employees working in those departments:

```sql
delete from emp
where deptno in (
  select deptno
  from dept_accidents
    group by deptno
  having count(*) >= 3
)
```

## Chapter 5: Metadata Queries

### 5.1 Listing Tables in a Schema

In postgres the information of the database is done through the table INFORMATION_SCHEMA.TABLES:

```sql
select table_name
  from information_schema.tables
where table_schema = 'SMEAGOL'
```

So basically tables have this mechanism of  exposing their own information about themselves in a manner of tables and views just as other information is exposed.

### 5.2 Listing Table's Columns

In postgres the information of the database is done through the table INFORMATION_SCHEMA.COLUMNS:

```sql
select column_name, data_type, ordinal_position
  from information_schema.columns
where 
  table_schema = 'SMEAGOL'
  and table_name = 'EMP'
```

### 5.3 Listing Indexed Columns for a Table

```sql
select a.tablename, a.indexname, b.column_name
  from 
    pg_catalog.pg_indexes a,
    information_schema.columns b
  where
    a.schemaname = 'SMEAGOL'
    and a.tablename = b.table_name
```

When it comes to queries, it's important to know what columns are/aren't indexed. Indexes can provide good performance for queries against columns that are frequently used in filters and that are fairly selective. Indexes are also useful when joining between tables.


Links:

- Documentations:
[Postgres: String Function](https://www.postgresql.org/docs/9.1/functions-string.html)

- Articles:
[Reddit: Is SELECT DISTINCT really that bad?](https://www.reddit.com/r/dataengineering/comments/17qge22/is_select_distinct_really_that_bad/)
- Videos:
[Cartesian Product](https://www.youtube.com/watch?v=ufjEv-5nmcA&ab_channel=Dr.TreforBazett)

202411070009
