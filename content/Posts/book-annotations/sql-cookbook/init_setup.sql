-- ======================================================================
-- init_setup.sql
-- Creates a new database, then creates and populates the DEPT, EMP, T1,
-- T10, T100, and T500 tables for the SQL Cookbook examples in PostgreSQL.
-- ======================================================================

-----------------------------------------------------------------------
-- 1. Adjust this database name if you prefer a different one
-----------------------------------------------------------------------
DROP DATABASE IF EXISTS sqlcookbook;
CREATE DATABASE sqlcookbook;

-- Switch (connect) to the newly created database
\c sqlcookbook

-----------------------------------------------------------------------
-- 2. Create and populate DEPT and EMP
-----------------------------------------------------------------------

BEGIN;

-- DEPT table
CREATE TABLE dept (
  deptno  SMALLINT      NOT NULL,
  dname   VARCHAR(14),
  loc     VARCHAR(13),
  CONSTRAINT pk_dept PRIMARY KEY (deptno)
);

INSERT INTO dept (deptno, dname, loc) VALUES
  (10, 'ACCOUNTING', 'NEW YORK'),
  (20, 'RESEARCH',   'DALLAS'),
  (30, 'SALES',      'CHICAGO'),
  (40, 'OPERATIONS', 'BOSTON');

-- EMP table
CREATE TABLE emp (
  empno     INTEGER        NOT NULL,
  ename     VARCHAR(10),
  job       VARCHAR(9),
  mgr       INTEGER,
  hiredate  DATE,
  sal       NUMERIC(7,2),
  comm      NUMERIC(7,2),
  deptno    SMALLINT,
  CONSTRAINT pk_emp PRIMARY KEY (empno)
);

INSERT INTO emp (empno, ename, job, mgr, hiredate, sal, comm, deptno) VALUES
  (7369, 'SMITH',  'CLERK',     7902, '2005-12-17', 800,    NULL, 20),
  (7499, 'ALLEN',  'SALESMAN', 7698, '2006-02-20', 1600,   300,  30),
  (7521, 'WARD',   'SALESMAN', 7698, '2006-02-22', 1250,   500,  30),
  (7566, 'JONES',  'MANAGER',  7839, '2006-04-02', 2975,   NULL, 20),
  (7654, 'MARTIN', 'SALESMAN', 7698, '2006-09-28', 1250,   1400, 30),
  (7698, 'BLAKE',  'MANAGER',  7839, '2006-05-01', 2850,   NULL, 30),
  (7782, 'CLARK',  'MANAGER',  7839, '2006-06-09', 2450,   NULL, 10),
  (7788, 'SCOTT',  'ANALYST',  7566, '2007-12-09', 3000,   NULL, 20),
  (7839, 'KING',   'PRESIDENT',NULL, '2006-11-17', 5000,   NULL, 10),
  (7844, 'TURNER', 'SALESMAN', 7698, '2006-09-08', 1500,   0,    30),
  (7876, 'ADAMS',  'CLERK',    7788, '2008-01-12', 1100,   NULL, 20),
  (7900, 'JAMES',  'CLERK',    7698, '2006-12-03', 950,    NULL, 30),
  (7902, 'FORD',   'ANALYST',  7566, '2006-12-03', 3000,   NULL, 20),
  (7934, 'MILLER', 'CLERK',    7782, '2007-01-23', 1300,   NULL, 10);

COMMIT;

-----------------------------------------------------------------------
-- 3. Create pivot tables (T1, T10, T100, T500) and populate them
-----------------------------------------------------------------------
BEGIN;

-- T1: single row with ID = 1
CREATE TABLE t1 (
  id SMALLINT
);
INSERT INTO t1 (id) VALUES (1);

-- T10: 10 rows, ID = 1..10
CREATE TABLE t10 (
  id SMALLINT
);
INSERT INTO t10 (id)
SELECT generate_series(1, 10);

-- T100: 100 rows, ID = 1..100
CREATE TABLE t100 (
  id SMALLINT
);
INSERT INTO t100 (id)
SELECT generate_series(1, 100);

-- T500: 500 rows, ID = 1..500
CREATE TABLE t500 (
  id SMALLINT
);
INSERT INTO t500 (id)
SELECT generate_series(1, 500);

COMMIT;

-----------------------------------------------------------------------
-- All done!
-----------------------------------------------------------------------
SELECT 'Setup complete!' AS message;
