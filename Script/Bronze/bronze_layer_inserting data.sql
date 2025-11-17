
/*  
==================================================================
Stored Procedure : Load Bronze Layer (Source -> Bronze)
=================================================================
Script Purpose :
This stored procedure loads data into the 'bronze' schema from external CSV files.
It performs the following actions: 
-Truncate the bronze tables before loading data.
-uses the 'bulk insert' command to load data from csv files to bronze tables.
*/

create or alter procedure bronze.load_bronze as

BEGIN 
    DECLARE @START_TIME DATETIME, @END_TIME DATETIME;

    BEGIN TRY
        print '==========================================================================';
        print 'Loading bronze layer';
        print '==========================================================================';


        print '----------------------------------------------------------------------------';
        print 'Loading CRM tables';
        print '---------------------------------------------------------------------------';

        SET @START_TIME = GETDATE();
        print '>> Truncating table : bronze.crm_cust_info';
        truncate table bronze.crm_cst_info;

        print '>> Inserting Data Into : bronze.crm_cust_info';
        bulk insert bronze.crm_cst_info
        from 'C:\Users\Admin\Desktop\sql\Datasets\crm\cust_info.csv'
        with (
            firstrow = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @END_TIME = GETDATE();
        PRINT '>> Load duration : ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';
        print '>>-----------------------------------------';

        Alter table bronze.crm_prd_info
        ALTER COLUMN prd_end_dt varchar(20);

        set @START_TIME = GETDATE();
        print 'truncate table : bronze.crm_prd_info';
        truncate table bronze.crm_prd_info;

        print 'Insert data into : bronze.crm_prd_info';
        bulk insert bronze.crm_prd_info
        from 'C:\Users\Admin\Desktop\sql\Datasets\crm\prd_info.csv'
        with (
            firstrow = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        set @END_TIME = GETDATE();
        print 'load duration :' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';

        update bronze.crm_prd_info
        set prd_end_dt = TRY_CONVERT(datetime, prd_end_dt, 105);

        set @start_time = getdate();
        print 'truncate table : bronze.crm_sales_details';
        truncate table bronze.crm_sales_details;

        print 'insert data into : bronze.crm_sales_details';
        bulk insert bronze.crm_sales_details
        from 'C:\Users\Admin\Desktop\sql\Datasets\crm\sales_details.csv'
        with (
            firstrow = 2,
            fieldterminator = ',',
            tablock
        );

        set @end_time = getdate();
        print 'load duration :' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';

        print '====================================================================================';
        print 'loading data into erp tables';
        print '====================================================================================';

        set @START_TIME = getdate();
        print 'truncate table bronze.erp_cust_AZ12';
        truncate table bronze.erp_cust_AZ12;

        print 'insert data into : bronze.erp_cust_AZ12';
        bulk insert bronze.erp_cust_AZ12
        from 'C:\Users\Admin\Desktop\sql\Datasets\erp\CUST_AZ12.csv'
        with (
            firstrow = 2,
            fieldterminator = ',',
            tablock
        );

        set @END_TIME = getdate();
        print 'loading data time : ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';

        set @start_time = getdate();
        print 'truncate table bronze.erp_loc_A101';
        truncate table bronze.erp_loc_A101;

        print 'insert data info : bronze.erp_loc_A101';
        bulk insert bronze.erp_loc_A101
        from 'C:\Users\Admin\Desktop\sql\Datasets\erp\LOC_A101.csv'
        with (
            firstrow = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        set @end_time = getdate();
        print 'loading time :' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';

        set @START_TIME = getdate();
        print 'truncate table bronze.erp_px_cat_G1V2';
        truncate table bronze.erp_px_cat_G1V2;

        print 'insert data into : bronze.erp_px_cat_G1V2';
        bulk insert bronze.erp_px_cat_G1V2
        from 'C:\Users\Admin\Desktop\sql\Datasets\erp\PX_CAT_G1V2.csv'
        with (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        set @end_time = getdate();
        print 'load data :' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';

    END TRY

    BEGIN CATCH
        PRINT '-----------------------------------------------------------------------';
        PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
        PRINT 'ERROR MESSAGE ' + ERROR_MESSAGE();
        PRINT 'ERROR NUMBER ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'ERROR STATE ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '-----------------------------------------------------------------------';
    END CATCH
END

exec bronze.load_bronze;