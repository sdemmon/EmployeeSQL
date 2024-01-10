-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.
Drop table employees;
Drop table departments;
Drop table titles;
Drop table dept_emp;
Drop table salaries;
Drop table dept_manager;

CREATE TABLE "departments" (
    "dept_no" VARCHAR(4)   NOT NULL,
    "dept_name" VARCHAR(40)   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "dept_emp" (
    "emp_no" int   NOT NULL,
    "dept_no" VARCHAR(4)   NOT NULL,
    CONSTRAINT "pk_dept_emp" PRIMARY KEY (
        "emp_no","dept_no"
     )
);

CREATE TABLE "dept_manager" (
    "emp_no" int   NOT NULL,
    "dept_no" CHAR(4)   NOT NULL,
    CONSTRAINT "pk_dept_manager" PRIMARY KEY (
        "emp_no","dept_no"
     )
);

CREATE TABLE "salaries" (
    "emp_no" int   NOT NULL,
    "salary" int   NOT NULL,
    CONSTRAINT "pk_salaries" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "employees" (
    "emp_no" INT   NOT NULL,
    "emp_title_id" VARCHAR(5)   NOT NULL,
    "birth_date" DATE   NOT NULL,
    "first_name" VARCHAR(250)   NOT NULL,
    "last_name" VARCHAR(250)   NOT NULL,
    "sex" CHAR(1)   NOT NULL,
    "hire_date" DATE   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no","emp_title_id"
     )
);

CREATE TABLE "titles" (
    "title_id" VARCHAR(5)   NOT NULL,
    "title" VARCHAR(20)   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title_id" FOREIGN KEY("emp_title_id")
REFERENCES "titles" ("title_id");

SELECT s.emp_no, e.last_name, e.first_name, e.sex, s.salary
FROM employees AS e
INNER JOIN salaries AS s
ON (s.emp_no = e.emp_no)
ORDER BY 1;


SELECT emp_no, first_name, last_name, hire_date 
FROM employees 
WHERE EXTRACT(YEAR FROM hire_date::date) = 1986;

SELECT d_m.dept_no, d.dept_name, d_m.emp_no, e.last_name, e.first_name
FROM dept_manager AS d_m
INNER JOIN departments AS d
ON d_m.dept_no= d.dept_no
INNER JOIN employees AS e
ON d_m.emp_no = e.emp_no
ORDER BY 1;

--List the department number for each employee along with that employee’s employee number, last name, first name, and department name.

SELECT e.emp_no, e.last_name, e.first_name,d.dept_name
FROM employees AS e
LEFT JOIN dept_emp AS d_e
ON e.emp_no = d_e.emp_no
INNER JOIN departments AS d
ON d_e.dept_no = d.dept_no
ORDER BY 1;

--List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.
SELECT e.last_name, e.first_name, e.sex
FROM employees AS e
WHERE (e.first_name = 'Hercules') AND (LOWER(e.last_name) LIKE 'b%')
ORDER BY e.last_name;

--List each employee in the Sales department, including their employee number, last name, and first name.
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees AS e
INNER JOIN dept_emp AS c_d_e
ON e.emp_no = c_d_e.emp_no
INNER JOIN departments AS d
ON c_d_e.dept_no = d.dept_no
WHERE LOWER(d.dept_name) = 'sales';

--List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees AS e
INNER JOIN dept_emp AS c_d_e
ON e.emp_no = c_d_e.emp_no
INNER JOIN departments AS d
ON c_d_e.dept_no = d.dept_no
WHERE (LOWER(d.dept_name) = 'sales') OR (LOWER(d.dept_name) = 'development');

--List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).
SELECT last_name,COUNT(last_name) AS Frequency 
FROM employees 
GROUP BY last_name
ORDER BY frequency DESC;