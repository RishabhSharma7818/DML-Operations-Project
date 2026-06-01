-- STEP 1: CREATE TABLES
CREATE TABLE departments (
    dept_id     INTEGER PRIMARY KEY,
    dept_name   VARCHAR(50)  NOT NULL,
    location    VARCHAR(100) DEFAULT 'Head Office'
);

CREATE TABLE employees (
    emp_id      INTEGER PRIMARY KEY,
    first_name  VARCHAR(50)  NOT NULL,
    last_name   VARCHAR(50)  NOT NULL,
    email       VARCHAR(100),
    phone       VARCHAR(15),
    hire_date   DATE         NOT NULL,
    job_title   VARCHAR(50)  DEFAULT 'Staff',
    salary      DECIMAL(10,2),
    dept_id     INTEGER,
    manager_id  INTEGER,
    FOREIGN KEY (dept_id)    REFERENCES departments(dept_id) ON DELETE CASCADE,
    FOREIGN KEY (manager_id) REFERENCES employees(emp_id)
);

CREATE TABLE projects (
    project_id   INTEGER PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL,
    start_date   DATE,
    end_date     DATE,
    budget       DECIMAL(12,2),
    status       VARCHAR(20) DEFAULT 'Planned'
);

CREATE TABLE employee_projects (
    emp_id      INTEGER,
    project_id  INTEGER,
    role        VARCHAR(50),
    assigned_on DATE,
    PRIMARY KEY (emp_id, project_id),
    FOREIGN KEY (emp_id)       REFERENCES employees(emp_id)  ON DELETE CASCADE,
    FOREIGN KEY (project_id)   REFERENCES projects(project_id) ON DELETE CASCADE
);

CREATE TABLE project_audit_log (
    log_id       INTEGER PRIMARY KEY,
    emp_id       INTEGER,
    emp_name     VARCHAR(100),
    project_name VARCHAR(100),
    role         VARCHAR(50),
    logged_at    DATE
);

INSERT INTO departments (dept_id, dept_name, location) VALUES
(1, 'Engineering',  'Building A'),
(2, 'Marketing',    'Building B'),
(3, 'HR',           'Building C'),
(4, 'Finance',      'Building A'),
(5, 'Operations',   'Head Office');
-- dept_id 5 uses DEFAULT location 'Head Office'


-- STEP 3: INSERT EMPLOYEES (with NULLs)
-- Full inserts — some columns intentionally NULL to show null handling
INSERT INTO employees
    (emp_id, first_name, last_name, email, phone, hire_date, job_title, salary, dept_id, manager_id)
VALUES
(1,  'Arjun',  'Sharma', 'arjun.sharma@company.com',  '9876543210', '2020-01-15', 'Engineering Manager', 95000.00, 1, NULL),
(2,  'Priya',  'Verma',  'priya.verma@company.com',   '9876543211', '2020-03-10', 'Senior Developer',    80000.00, 1, 1),
(3,  'Rahul',  'Gupta',  'rahul.gupta@company.com',   NULL,         '2021-06-01', 'Developer',           65000.00, 1, 1),
-- ^ phone is NULL — not provided during onboarding
(4,  'Sneha',  'Patel',  NULL,                        '9876543213', '2021-07-20', 'Marketing Lead',      72000.00, 2, NULL),
-- ^ email is NULL — employee requested not to share
(5,  'Vikram', 'Singh',  'vikram.singh@company.com',  '9876543214', '2022-02-14', 'HR Manager',          68000.00, 3, NULL),
(6,  'Ananya', 'Nair',   'ananya.nair@company.com',   NULL,         '2022-05-05', 'HR Executive',        45000.00, 3, 5),
-- ^ phone is NULL
(7,  'Karan',  'Mehta',  'karan.mehta@company.com',   '9876543216', '2023-01-11', 'Finance Analyst',     55000.00, 4, NULL),
(8,  'Divya',  'Joshi',  NULL,                        NULL,         '2023-03-22', 'Staff',               40000.00, 5, NULL),
-- ^ both email and phone are NULL
(9,  'Rohan',  'Das',    'rohan.das@company.com',     '9876543218', '2023-08-01', 'Junior Developer',    50000.00, 1, 2),
(10, 'Meera',  'Iyer',   'meera.iyer@company.com',    '9876543219', '2024-01-10', 'Marketing Executive', NULL,     2, 4);
-- ^ salary is NULL — new hire, package not finalised yet

