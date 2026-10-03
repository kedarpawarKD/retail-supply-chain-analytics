/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV file. 
    It performs the following action:
    - Truncates the bronze table before loading data.
    - Uses the `BULK INSERT` command to load data from csv File to bronze table.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE @batch_start_time DATETIME, @batch_end_time DATETIME;
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '================================================';
        PRINT 'Loading Bronze Layer';
        PRINT '================================================';

        PRINT '>> Truncating Table: bronze.order_fulfillment_raw';
        TRUNCATE TABLE bronze.order_fulfillment_raw;
        PRINT '>> Inserting Data Into: bronze.order_fulfillment_raw';
        BULK INSERT bronze.order_fulfillment_raw
        FROM 'C:\RSCDW Dataset\DataCoSupplyChainDataset.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0A',
            TABLOCK,
            KEEPNULLS
        );
        SET @batch_end_time = GETDATE();
        PRINT '===============================================';
		PRINT 'Loading Bronze Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(MILLISECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' Milliseconds';
		PRINT '===============================================';
	END TRY
	BEGIN CATCH
		PRINT '===============================================';
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Number' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error State' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '===============================================';
	END CATCH
END;
