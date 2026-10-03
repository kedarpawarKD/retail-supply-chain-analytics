/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'RetailSupplyChainDW' after checking if it already exists. 
    If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas 
    within the database: 'bronze', 'silver', and 'gold'.
	
WARNING:
    Running this script will drop the entire 'RetailSupplyChainDW' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/

USE master;
GO
   
-- Drop and recreate the 'RetailSupplyChainDW' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'RetailSupplyChainDW')
BEGIN
    ALTER DATABASE RetailSupplyChainDW SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE RetailSupplyChainDW;
END;
GO

-- Create the 'RetailSupplyChainDW' database
CREATE DATABASE RetailSupplyChainDW;
GO

USE RetailSupplyChainDW;
GO

-- Create schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
