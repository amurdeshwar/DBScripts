--Insert Employee
CREATE PROCEDURE InsertEmployee
    @EmpName VARCHAR(100),
    @Salary DECIMAL(10,2)
AS
BEGIN
    INSERT INTO Employee (EmpName, Salary)
    VALUES (@EmpName, @Salary);
END;
GO

--Update Employee
CREATE PROCEDURE UpdateEmployee
    @EmpId INT,
    @EmpName VARCHAR(100),
    @Salary DECIMAL(10,2)
AS
BEGIN
    UPDATE Employee
    SET
        EmpName = @EmpName,
        Salary = @Salary
    WHERE EmpId = @EmpId;
END;
GO
