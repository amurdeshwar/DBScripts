CREATE TABLE dbo.Test_script123 (
    EmpId INT IDENTITY(1,1) PRIMARY KEY,
    EmpName VARCHAR(100),
    Salary DECIMAL(10,2)
);

ALTER TABLE dbo.Test_script123 ADD Grade VARCHAR(1);
