-- Create the database if it doesn't exist
IF NOT EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = 'Autotestdb')
CREATE DATABASE AutoDBTendo;
GO

-- Use the database
USE AutoDBTendo;
GO

-- Create the user table if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[user]') AND type in (N'U'))
CREATE TABLE [dbo].[user] (
    ID INT IDENTITY (1,1) NOT NULL PRIMARY KEY,
    Name NVARCHAR(50) NOT NULL,
    Surname NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL
);
GO

-- Create or alter the stored procedure
CREATE OR ALTER PROCEDURE [dbo].[InsertUser]
    @p_name NVARCHAR(50),
    @p_surname NVARCHAR(50),
    @p_email NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        MERGE INTO [user] AS target
        USING (SELECT @p_name, @p_surname, @p_email) AS source (Name, Surname, Email)
        ON (target.Email = source.Email)
        WHEN MATCHED THEN
            UPDATE SET Name = source.Name, Surname = source.Surname
        WHEN NOT MATCHED THEN
            INSERT (Name, Surname, Email) VALUES (source.Name, source.Surname, source.Email);
    END TRY
    BEGIN CATCH
        PRINT 'Error occurred: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


-- Insert sample data
EXEC [dbo].[InsertUser] 'John', 'Doe', 'john.doe@example.com';
EXEC [dbo].[InsertUser] 'Jane', 'Smith', 'jane.smith@example.com';
EXEC [dbo].[InsertUser] 'Test', 'User', 'test@example.com';
GO

-- Verify the data
SELECT * FROM [dbo].[user];
GO
