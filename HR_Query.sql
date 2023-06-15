--1 Worked 
SELECT dbo.employees.department_id, dbo.employees.salary,dbo.departments.department_name
FROM dbo.employees
JOIN dbo.departments ON dbo.employees.department_id=dbo.employees.department_id

--2 Worked

SELECT dbo.employees.salary, dbo.departments.department_name
FROM dbo.employees 
LEFT JOIN dbo.departments ON dbo.employees.department_id=dbo.departments.department_id
ORDER BY salary DESC

-- 3 Worked 
SELECT AVG(salary), department_id
FROM dbo.employees 
GROUP BY department_id 
HAVING AVG(salary) >5000
ORDER BY AVG(salary) DESC

--4 Worked
SELECT Concat(first_name,' ',last_name) AS FullName
FROM dbo.employees 

-- 5 Worked
SELECT AVG(dbo.employees.salary) AS AvgSal, dbo.departments.department_name
FROM dbo.employees 
LEFT JOIN dbo.departments ON dbo.employees.department_id=dbo.departments.department_id
GROUP BY department_name
ORDER BY AvgSal DESC

-- 6 Worked (with aliases)
SELECT AVG(emp.salary) AS AvgSal, dep.department_name
FROM dbo.employees emp
LEFT JOIN dbo.departments dep  ON emp.department_id=dep.department_id
GROUP BY department_name
ORDER BY AvgSal DESC

-- 7 Worked 
SELECT dep.department_name, COUNT(emp.department_id) AS TotalEmp
FROM dbo.employees emp
LEFT JOIN dbo.departments dep  ON emp.department_id=dep.department_id
GROUP BY department_name
ORDER BY TotalEmp DESC

--8 Worked Job title and department PARTITION BY 
Select EMP.employee_id, CONCAT(EMP.first_name,' ',last_name) AS FullName, 
COUNT(EMP.department_id) OVER (PARTITION BY EMP.department_id) AS Department,DEP.department_name, JOB.job_title
FROM dbo.employees EMP
LEFT JOIN dbo.departments DEP ON EMP.department_id=DEP.department_id
LEFT JOIN dbo.jobs JOB ON EMP.job_id=JOB.job_id
ORDER BY department_name DESC



Select CONCAT(EMP.first_name,' ',last_name) AS FullName,JOB.job_title,
CASE 
WHEN EMP.salary < JOB.min_salary THEN 'Lower than Min'
WHEN EMP.salary > max_salary THEN 'Higher than MAX'
ELSE 'Normal'
END AS Salary
FROM dbo.employees EMP
LEFT JOIN dbo.departments DEP ON EMP.department_id=DEP.department_id
LEFT JOIN dbo.jobs JOB ON EMP.job_id=JOB.job_id

--9 CTE
WITH CTE_Emploees AS 
(   
SELECT first_name, last_name, count(employee_id) OVER (PARTITION BY department_id) AS NumOfEmp
FROM dbo.employees
)
SELECT*
FROM CTE_Emploees