-- Partial INSERT — only mandatory columns provided
-- job_title gets DEFAULT 'Staff', salary/email/phone/manager_id all become NULL
INSERT INTO employees (emp_id, first_name, last_name, hire_date, dept_id)
VALUES (11, 'Amit', 'Kumar', '2024-06-01', 1);

-- STEP 4: INSERT PROJECTS (some NULLs)
INSERT INTO projects (project_id, project_name, start_date, end_date, budget, status) VALUES
(1, 'Website Redesign',      '2024-01-01', '2024-06-30', 150000.00, 'Completed'),
(2, 'ERP Implementation',    '2024-03-01', '2025-02-28', 500000.00, 'In Progress'),
(3, 'Marketing Campaign Q3', '2024-07-01', '2024-09-30',  80000.00, 'Planned'),
(4, 'HR Portal',             '2024-05-01', NULL,          NULL,      'In Progress'),
-- ^ end_date and budget unknown — project still being scoped
(5, 'Data Migration',        '2025-01-01', NULL,          NULL,      'Planned');
-- ^ not yet scoped, no budget allocated

-- STEP 5: INSERT EMPLOYEE-PROJECT ASSIGNMENTS
INSERT INTO employee_projects (emp_id, project_id, role, assigned_on) VALUES
(2, 1, 'Tech Lead',   '2024-01-01'),
(3, 1, 'Developer',   '2024-01-01'),
(9, 1, 'Developer',   '2024-02-01'),
(1, 2, 'Sponsor',     '2024-03-01'),
(2, 2, 'Architect',   '2024-03-01'),
(4, 3, 'Lead',        '2024-07-01'),
(5, 4, 'Owner',       '2024-05-01'),
(6, 4, 'Contributor', '2024-05-15');

-- STEP 6: INSERT using SELECT
-- Populate audit log from completed projects
INSERT INTO project_audit_log (log_id, emp_id, emp_name, project_name, role, logged_at)
SELECT
    ep.emp_id,
    e.emp_id,
    e.first_name || ' ' || e.last_name,
    p.project_name,
    ep.role,
    DATE('now')
FROM employee_projects ep
JOIN employees e ON ep.emp_id    = e.emp_id
JOIN projects  p ON ep.project_id = p.project_id
WHERE p.status = 'Completed';

-- STEP 7: UPDATE STATEMENTS

-- 7a. Update single row — assign salary to Meera (emp_id 10)
UPDATE employees
SET salary = 48000.00
WHERE emp_id = 10;

-- 7b. Update multiple rows — 10% raise for entire Engineering department
UPDATE employees
SET salary = salary * 1.10
WHERE dept_id = 1
  AND salary IS NOT NULL;

-- 7c. Fill NULL emails with a generated default
UPDATE employees
SET email = LOWER(first_name || '.' || last_name || '@company.com')
WHERE email IS NULL;

-- 7d. Change project status
UPDATE projects
SET status = 'Active'
WHERE project_id = 3;

-- 7e. Update two columns at once for HR Portal project
UPDATE projects
SET budget   = 60000.00,
    end_date = '2025-03-31'
WHERE project_id = 4;

-- STEP 8: DELETE STATEMENTS

-- 8a. Delete a single employee who left the company
DELETE FROM employees
WHERE emp_id = 11;

-- 8b. Remove all assignments for a completed project
DELETE FROM employee_projects
WHERE project_id = 1;

-- 8c. Delete unscoped projects with no budget
DELETE FROM projects
WHERE budget IS NULL
  AND status = 'Planned';