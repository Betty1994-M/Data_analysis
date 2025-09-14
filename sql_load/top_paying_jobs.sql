/*
1.	What are the top paying jobs for my role?
2.	What are the skills required for these top paying jobs?
3.	What are the most in-demand skills for my role?
4.	What are the top skills based on salary for my role?
5.	What are the most optimal skills to learn?
	Optimal: high demand and high paying
*/

SELECT 
job_id,
job_title,
job_location,
job_schedule_type,
salary_year_avg,
company_dim.name,
job_posted_date
FROM job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id=company_dim.company_id
WHERE job_title ='Data Analyst' AND salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC;


 