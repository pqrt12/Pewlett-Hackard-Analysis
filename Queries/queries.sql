-- 7.3.1 Query Dates
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';


SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';


-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- generate a new table: retirement_info
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * from retirement_info

--- also exported to retirement_info.csv

-- 7.3.2 / 7.3.3 Join the tables
-- create new retirement_info table w/ emp_no

DROP TABLE retirement_info;
-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;


-- Joining departments and dept_manager tables
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;


-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
	retirement_info.first_name,
	retirement_info.last_name,
	dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

-- use aliase
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	d.to_date
FROM retirement_info as ri
LEFT JOIN dept_emp as d
ON ri.emp_no = d.emp_no;

-- Joining departments and dept_manager tables
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

DROP TABLE current_emp;
-- keep current employees
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

SELECT * FROM current_emp

-- 7.3.4 Count, Group By, and Order By
-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no;

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

-- generate table curr_emp_summary
SELECT COUNT(ce.emp_no), de.dept_no
INTO curr_emp_summary
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

SELECT * FROM curr_emp_summary;

-- output curr_emp_summary.csv

-- 7.3.5 additional lists
-- List 1, Employee Info, includes:
-- emp_no, last_name, first_name, gender, (to_date), and salary
SELECT * FROM salaries
ORDER BY to_date DESC;

SELECT e.emp_no,
	e.first_name,
	e.last_name,
	e.gender,
	s.salary,
	de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
     AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
     AND (de.to_date = '9999-01-01');

-- List 2, Management, includes:
-- mgr's emp_no, first_name, last_name, from_date, and to_date

-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
-- INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);

-- List 3, Department Retirees
--	emp_no, first_name, last_name, dept_name
SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	d.dept_name
-- INTO dept_info
FROM current_emp as ce
	INNER JOIN dept_emp AS de
		ON (ce.emp_no = de.emp_no)
	INNER JOIN departments AS d
		ON (de.dept_no = d.dept_no);

-- 7.3.6 Tailored List
-- Sales team
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
--	de.dept_no,
	d.dept_name
-- INTO dept_info
FROM retirement_info as ri
	INNER JOIN dept_emp as de
		ON (ri.emp_no = de.emp_no)
	LEFT JOIN departments as d
		on (de.dept_no = d.dept_no)
WHERE (d.dept_no = 'd007');

-- Combined departments: sales ('d007')and development ('d005')
SELECT * FROM departments;

SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	d.dept_name
-- INTO sales_development_info
FROM retirement_info as ri
	INNER JOIN dept_emp as de
		ON (ri.emp_no = de.emp_no)
	LEFT JOIN departments as d
		on (de.dept_no = d.dept_no)
WHERE (d.dept_no = 'd007')
		OR (d.dept_no = 'd005');

-- use IN Condition
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	d.dept_name
-- INTO sales_development_info
FROM retirement_info as ri
	INNER JOIN dept_emp as de
		ON (ri.emp_no = de.emp_no)
	LEFT JOIN departments as d
		on (de.dept_no = d.dept_no)
WHERE d.dept_no in ('d007', 'd005');
