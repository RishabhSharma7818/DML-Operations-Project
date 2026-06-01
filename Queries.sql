-- QUERY 1: View All Employees with Department

SELECT
    e.emp_id,
    e.first_name || ' ' || e.last_name  AS full_name,
    e.job_title,
    e.salary,
    d.dept_name,
    e.email,
    e.phone
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
ORDER BY e.emp_id;

-- QUERY 2: Find Employees with NULL Phone
-- (IS NULL usage)

SELECT
    emp_id,
    first_name || ' ' || last_name AS full_name,
    email,
    phone
FROM employees
WHERE phone IS NULL;

-- QUERY 3: Find Employees WITH a Salary
-- (IS NOT NULL usage)

SELECT
    emp_id,
    first_name || ' ' || last_name AS full_name,
    salary
FROM employees
WHERE salary IS NOT NULL
ORDER BY salary DESC;

-- QUERY 4: NULL vs 0 Demonstration
-- NULL = unknown/missing, 0 = actual zero value
-- COUNT(col) skips NULLs, COUNT(*) counts all rows
-- AVG() also ignores NULLs automatically

SELECT
    COUNT(*)                         AS total_employees,
    COUNT(salary)                    AS employees_with_salary,
    COUNT(*) - COUNT(salary)         AS employees_with_null_salary,
    AVG(salary)                      AS avg_salary_ignores_nulls
FROM employees;

-- QUERY 5: COALESCE — Replace NULL with default
-- Shows salary or 'Not Assigned' if NULL

SELECT
    emp_id,
    first_name || ' ' || last_name        AS full_name,
    COALESCE(CAST(salary AS TEXT), 'Not Assigned') AS salary_display,
    COALESCE(phone, 'No Phone on Record')           AS phone_display,
    COALESCE(email, 'No Email on Record')           AS email_display
FROM employees
ORDER BY emp_id;

-- QUERY 6: View Projects with Budget Status

SELECT
    project_id,
    project_name,
    status,
    start_date,
    COALESCE(CAST(end_date AS TEXT), 'TBD')    AS end_date,
    COALESCE(CAST(budget AS TEXT),   'No Budget Set') AS budget
FROM projects
ORDER BY project_id;

-- QUERY 7: View Project Assignments with Names

SELECT
    p.project_name,
    p.status,
    e.first_name || ' ' || e.last_name AS employee_name,
    ep.role,
    ep.assigned_on
FROM projects p
LEFT JOIN employee_projects ep ON p.project_id = ep.project_id
LEFT JOIN employees e          ON ep.emp_id    = e.emp_id
ORDER BY p.project_id;

-- QUERY 8: Employees and Their Manager Names
-- (Self JOIN on employees table)

SELECT
    e.emp_id,
    e.first_name || ' ' || e.last_name         AS employee,
    e.job_title,
    COALESCE(m.first_name || ' ' || m.last_name, 'No Manager') AS manager
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.emp_id
ORDER BY e.emp_id;

-- QUERY 9: Department Summary

SELECT
    d.dept_name,
    d.location,
    COUNT(e.emp_id)    AS total_employees,
    AVG(e.salary)      AS avg_salary,
    MAX(e.salary)      AS highest_salary,
    MIN(e.salary)      AS lowest_salary
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name, d.location
ORDER BY d.dept_id;

-- QUERY 10: View Audit Log

SELECT
    log_id,
    emp_name,
    project_name,
    role,
    logged_at
FROM project_audit_log
ORDER BY log_id;

-- QUERY 11: Employees hired in 2023 or later

SELECT
    emp_id,
    first_name || ' ' || last_name AS full_name,
    hire_date,
    job_title,
    dept_id
FROM employees
WHERE hire_date >= '2023-01-01'
ORDER BY hire_date;

-- QUERY 12: Projects still In Progress or Active

SELECT
    project_name,
    status,
    start_date,
    budget
FROM projects
WHERE status IN ('In Progress', 'Active')
ORDER BY start_date;