-- following tables have been created, and populated.
/* 
-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
    dept_no VARCHAR(4) NOT NULL,
    dept_name VARCHAR(40) NOT NULL,
    PRIMARY KEY (dept_no),
    UNIQUE (dept_name)
);
CREATE TABLE employees (
    emp_no INT NOT NULL,
    birth_date DATE NOT NULL,
    first_name VARCHAR NOT NULL,
    last_name VARCHAR NOT NULL,
    gender VARCHAR NOT NULL,
    hire_date DATE NOT NULL,
    PRIMARY KEY (emp_no)
);
CREATE TABLE dept_manager (
    dept_no VARCHAR(4) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
    FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);
CREATE TABLE salaries (
    emp_no INT NOT NULL,
    salary INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
    PRIMARY KEY (emp_no)
);
CREATE TABLE dept_emp (
    dept_no VARCHAR(4) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
    FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no)
);
CREATE TABLE titles (
    emp_no INT NOT NULL,
    title varchar NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
    PRIMARY KEY (emp_no)
);
*/

-- Challenge
-----------------------------------------------------------------
-- create retire_emp by inner_join tables "employees", "titles"
-- and "salaries", see ERD.
--      1, current employees
--      2, born between [1952, 1955].
--      3, hired between [1985, 1988].

DROP TABLE IF EXISTS retire_emp;
SELECT e.emp_no,
    e.first_name,
    e.last_name,
    t.title,
    t.from_date,
    s.salary
INTO retire_emp
FROM employees as e
    INNER JOIN salaries as s
        ON (e.emp_no = s.emp_no)
    INNER JOIN titles as t
        ON (e.emp_no = t.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
    AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
    AND (t.to_date = '9999-01-01');
-- 33118

-- how many are they?
SELECT COUNT(emp_no) FROM retire_emp;
-- 33118

-----------------------------------------------------------------
-- many employees "emp_no" share same names, try to
-- remove duplicated entries.
--
-- remove duplicated entries from same person:
--      with same name ("first_name", "last_name")
--      with same "birth_date"
--
-- inner_join tables "employees" and "retire_map" to get associated
--      "birth_date" and "hire_date";
-- keep later "hire_date" entry for same person (with same name and
--      "birth_date").
DROP TABLE IF EXISTS retire_emp_unique;
SELECT DISTINCT ON (first_name, last_name, birth_date)
    emp_no, first_name, last_name, title, from_date, salary
INTO retire_emp_unique
FROM (SELECT e.*, re.title, re.from_date, re.salary
    FROM employees as e
    INNER JOIN retire_emp as re
        ON (e.emp_no = re.emp_no)
    ORDER BY e.hire_date DESC) as dup;
-- 33118

-- how many are they?
SELECT COUNT(emp_no) FROM retire_emp_unique;
-- 33118

--  remove duplicate entries with same name in table "retire_emp".
--      keep lastest "from_date" entries.
SELECT DISTINCT ON (first_name, last_name) *
INTO retire_emp_uniq
FROM (SELECT *
      FROM retire_emp
      ORDER BY from_date DESC) as dup;
-- 32859

-- how many are they?
SELECT COUNT(emp_no) FROM retire_emp_uniq;
-- 32859

-----------------------------------------------------------------
-- mentors, inner join tables "employees" and "titles"
-- 1, current employees
-- 2, born in 1965.
-- duplicate entries with same name is removed.
DROP TABLE IF EXISTS mentors;
SELECT DISTINCT ON (first_name, last_name) *
INTO mentors
FROM (SELECT e.emp_no, e.first_name, e.last_name,
        t.title, t.from_date, t.to_date
    FROM employees as e
        INNER JOIN titles as t
            ON (e.emp_no = t.emp_no)
    WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
        AND (t.to_date = '9999-01-01')
    ORDER BY from_date DESC) as mentors_dup;

-- how many are mentors?
SELECT COUNT(emp_no) FROM mentors;
-- 1549.

--------------------------------------------------------------
-- duplicate entries (same name and same birth_date)
DROP TABLE IF EXISTS employee_dup;
SELECT first_name, last_name, birth_date, count(*)
INTO employee_dup
FROM employees
GROUP BY first_name, last_name, birth_date
HAVING count(*) > 1;

-- full employee info
DROP TABLE IF EXISTS employee_dup_full;
SELECT e.*
INTO employee_dup_full
FROM employees as e
	inner join employee_dup as ed
		on (e.first_name = ed.first_name)
			and (e.last_name = ed.last_name)
			and (e.birth_date = ed.birth_date)
ORDER BY (e.first_name, e.last_name, e.hire_date);

-- full employee info and "to_date"
SELECT edf.*, t.to_date
FROM employee_dup_full as edf
	inner join titles as t
		on (edf.emp_no = t.emp_no)
	where (t.to_date = '9999-01-01')
ORDER BY (edf.first_name, edf.last_name, edf.hire_date);
