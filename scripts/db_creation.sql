/*

=============================================
CREATE DATABASE AND SCHEMAS
=============================================

Script :

This Script CREATE database Telcomm_db after Checking it already exits or not 
if not exists then it CREATE database Telcomm_db
if exists then it DROP it and RECREATE

WARNING :

Running this Script will drop the Telcomm_db database if it is exists
all data in the database will be permanently deleted.

*/

USE master;
GO

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'Telcomm_db')
BEGIN
    -- It revoke all connection which use this database 
    ALTER DATABASE Telcomm_db SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Telcomm_db;
END
GO

-- Create the database
CREATE DATABASE Telcomm_db;
GO                                          

-- Now the database exists, so USE works
USE Telcomm_db;
GO

-- Create the schemas (only if they do not already exist)
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'bronze')
    EXEC('CREATE SCHEMA bronze');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'silver')
    EXEC('CREATE SCHEMA silver');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'gold')
    EXEC('CREATE SCHEMA gold');
GO