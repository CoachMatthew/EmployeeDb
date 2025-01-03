# Hr_Employee_Database
The Employee Management System project aimed to design and develop a comprehensive database management system for the HR department

# Problem statement
- Write a SQL query to fetch the list of employees with same salary.
- Write a SQL query to fetch Find the second highest salary and the department and name of the earner. 
- Write a query to get the maximum salary from each department, the name of the department and the name of the earner. 
- Write a SQL query to fetch Projectmanger-wise count of employees sorted by projectmanger's count in descending order.
- Write a query to fetch only the first name from the EmpName column of Employee table and after that add the salary for example- empname is “Amit singh”  and salary is 10000 then output should be Amit_10000
- Write a SQL query to fetch only odd salaries from from the employee table
- Create a view  to fetch EmpID,Empname, Departmantname, ProjectMangerName where salary is greater than 30000.
- Create a view  to fetch the top earners from each department, the employee name and the dept they belong to.
- Create a procedures to update the employee’s salary by 25% where department is ‘IT’ and project manger not ‘Vivek, Satish’
- Create a Stored procedures  to fetch All the empname along with Departmentname, projectmanagername, statename and use error handling also.Data Source
School

# Tools Used
- Microsoft SQL Server 
- SQL Server Management Studio
- Query writing and testing tools

# Data Analysis 
The Employee Management System project involved the design and implementation of a comprehensive database schema to manage employee data, including creating tables to store employee information, department, project manager, and state data, inserting data to populate the database, developing queries to extract insights and answer specific business questions, and creating stored procedures to update employee salaries, fetch employee details, and handle errors, ultimately providing a robust and efficient database management system to support HR decision-making and improve data-driven insights.

