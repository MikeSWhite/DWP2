
-- Loading bronze tables

DELIMITER $$
CREATE PROCEDURE bronze2_tables()
BEGIN
	DROP TABLE IF EXISTS bronze2.crm_cust_info;
	CREATE TABLE bronze2.crm_cust_info (
	cst_id VARCHAR(100),
	cst_key VARCHAR(100),
	cst_firstname VARCHAR(100),
	cst_lastname VARCHAR(100),
	cst_marital_status VARCHAR(100),
	cst_gdr VARCHAR(100),
	cst_create_date VARCHAR(100)
	);

	DROP TABLE IF EXISTS bronze2.crm_prd_info;
	CREATE TABLE bronze2.crm_prd_info (
	prd_id VARCHAR(100),
	prd_key VARCHAR(100),
	prd_nm VARCHAR(100),
	prd_cost VARCHAR(100),
	prd_line VARCHAR(100),
	prd_start_dt VARCHAR(100),
	prd_end_dt VARCHAR(100)
	);


	DROP TABLE IF EXISTS bronze2.crm_sales_details;
	CREATE TABLE bronze2.crm_sales_details (
	sls_ord_num VARCHAR(100),
	sls_prd_key VARCHAR(100),
	sls_cust_id INT,
	sls_order_dt INT,
	sls_ship_dt INT,
	sls_due_dt INT,
	sls_sales VARCHAR(100),
	sls_quantity INT,
	sls_price VARCHAR(100)
	);


	DROP TABLE IF EXISTS bronze2.erp_cust_az12;
	CREATE TABLE bronze2.erp_cust_az12 (
	cid VARCHAR(100),
	Bdate VARCHAR(100),
	gen VARCHAR(50)
	);


	DROP TABLE IF EXISTS bronze2.erp_loc_a101;
	CREATE TABLE bronze2.erp_loc_a101 (
	cid VARCHAR(100),
	cntry VARCHAR(50)
	);


	DROP TABLE IF EXISTS bronze2.erp_px_cat_g1v2;
	CREATE TABLE bronze2.erp_px_cat_g1v2 (
	id VARCHAR(100),
	cat VARCHAR(100),
	subcat VARCHAR(100),
	maintenance VARCHAR(50)
	);
END $$
DELIMITER ;