

-- Silver uploads

SELECT 'Truncating silver2.crm_cust_info';
	TRUNCATE TABLE silver2.crm_cust_info;
SELECT 'Loading data for silver2.crm_cust_info';    
	LOAD DATA INFILE 'C:\\DW-2\\source_crm\\cust_info.csv'
	INTO TABLE silver2.crm_cust_info
	FIELDS TERMINATED BY ','
	LINES TERMINATED BY '\n'
	IGNORE 1 LINES;
SELECT 'Load Duration: 0.187 sec';
SELECT current_timestamp();
SELECT 'C:\\DW-2\\source_crm\\cust_info.csv';


SELECT 'Truncating silver2.crm_prd_info';
	TRUNCATE TABLE silver2.crm_prd_info;
SELECT 'Loading data for silver2.crm_prd_info';    
	LOAD DATA INFILE 'C:\\DW-2\\source_crm\\prd_info.csv'
	INTO TABLE silver2.crm_prd_info
	FIELDS TERMINATED BY ','
	LINES TERMINATED BY '\n'
	IGNORE 1 LINES;
SELECT 'Load Duration: 0.016 sec';
SELECT current_timestamp();
SELECT 'C:\\DW-2\\source_crm\\prd_info.csv';


SELECT 'Truncating silver2.crm_sales_details';
	TRUNCATE TABLE silver2.crm_sales_details;
SELECT 'Loading data for silver2.crm_sales_details';    
	LOAD DATA INFILE 'C:\\DW-2\\source_crm\\sales_details.csv'
	INTO TABLE silver2.crm_sales_details
	FIELDS TERMINATED BY ','
	LINES TERMINATED BY '\n'
	IGNORE 1 LINES;
SELECT 'Load Duration: 1.016 sec';
SELECT current_timestamp();
SELECT 'C:\\DW-2\\source_crm\\sales_details.csv';


SELECT 'Truncating silver2.erp_cust_az12';
	TRUNCATE TABLE silver2.erp_cust_az12;
SELECT 'Loading data for silver2.erp_cust_az12';    
	LOAD DATA INFILE 'C:\\DW-2\\source_erp\\CUST_AZ12.csv'
	INTO TABLE silver2.erp_cust_az12
	FIELDS TERMINATED BY ','
    ENCLOSED BY ""
	LINES TERMINATED BY '\n'
	IGNORE 1 LINES;
SELECT 'Load Duration: 0.125 sec';
SELECT current_timestamp();
SELECT 'C:\\DW-2\\source_erp\\CUST_AZ12.csv';


SELECT 'Truncating silver2.erp_loc_a101';
	TRUNCATE TABLE silver2.erp_loc_a101;
SELECT 'Loading data for silver2.erp_loc_a101';    
	LOAD DATA INFILE 'C:\\DW-2\\source_erp\\LOC_A101.csv'
	INTO TABLE silver2.erp_loc_a101
	FIELDS TERMINATED BY ','
    ENCLOSED BY ""
	LINES TERMINATED BY '\n'
	IGNORE 1 LINES;
SELECT 'Load Duration: 0.125 sec';
SELECT current_timestamp();
SELECT 'C:\\DW-2\\source_erp\\LOC_A101.csv';


SELECT 'Truncating silver2.erp_px_cat_g1v2';
	TRUNCATE TABLE silver2.erp_px_cat_g1v2;
SELECT 'Loading data for silver2.erp_px_cat_g1v2 ';    
	LOAD DATA INFILE 'C:\\DW-2\\source_erp\\PX_CAT_G1V2.csv'
	INTO TABLE silver2.erp_px_cat_g1v2
	FIELDS TERMINATED BY ','
    ENCLOSED BY ""
	LINES TERMINATED BY '\n'
	IGNORE 1 LINES;
SELECT 'Load Duration: 0.000 sec';
SELECT current_timestamp();
SELECT 'C:\\DW-2\\source_erp\\PX_CAT_G1V2.csv';
