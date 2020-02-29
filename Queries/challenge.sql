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

-- Challenge Part 1

-- ensure all employees holds a title, have a job (a slot in corporate org chart).
-- current employees have a title
SELECT COUNT(emp_no)
FROM dept_emp
where (to_date = '9999-01-01');
-- results: 240124

-- current employees have a job
SELECT COUNT(emp_no)
FROM titles
where (to_date = '9999-01-01');
-- results: 240124

-- current employees have a title, and have a job.
-- inner
SELECT count(de.emp_no)
FROM (SELECT * FROM dept_emp
		where (to_date = '9999-01-01')) as de
	inner join (SELECT * FROM titles
		where (to_date = '9999-01-01')) as t
	on (de.emp_no = t.emp_no);
-- 240124

-- current employees have either a title, or a job.
-- full outer
SELECT count(de.emp_no)
FROM (SELECT * FROM dept_emp
		where (to_date = '9999-01-01')) as de
	full outer join (SELECT * FROM titles
		where (to_date = '9999-01-01')) as t
	on (de.emp_no = t.emp_no);
-- 240124

-- create retiring_emp by inner_join tables employee and titles.
-- 1, current employees
-- 2, born in [1952, 1955].
-- 3, hired in [1985, 1988].
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	t.title,
	t.from_date,
	s.salary
INTO retiring_emp
FROM employees as e
	INNER JOIN salaries as s
		ON (e.emp_no = s.emp_no)
	INNER JOIN titles as t
		ON (e.emp_no = t.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
    AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
    AND (t.to_date = '9999-01-01')
ORDER BY e.emp_no;

-- how many are they?
SELECT COUNT(emp_no) FROM retiring_emp;
-- 33118

-- show how to get all employees, retirees with last titles, current employees with latest tiles.
-- emp_no, title, latest_date
SELECT emp_no, title, max(to_date) as latest_date
FROM titles
GROUP BY emp_no, title
ORDER BY emp_no;

-- mentors, inner join tables employees and titles
-- 1, current employees
-- 2, born in 1965.
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	t.title,
	t.from_date,
	t.to_date
INTO mentors
FROM employees as e
	INNER JOIN titles as t
		ON (e.emp_no = t.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
    AND (t.to_date = '9999-01-01')
ORDER BY e.emp_no;

-- how many are mentors?
SELECT COUNT(emp_no) FROM mentors;
-- 1549.
