USE datainmotion
GO
/*
DROP TABLE IF EXISTS departments
CREATE TABLE departments (
    id int PRIMARY KEY,
    name VARCHAR(50),
    manager_id INT
);

DROP TABLE IF EXISTS employees
CREATE TABLE employees (
    id int PRIMARY KEY,
    name VARCHAR(50),
    hire_date DATE,
    job_title VARCHAR(50),
    department_id INT 
);


DROP TABLE IF EXISTS projects
CREATE TABLE projects (
    id int PRIMARY KEY,
    name VARCHAR(50),
    start_date DATE,
    end_date DATE,
    department_id INT 
);

GO
ALTER TABLE employees
ADD FOREIGN KEY(department_id) REFERENCES departments(id)

GO
ALTER TABLE projects
ADD FOREIGN KEY(department_id) REFERENCES departments(id)

GO
INSERT INTO departments (id,name, manager_id)
VALUES (1,'HR', 1), (2,'IT', 2), (3,'Sales', 3)

GO
INSERT INTO employees (id,name, hire_date, job_title, department_id)
VALUES (1,'John Doe', '2018-06-20', 'HR Manager', 1),
       (2,'Jane Smith', '2019-07-15', 'IT Manager', 2),
       (3,'Alice Johnson', '2020-01-10', 'Sales Manager', 3),
       (4,'Bob Miller', '2021-04-30', 'HR Associate', 1),
       (5,'Charlie Brown', '2022-10-01', 'IT Associate', 2),
       (6,'Dave Davis', '2023-03-15', 'Sales Associate', 3)

INSERT INTO projects (id,name, start_date, end_date, department_id)
VALUES (1,'HR Project 1', '2023-01-01', '2023-06-30', 1),
       (2,'IT Project 1', '2023-02-01', '2023-07-31', 2),
       (3,'Sales Project 1', '2023-03-01', '2023-08-31', 3),
	   (4,'HR Projects 2','2023-01-01','2023-12-20',1),
	   (5,'Sales Project 2', '2023-03-01', '2023-06-30', 3)

GO 

UPDATE departments
SET manager_id = (SELECT id FROM employees WHERE name = 'John Doe')
WHERE name = 'HR';

UPDATE departments
SET manager_id = (SELECT id FROM employees WHERE name = 'Jane Smith')
WHERE name = 'IT';

UPDATE departments
SET manager_id = (SELECT id FROM employees WHERE name = 'Alice Johnson')
WHERE name = 'Sales';

*/

/*
-- 1) Find the longest ongoing project for each department.

WITH a AS(
SELECT id, department_id, name,  DATEDIFF(day,start_date,end_date) duration_days, MAX(DATEDIFF(day,start_date,end_date)) OVER (PARTITION BY department_id) max_duration_days
FROM projects
WHERE end_date>= GETDATE())

SELECT id, name, department_id FROM a
WHERE duration_days = max_duration_days



--2) Find all employees who are not managers

SELECT id, name, job_title FROM  employees
WHERE id not in (SELECT manager_id FROM departments)


--3) Find all employees who have been hired after the start of a project in their department.

SELECT DISTINCT a.id, a.name  FROM employees a 
JOIN projects b ON a.department_id = b.department_id
WHERE a.hire_date > b.start_date 



--4) Rank employees within each department based on their hire date (earliest hire gets the highest rank).

SELECT id, name, hire_date, department_id, DENSE_RANK() OVER (PARTITION BY department_id ORDER BY hire_date ) rank_employees_hiring_date FROM employees
*/

--5) Find the duration between the hire date of each employee and the hire date of the next employee hired in the same department.

SELECT id, name, hire_date, department_id, LEAD(hire_date,1) OVER (PARTITION BY department_id ORDER BY hire_date ) next_employee_hiring_date,
CASE 
WHEN DATEDIFF(day, hire_date, LEAD(hire_date,1) OVER (PARTITION BY department_id ORDER BY hire_date )) IS NULL THEN 0
ELSE DATEDIFF(day, hire_date, LEAD(hire_date,1) OVER (PARTITION BY department_id ORDER BY hire_date ))
END  duration_days
FROM employees
