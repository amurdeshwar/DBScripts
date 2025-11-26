CREATE TABLE dbo.Test_script (
    EmpId INT IDENTITY(1,1) PRIMARY KEY,
    EmpName VARCHAR(100),
    Salary DECIMAL(10,2)
);
GO

ALTER TABLE dbo.Test_script ADD Age INT;