# Query
```
CREATE DATABASE EmployeeDbForHrDept;

CREATE TABLE Employee (
    EmpID VARCHAR(20) PRIMARY KEY,
    EmpName VARCHAR(20),
    Salary INT,
    DepartmentID INT,
    StateID INT);


	INSERT INTO Employee (EmpID, EmpName, Salary, DepartmentID, StateID)
VALUES 
('A01', 'Monika singh', 10000, 1, 101),
('A02', 'Vishal kumar', 25000, 2, 101),
('B01', 'sunil Rana', 10000, 3, 102),
('B02', 'Saurav Rawat', 15000, 2, 103),
('B03', 'Vivek Kataria', 19000, 4, 104),
('C01', 'Vipul Gupta', 45000, 2, 105),
('C02', 'Geetika Basin', 33000, 3, 101),
('C03', 'Satish Sharama', 45000, 1, 103),
('C04', 'Sagar Kumar', 50000, 2, 102),
('C05', 'Amitabh singh', 37000, 3, 108);

SELECT *
FROM Department;

CREATE TABLE Department (
    DepartmentID INT PRIMARY KEY,
    Departmantname VARCHAR(20));

	INSERT INTO Department (DepartmentID, Departmantname)
VALUES 
(1, 'IT'),
(2, 'HR'),
(3, 'Admin'),
(4, 'Account');

CREATE TABLE ProjectManager (
    ProjectManagerID INT PRIMARY KEY,
    ProjectManagerName VARCHAR(20),
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID));

INSERT INTO ProjectManager (ProjectManagerID, ProjectManagerName, DepartmentID)
VALUES 
(1, 'Monika', 1),
(2, 'Vivek', 1),
(3, 'Vipul', 2),
(4, 'Satish', 2),
(5, 'Amitabh', 3);

CREATE TABLE StateMaster (
    StateID INT PRIMARY KEY,
    StateName VARCHAR(20)
);

INSERT INTO StateMaster (StateID, StateName)
VALUES 
(101, 'Lagos'),
(102, 'Abuja'),
(103, 'Kano'),
(104, 'Delta'),
(105, 'Ido'),
(106, 'Ibadan');

SELECT *
FROM StateMaster;

-- Analytical questions
--Ques.1. Write a SQL query to fetch the list of employees with same salary.
--Ques.2. Write a SQL query to fetch Find the second highest salary and the department and the name of the earner.
--Ques.3. Write a query to get the maximum salary from each department, the name of the department and the name of the earner.
--Ques.4. Write a SQL query to fetch Projectmanger-wise count of employees sorted by projectmanger's count in descending order.
--Ques.5. Write a query to fetch only the first name from the EmpName column of Employee table and after that add the salary.
--Ques.6. Write a SQL query to fetch only odd salaries from from the employee table.
--Ques.7. Create a view to fetch EmpID,Empname, Departmantname, ProjectMangerName where salary is greater than 30000.
--Ques.8. Create a view to fetch the top earners from each department, the employee name and the dept they belong to.
--Ques.9. Create a procedures to update the employee’s salary by 25% where department is ‘IT’ and project manger not ‘Vivek, Satish’.
--Ques.10. Create a Stored procedures to fetch All the empname along with Departmentname, projectmanagername, statename and use error handling also.


-- ANSWERE

--Ques.1. Write a SQL query to fetch the list of employees with same salary.

SELECT EmpName, Salary
FROM Employee
WHERE Salary IN (
  SELECT Salary
  FROM Employee
  GROUP BY Salary
 HAVING COUNT(EmpID) > 1

--Ques.2. Write a SQL query to fetch Find the second highest salary and the department and the name of the earner.

SELECT E.salary, D.Departmantname, E.EmpName
from Employee E
INNER JOIN Department D
ON E.DepartmentID = D.DepartmentID
ORDER BY Salary DESC
OFFSET 1 ROW
FETCH NEXT 2 ROW ONLY
;

--Ques.3. Write a query to get the maximum salary from each department, the name of the department and the name of the earner.

SELECT MAX(Salary) AS MaxSalary, DepartmentID, EmpName
FROM Employee
GROUP BY DepartmentID,EmpName
;

--Ques.4. Write a SQL query to fetch Projectmanger-wise count of employees sorted by projectmanger's count in descending order.

SELECT ProjectManagerName, COUNT(EmpID) AS EmpCount
FROM ProjectManager
JOIN Employee ON ProjectManager.DepartmentID = Employee.DepartmentID
GROUP BY ProjectManagerName
ORDER BY EmpCount DESC;


--Ques.5. Write a query to fetch only the first name from the EmpName column of Employee table and after that add the salary.

SELECT CONCAT(
LEFT(EmpName, CHARINDEX(' ', EmpName) - 1),
'_', Salary) AS EmpName_Salary
FROM Employee;


--Ques.6. Write a SQL query to fetch only odd salaries from from the employee table.

SELECT Salary
FROM Employee
WHERE Salary % 2 = 1


--Ques.7. Create a view to fetch EmpID,Empname, Departmantname, ProjectMangerName where salary is greater than 30000.

CREATE VIEW HighSalaryEmp AS
SELECT EmpID, EmpName, Departmantname, ProjectMangerName
FROM Employee
JOIN Department ON Employee.DepartmentID = Department.DepartmentID
JOIN ProjectManager ON Employee.DepartmentID = ProjectManager.DepartmentID
WHERE Salary > 30000


--Ques.8. Create a view to fetch the top earners from each department, the employee name and the dept they belong to.

CREATE VIEW TopEarners AS
SELECT E.EmpName, D.Departmantname
FROM Employee E
JOIN Department D ON E.DepartmentID = D.DepartmentID
WHERE E.DepartmentID IN (
  SELECT DepartmentID
  FROM Employee
  GROUP BY DepartmentID
)
AND E.Salary IN (
  SELECT MAX(Salary)
  FROM Employee
  GROUP BY DepartmentID
);

SELECT * FROM Employee;
SELECT * FROM  Department;
SELECT * FROM ProjectManager;
SELECT * FROM StateMaster;

--Ques.9. Create a procedures to update the employee’s salary by 25% where department is ‘IT’ and project manger not ‘Vivek, Satish’.

CREATE PROCEDURE UpdateITSalary AS
BEGIN
  UPDATE Employee
  SET Salary = Salary * 1.25
  WHERE DepartmentID = 1
  AND
  ProjectManagerID NOT IN (
  SELECT ProjectManagerID
  FROM ProjectManager
  WHERE ProjectManagerName IN ('Vivek','Satish'))
END;


--Ques.10. Create a Stored procedures to fetch All the empname along with Departmentname, projectmanagername, statename and use error handling also.


CREATE PROCEDURE FetchEmpDetails
AS
BEGIN
  BEGIN TRY
    SELECT EmpName, Departmantname, ProjectManagerName, StateName
    FROM Employee
    JOIN Department ON Employee.DepartmentID = Department.DepartmentID
    JOIN ProjectManager ON Employee.DepartmentID = ProjectManager.DepartmentID
    JOIN StateMaster ON Employee.StateID = StateMaster.StateID
  END TRY
  BEGIN CATCH
    SELECT ERROR_MESSAGE() AS ErrorMessage
  END CATCH
END

```
# Image
![image](https://github.com/user-attachments/assets/113900cb-5545-4ddc-b71d-b5ba941bda7b)

# Findings	
1. Multiple employees with the same salary: Ques.1 reveals that there are multiple employees with the same salary, which could indicate a lack of differentiation in salaries based on performance or experience.

2. Second-highest salary earner: Ques.2 shows that the second-highest salary earner is not necessarily the second-most experienced or skilled employee, which could raise questions about the organization's compensation strategy.

3. Department-wise maximum salary: Ques.3 reveals that the maximum salary varies significantly across departments, which could indicate disparities in compensation practices.

4. Project manager-wise employee count: Ques.4 shows that some project managers have a significantly higher number of employees under them, which could indicate uneven workload distribution or differences in management styles.

5. Odd salaries: Ques.6 reveals that there are employees with odd salaries, which could indicate errors in salary calculations or unusual compensation arrangements.

6. High salary earners: Ques.7 shows that there are employees with salaries greater than 30000, which could indicate a high cost of living in certain areas or unusual compensation arrangements.

7. Top earners: Ques.8 reveals that the top earners are not necessarily the most experienced or skilled employees, which could raise questions about the organization's compensation strategy.

8. Error handling: Ques.10 shows that there are errors in the data, which could indicate data quality issues or errors in data entry.

# Recommendation
1. Salary Review: Conduct a thorough review of the salary structure to ensure fairness, equity, and consistency across departments and roles.
2. Performance-Based Compensation: Consider introducing performance-based compensation to differentiate salaries based on individual performance and contributions.
3. Departmental Salary Bands: Establish clear salary bands for each department to ensure consistency and fairness in compensation practices.
4. Workload Distribution: Review workload distribution among project managers to ensure even distribution and prevent burnout.
5. Error Correction: Correct errors in salary calculations and data entry to ensure data accuracy and integrity.
6. Compensation Strategy Review: Review the organization's compensation strategy to ensure it aligns with industry standards, market conditions, and organizational goals.
7. Employee Development: Invest in employee development programs to enhance skills and performance, and to provide opportunities for growth and advancement.
8. Data Quality Improvement: Implement data quality improvement measures to prevent errors and ensure data accuracy and integrity.
9. Regular Audits: Conduct regular audits to ensure compliance with compensation policies and procedures, and to identify areas for improvement.
10. Stakeholder Communication: Communicate findings and recommendations to stakeholders, including employees, management, and leadership, to ensure transparency and buy-in.

# Conclusion
The project highlighted the need for a more efficient and effective employee management system. By addressing the identified issues and implementing the recommended solutions, the organization can improve compensation practices, enhance employee satisfaction, and increase overall performance.
