-- Step 1: Enable the Foreign Data Wrapper extension in your current database (project).
-- This extension allows you to connect to another Postgres database.
CREATE EXTENSION IF NOT EXISTS postgres_fdw;

-- Step 2: Drop any old definition of the server (if it exists), so we can start clean.
-- CASCADE also removes dependent user mappings or foreign tables linked to it.
DROP SERVER IF EXISTS sql_course_srv CASCADE;

-- Step 3: Create a new foreign server connection to the target database (sql_course).
-- Adjust 'host' and 'port' if the database is on another machine or non-default port.
CREATE SERVER sql_course_srv
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (dbname 'sql_course', host 'localhost', port '5432');

-- Step 4: Create a user mapping.
-- This tells Postgres which username/password to use when connecting to sql_course.
-- Replace 'postgres' with your local role in project, and the OPTIONS values with the
-- actual login credentials for sql_course.
CREATE USER MAPPING FOR postgres
SERVER sql_course_srv
OPTIONS (user 'postgres', password 'your_password');

-- Step 5: Import the schema or specific tables from sql_course into project.
-- Here we only import the table job_postings_fact from the public schema.
IMPORT FOREIGN SCHEMA public
LIMIT TO (job_postings_fact)
FROM SERVER sql_course_srv
INTO public;

IMPORT FOREIGN SCHEMA public
LIMIT TO (company_dim)
FROM SERVER sql_course_srv
INTO public;

IMPORT FOREIGN SCHEMA public
LIMIT TO (skills_dim)
FROM SERVER sql_course_srv
INTO public;

IMPORT FOREIGN SCHEMA public
LIMIT TO (skills_job_dim)
FROM SERVER sql_course_srv
INTO public;
-- Step 6: Verify that you can query the foreign table as if it were local.
SELECT * FROM job_postings_fact LIMIT 5;
SELECT * FROM company_dim LIMIT 5;
SELECT * FROM skills_dim LIMIT 5;
SELECT * FROM skills_job_dim LIMIT 5;
-- Step 7: If you want to make a permanent local copy of the data in project,
-- create a new table and copy everything into it.
CREATE TABLE posted_jobs AS
SELECT * FROM job_postings_fact;

CREATE TABLE company_details AS
SELECT * FROM company_dim;

CREATE TABLE skills_detail AS
SELECT * FROM skills_dim;

CREATE TABLE skills_job AS
SELECT * FROM skills_job_dim;