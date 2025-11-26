CREATE TABLE dbo.Test_script (
    EmpId INT IDENTITY(1,1) PRIMARY KEY,
    EmpName VARCHAR(100),
    Salary DECIMAL(10,2)
);

ALTER TABLE dbo.Test_script ADD Age INT;

CREATE TABLE dbo.Test_script12345 (
    EmpId INT IDENTITY(1,1) PRIMARY KEY,
    EmpName VARCHAR(100),
    Salary DECIMAL(10,2)
);
