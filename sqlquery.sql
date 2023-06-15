DROP TABLE IF EXISTS #HR_Table 
CREATE TABLE #HR_Table (
    employee_id int,
    full_name varchar(200),
    hire_date date,
    salary int,
    department_name varchar(200),
    job_title varchar(200),
    postal_code varchar(200),
    country_id varchar(10),
    country_name varchar(200),
    region_name varchar(200)
)

--Inserting the data into the temporary table just created 

INSERT INTO #HR_Table
SELECT emp.employee_id, CONCAT(emp.first_name,' ',emp.last_name) AS full_name ,emp.hire_date,emp.salary,dep.department_name,
jobs.job_title, loc.postal_code,loc.country_id, cou.country_name,
reg.region_name
FROM dbo.employees emp
JOIN dbo.jobs jobs on emp.job_id=jobs.job_id
JOIN dbo.departments dep on emp.department_id=dep.department_id
JOIN dbo.locations loc on dep.location_id= loc.location_id
JOIN dbo.countries cou on loc.country_id=cou.country_id
JOIN dbo.regions reg on cou.region_id=reg.region_id


-- Starting from here solving questions 
-- 1 Fetching the 2 highest paid employees from each department
SELECT * 
FROM ( SELECT *,
rank () over (partition by department_name order by salary DESC ) as Salary_Rank
FROM #HR_Table ) Rank
where Rank.Salary_Rank <=2 

-- 2 Fetching the earliest recruited employees from each department
select* 
FROM (
select employee_id, full_name, salary, department_name,job_title, 
row_number () over (partition by department_name order by employee_id ) as List
FROM #HR_Table) X
where X.List=1
Order by employee_id 

-- 3.Checking if there is any department doesn't have any employees
select department_name
FROM dbo.departments 
WHERE department_name NOT IN (select distinct(department_name) FROM #HR_Table)

-- 4.Listing the 5 employees with lowest salary 
select *
FROM ( select *, 
rank() over (order by salary ASC) Rank
FROM #HR_Table) X
where X.Rank <=5
order by salary

-- 5.Checking the duplicate value
     --1 
select*
FROM ( select*, row_number () over (Partition by full_name Order by full_name) RN 
FROM #HR_Table ) X
where X.RN >1
order by full_name

    --2 
select employee_id, full_name, department_name, job_title
FROM #HR_Table 
Group by employee_id, full_name, department_name, job_title
HAVING COUNT(*)>1


--6.Finding the Average salary for each department
Select employee_id, full_name,department_name,job_title, salary, AVG(salary) over (Partition by department_name ) AvgSalbyDep
FROM #HR_Table
ORDER BY department_name DESC


--7.Getting status on each employee's salary based on their average department salary 

WITH T1 AS (
 Select employee_id, full_name,department_name,job_title, salary, AVG(salary) over (Partition by department_name ) AvgSalbyDep
FROM #HR_Table )

SELECT *, 
CASE WHEN salary > AvgSalbyDep THEN 'HigherthanAvg'
WHEN salary < AvgSalbyDep THEN 'LowerthanAvg'
ELSE 'EqualtoAvg'
END SalaryStat
FROM T1 
Order by department_name


--8.Selecting the employee information who gets the highest salary
SELECT *
FROM #HR_Table
WHERE salary IN (SELECT max(salary) FROM #HR_Table)


--9 Fetching the second highest salary
SELECT MAX(salary)
FROM #HR_Table
WHERE salary NOT IN ( SELECT MAX(salary) FROM #HR_Table)


