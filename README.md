# Employee & Project Database — SQL DML and NULL Handling

A structured SQL project that demonstrates core Data Manipulation Language (DML) operations on a relational employee-project management database. The project focuses on real-world data scenarios including missing values, partial records, and cascading relationships.

**Tools Used:** SQLite 3, DB Fiddle

---

## Project Overview

This project builds a complete employee and project management system from scratch using SQL. It covers everything from designing the schema to inserting, updating, and cleaning data — with a strong focus on handling NULL values the right way.

---

## Database Structure

The database consists of five related tables:

- **departments** — stores company departments and their locations
- **employees** — stores employee records including job title, salary, and contact info
- **projects** — stores company projects with budget and status tracking
- **employee_projects** — maps employees to projects with their assigned roles
- **project_audit_log** — automatically populated log of completed project assignments

---

## Key Concepts Covered

**Data Insertion**
- Inserting complete rows with all column values
- Partial inserts where optional fields default to NULL or a DEFAULT value
- Using INSERT...SELECT to populate a table from existing data

**NULL Handling**
- Storing NULL for unknown or missing values (phone, email, salary)
- Filtering records using IS NULL and IS NOT NULL
- Replacing NULLs in output using COALESCE
- Understanding the difference between NULL and 0

**Data Updates**
- Updating a single record by primary key
- Bulk updating multiple rows using a condition
- Updating previously NULL fields once data becomes available

**Data Deletion**
- Deleting specific records safely using WHERE conditions
- Cleaning up orphan or incomplete records
- Understanding ROLLBACK to reverse accidental deletions

**Constraints & Relationships**
- NOT NULL to enforce required fields
- DEFAULT values as fallback when data is missing
- ON DELETE CASCADE to automatically clean up child records
- Foreign keys linking employees to departments and projects

---

## How to Run

1. Go to [db-fiddle.com](https://www.db-fiddle.com)
2. Select **SQLite 3.39** from the top dropdown
3. Paste the schema and data file into the **left panel**
4. Paste the queries file into the **right panel**
5. Click **Run** — results appear at the bottom
