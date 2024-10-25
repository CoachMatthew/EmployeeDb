CREATE DATABASE EmployeeDbForHrDept;
USE EmployeeDbForHrDept;

DROP TABLE IF EXISTS Employee;
CREATE TABLE Employee (
    EmpID VARCHAR(20) PRIMARY KEY,
    EmpName VARCHAR(20),
    Salary INT,
    DepartmentID INT,
    StateID INT);

	ALTER TABLE ProjectManager
DROP CONSTRAINT FK__ProjectManager__Department;


DROP TABLE IF EXISTS Department;
CREATE TABLE Department (
    DepartmentID INT PRIMARY KEY,
    Departmantname VARCHAR(20));

DROP TABLE IF EXISTS ProjectManager;
CREATE TABLE ProjectManager (
    ProjectManagerID INT PRIMARY KEY,
    ProjectManagerName VARCHAR(20),
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID));

DROP TABLE IF EXISTS StateMaster;
CREATE TABLE StateMaster (
    StateID INT PRIMARY KEY,
    StateName VARCHAR(20)
);

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

INSERT INTO Department (DepartmentID, Departmantname)
VALUES 
(1, 'IT'),
(2, 'HR'),
(3, 'Admin'),
(4, 'Account');


ALTER TABLE ProjectManager
ADD CONSTRAINT FK__ProjectManager__Department
FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID);



INSERT INTO ProjectManager (ProjectManagerID, ProjectManagerName, DepartmentID)
VALUES 
(1, 'Monika', 1),
(2, 'Vivek', 1),
(3, 'Vipul', 2),
(4, 'Satish', 2),
(5, 'Amitabh', 3);

INSERT INTO StateMaster (StateID, StateName)
VALUES 
(101, 'Lagos'),
(102, 'Abuja'),
(103, 'Kano'),
(104, 'Delta'),
(105, 'Ido'),
(106, 'Ibadan');


--Ques.1. Write a SQL query to fetch the list of employees with same salary.


SELECT EmpName, Salary
FROM Employee
WHERE Salary IN (
  SELECT Salary
  FROM Employee
  GROUP BY Salary
  HAVING COUNT(EmpID) > 1
)


--Ques.2. Write a SQL query to fetch Find the second highest salary and the department and name of the earner.


SELECT MAX(Salary) AS SecondHighestSalary, DepartmentID, EmpName
FROM Employee
WHERE Salary < (
  SELECT MAX(Salary)
  FROM Employee
)


--Ques.3. Write a query to get the maximum salary from each department, the name of the department and the name of the earner.


SELECT MAX(Salary) AS MaxSalary, DepartmentID, EmpName, Departmantname
FROM Employee
JOIN Department ON Employee.DepartmentID = Department.DepartmentID
GROUP BY DepartmentID


--Ques.4. Write a SQL query to fetch Projectmanger-wise count of employees sorted by projectmanger's count in descending order.


SELECT ProjectManagerName, COUNT(EmpID) AS EmpCount
FROM ProjectManager
JOIN Employee ON ProjectManager.DepartmentID = Employee.DepartmentID
GROUP BY ProjectManagerName
ORDER BY EmpCount DESC


--Ques.5. Write a query to fetch only the first name from the EmpName column of Employee table and after that add the salary.


SELECT CONCAT(LEFT(EmpName, CHARINDEX(' ', EmpName) - 1), '_', Salary) AS EmpName_Salary
FROM Employee


--Ques.6. Write a SQL query to fetch only odd salaries from from the employee table.


SELECT Salary
FROM Employee
WHERE Salary % 2 != 0


--Ques.7. Create a view to fetch EmpID,Empname, Departmantname, ProjectMangerName where salary is greater than 30000.


CREATE VIEW HighSalaryEmp AS
SELECT EmpID, EmpName, Departmantname, ProjectMangerName
FROM Employee
JOIN Department ON Employee.DepartmentID = Department.DepartmentID
JOIN ProjectManager ON Employee.DepartmentID = ProjectManager.DepartmentID
WHERE Salary > 30000


--Ques.8. Create a view to fetch the top earners from each department, the employee name and the dept they belong to.


CREATE VIEW TopEarners AS
SELECT EmpName, Departmantname
FROM Employee
JOIN Department ON Employee.DepartmentID = Department.DepartmentID
WHERE (DepartmentID, Salary) IN (
  SELECT DepartmentID, MAX(Salary)
  FROM Employee
  GROUP BY DepartmentID
)


--Ques.9. Create a procedures to update the employee’s salary by 25% where department is ‘IT’ and project manger not ‘Vivek, Satish’.


CREATE PROCEDURE UpdateITSalary
AS
BEGIN
  UPDATE Employee
  SET Salary = Salary * 1.25
  WHERE DepartmentID = 1 AND ProjectManagerID NOT IN (2, 4)
END


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
