
--1.List all employees and their job roles
select Employee_Name,Department,Position from hrdataset_v14;
--2Count the number of employees in each department.
select Department,count(Department) as employees  from hrdataset_v14 group by Department;
--3.Show the number of employees hired through each recruitment source.
select RecruitmentSource,count(RecruitmentSource) employees from hrdataset_v14 group by RecruitmentSource;
--4. List employees who are currently active (Employment_Status = 'Active').
select Employee_Name from hrdataset_v14 where EmploymentStatus='active';
--5.Find the minimum, maximum, and average salary in the company.
select min(Salary) maximum_salary,max(salary) minimum_salary,avg(Salary) average_Salary from hrdataset_v14 ;
--6.Count how many employees are currently reporting to each manager.
SELECT ManagerName,COUNT(*) AS Employee_Count FROM HRDataset_v14 WHERE EmploymentStatus = 'Active'
GROUP BY ManagerName;
--7.Retrieve all employees hired after 2015.
select Employee_Name,Department,Position from hrdataset_v14 where DateofHire >'2014-12-31' ;
--8.List the top 5 highest paid employees.
select employee_name,department,position,SALARY from hrdataset_v14 order by Salary desc LIMIT 5; 
--9.Count the number of employees with each performance score.
select PerformanceScore,count(PerformanceScore) count from hrdataset_v14;
--10.Find the number of terminated employees and active employees.
select EmploymentStatus,count(*) count from hrdataset_v14 where EmploymentStatus='active' or EmploymentStatus like 'terminated %' group by EmploymentStatus;
--11.Find the department with the highest average monthly income.
select department,avg(salary) income from hrdataset_v14 group by Department order by income desc limit 1;
--12.List employees who have received an “Exceeds” performance score.
select employee_name,department from hrdataset_v14 where PerformanceScore ='exceeds';
-- 13. Depts with above-average salary
SELECT Department FROM hr_data GROUP BY Department HAVING AVG(Salary) > (SELECT AVG(Salary) FROM hr_data);
-- 14. Left within 1 year
SELECT * FROM hr_data WHERE TermDate IS NOT NULL AND TIMESTAMPDIFF(YEAR, Hire_Date, TermDate) < 1;
-- 15. Tenure buckets
SELECT CASE
         WHEN TIMESTAMPDIFF(YEAR, Hire_Date, IFNULL(TermDate, CURDATE())) < 1 THEN '<1 year'
         WHEN TIMESTAMPDIFF(YEAR, Hire_Date, IFNULL(TermDate, CURDATE())) BETWEEN 1 AND 3 THEN '1-3 years'
         WHEN TIMESTAMPDIFF(YEAR, Hire_Date, IFNULL(TermDate, CURDATE())) BETWEEN 4 AND 5 THEN '3-5 years'
         ELSE '5+ years'
       END AS Tenure_Bucket,
       COUNT(*) AS Count
FROM hr_data
GROUP BY Tenure_Bucket;
-- 16. Avg salary by position
SELECT Position, AVG(Salary) FROM hr_data GROUP BY Position;
-- 17. Avg age by department
SELECT Department, AVG(Age) FROM hr_data GROUP BY Department;
-- 18. Employees hired each year
SELECT YEAR(Hire_Date) AS Hire_Year, COUNT(*) FROM hr_data GROUP BY Hire_Year;
-- 19. No TermDate but not active
SELECT * FROM hr_data WHERE TermDate IS NULL AND Employment_Status != 'Active';
-- 20. Top 3 departments by terminations
SELECT Department, COUNT(*) AS Terminations FROM hr_data WHERE TermDate IS NOT NULL GROUP BY Department ORDER BY Terminations DESC LIMIT 3;
-- 21. Rank by salary within department
SELECT *, RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS Salary_Rank FROM hr_data;
-- 22. Tenure in years
SELECT Employee_Name, ROUND(TIMESTAMPDIFF(DAY, Hire_Date, IFNULL(TermDate, CURDATE())) / 365.0, 2) AS Tenure_Years FROM hr_data;
-- 23. Retention risk
SELECT * FROM hr_data WHERE (PerformanceScore LIKE '%Fully Meets%' OR PerformanceScore LIKE '%Exceeds%') AND Salary < (SELECT AVG(Salary) FROM hr_data);
-- 24. Engagement vs Termination
SELECT EngagementSurvey, CASE WHEN TermDate IS NOT NULL THEN 1 ELSE 0 END AS Terminated FROM hr_data;
-- 25. Avg salary by recruitment source
SELECT RecruitmentSource, AVG(Salary) AS Avg_Salary FROM hr_data GROUP BY RecruitmentSource;
-- 26. Salary vs avg dept salary
SELECT *, Salary - AVG(Salary) OVER (PARTITION BY Department) AS Salary_Diff FROM hr_data;
-- 27. Month-over-month hires and terminations
SELECT DATE_FORMAT(Hire_Date, '%Y-%m') AS Month, COUNT(*) AS Hires FROM hr_data GROUP BY MonthUNION ALL
SELECT DATE_FORMAT(TermDate, '%Y-%m') AS Month, COUNT(*) AS Terminations FROM hr_data WHERE TermDate IS NOT NULL GROUP BY Month;
-- 28. No performance review in 12 months
SELECT * FROM hr_data WHERE LastPerformanceReviewDate IS NOT NULL AND TIMESTAMPDIFF(MONTH, LastPerformanceReviewDate, CURDATE()) > 12;
-- 29. Depts with high attrition and low engagement
SELECT Department, COUNT(CASE WHEN TermDate IS NOT NULL THEN 1 END) AS Terminations, AVG(EngagementSurvey) AS Avg_Engagement FROM hr_data GROUP BY Department HAVING Terminations > 5 AND Avg_Engagement < 3;
-- 30. High-risk employees
SELECT * FROM hr_data WHERE (PerformanceScore LIKE '%Exceeds%' OR PerformanceScore LIKE '%Fully Meets%') AND EngagementSurvey < 3 AND Salary < (SELECT AVG(Salary) FROM hr_data);
-- 31. Recruitment source with lowest turnover
SELECT RecruitmentSource, SUM(CASE WHEN TermDate IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*) AS Turnover_Rate FROM hr_data GROUP BY RecruitmentSource ORDER BY Turnover_Rate ASC;
-- 32. Promoted more than once
SELECT * FROM hr_data WHERE Promotion_Count > 1;
-- 33. Salary growth by hire year
SELECT YEAR(Hire_Date) AS Hire_Year, AVG(Salary) AS Avg_Salary FROM hr_data GROUP BY Hire_Year;
-- 34. % of performance scores per year
SELECT YEAR(Hire_Date) AS Year, PerformanceScore, COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY YEAR(Hire_Date)) AS Percentage FROM hr_data GROUP BY YEAR(Hire_Date), PerformanceScore;
