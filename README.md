# Pewlett-Hackard-Analysis
# Challenge

Pewlett Hackward is a large company with thousands of employees. With baby boomers began to retire, Pewlett Hackward needs to know who will be retiring and how many jobs will need to fill up.

To conduct this task, six tables are obtained:  "departments", "employees", "dept_manager", "salaries", "dept_emp", and "titles". The relationship could be seen in the ERD ![EmployeeDB.png](https://github.com/pqrt12/Pewlett-Hackard-Analysis/blob/master/EmployeeDB.png).
 
Table "employees" has each employee's basic information, with a primary key employee id "emp_no". All current employees have a "to_date" in tables marked as "9999-01-01".

To find out who is going to retire, Pewlett Hackward is particularly interested in current employees who were born between 1952 and 1955, and hired between 1985 and 1988, all inclusive. This could be done with inner_join tables "employees", "titles" and "salaries". The query result is saved in table "retire_emp", and output to file [retire_emp.csv](https://github.com/pqrt12/Pewlett-Hackard-Analysis/blob/master/Data/retire_emp.csv). There are a total of 33,118 employees (or "emp_no") in this "retire_emp" table.

There are lots of people at the "retire_emp" table who share the same names. We assume no people sharing the same names and with the same "birth_date". To exclude duplicate entries, first inner_join tables "employees" and "retire_emp" to get all columns in table "employees", then keep later "hire_date" entries if multiple entries with the same name and same "birth_date". The query result is saved in a table "retire_emp_unique". There are 33,118 employees in this table, same as in table "retire_emp". No entries ("emp_no") have the same names and the same "birth_date".

Another query is also performed to exclude entries with the same name in table "retire_emp". The result is saved in table "retire_emp_uniq", and output to file [retire_emp_uniq.csv](https://github.com/pqrt12/Pewlett-Hackard-Analysis/blob/master/Data/retire_emp_uniq.csv). There are 32,859 entries ("emp_no") with unique names.

To address the retiring wave, HR is planning a mentor program, which targets current employees born in 1965. A similar query yields the result in table "mentor", and output to file [mentor.csv](https://github.com/pqrt12/Pewlett-Hackard-Analysis/blob/master/Data/mentors.csv).  There are 1,549 employees who meet the criteria. Note, to ensure all entries with unique names, only entries with the latest "from_date" in table "titles" are kept if entries share the same name.  

All of queries are in file [challenge.sql](https://github.com/pqrt12/Pewlett-Hackard-Analysis/blob/master/Queries/challenge.sql).  
