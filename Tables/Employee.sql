-- ScriptID: 1
-- ScriptName: Create Test_script table
CREATE TABLE dbo.Test_script (
    EmpId INT IDENTITY(1,1) PRIMARY KEY,
    EmpName VARCHAR(100),
    Salary DECIMAL(10,2)
);
GO

-- ScriptID: 2
-- ScriptName: Add Salary Column
ALTER TABLE dbo.Test_script ADD Salary DECIMAL(10,2)
