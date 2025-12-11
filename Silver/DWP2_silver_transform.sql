-- Transform script

DELIMITER $$
CREATE PROCEDURE silver2_transform()
BEGIN

	SELECT 'Updateing silver2.crm_cust_info';
	UPDATE silver2.crm_cust_info
	SET 
		cst_firstname = TRIM(cst_firstname),
		cst_lastname = TRIM(cst_lastname),
		cst_marital_status = CASE 
			WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
			WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
			ELSE 'N/A' -- normalizing the marital status
		END,
		cst_gdr = CASE 
			WHEN UPPER(TRIM(cst_gdr)) = 'F' THEN 'Female'
			WHEN UPPER(TRIM(cst_gdr)) = 'M' THEN 'Male'
			ELSE 'N/A' -- normalizing the gender
		END;
		
	ALTER TABLE silver2.crm_cust_info
	ADD COLUMN dup_flag INT DEFAULT NULL;

	WITH ranked AS (
		SELECT
			cst_id,
			cst_create_date,
			ROW_NUMBER() OVER (
				PARTITION BY cst_id
				ORDER BY cst_create_date DESC
			) AS rn
		FROM silver2.crm_cust_info
	)
	UPDATE silver2.crm_cust_info AS t
	JOIN ranked AS r
		ON t.cst_id = r.cst_id
	   AND t.cst_create_date = r.cst_create_date
	SET t.dup_flag = r.rn; -- identifying duplicates 

	DELETE FROM silver2.crm_cust_info -- removing duplicates
	WHERE dup_flag > 1;

	DELETE FROM silver2.crm_cust_info
	WHERE cst_id = '0';

	ALTER TABLE silver2.crm_cust_info
	DROP COLUMN dup_flag;

	UPDATE silver2.crm_cust_info
	SET cst_create_date = STR_TO_DATE(cst_create_date, '%m/%d/%Y');

	ALTER TABLE silver2.crm_cust_info
	MODIFY COLUMN cst_create_date DATE;
	SELECT NOW();

	-- crm_prd_info 
	SELECT 'updating crm_prd_info';

	ALTER TABLE silver2.crm_prd_info
	ADD COLUMN cat_id VARCHAR(50);

	UPDATE silver2.crm_prd_info
	SET cat_id =
	REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_');

	UPDATE silver2.crm_prd_info
	 SET prd_key = SUBSTRING(prd_key, 7, LENGTH(prd_key));
	 
	 UPDATE silver2.crm_prd_info
	 SET prd_cost = REPLACE(prd_cost, " ", '0');
	 
	  UPDATE silver2.crm_prd_info
	  SET prd_line = CASE WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
			WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
			WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
			WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
			ELSE 'N/A'
		END;
		
	UPDATE silver2.crm_prd_info
	SET prd_start_dt = CAST(prd_start_dt AS DATE);
		
	WITH RankedProducts AS (
		SELECT
			prd_key,
			prd_start_dt,
			LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt) - INTERVAL 1 DAY AS calculated_prd_end_dt
		FROM
			silver2.crm_prd_info
	)
	UPDATE silver2.crm_prd_info AS t
	JOIN RankedProducts AS rp
	ON t.prd_key = rp.prd_key AND t.prd_start_dt = rp.prd_start_dt
	SET t.prd_end_dt = rp.calculated_prd_end_dt;
	SELECT NOW();

	-- crm_slaes_details

	SELECT 'Updateing silver2.crm_sales_details';

	ALTER TABLE silver2.crm_sales_details
	MODIFY COLUMN sls_order_dt VARCHAR(50);

	UPDATE silver2.crm_sales_details
	SET sls_order_dt = CASE WHEN sls_order_dt = 0 OR LENGTH(sls_order_dt) != 8 THEN NULL
	ELSE CAST(sls_order_dt AS DATE)
	END;

	ALTER TABLE silver2.crm_sales_details
	MODIFY COLUMN sls_ship_dt VARCHAR(50);

	UPDATE silver2.crm_sales_details
	 SET sls_ship_dt = CASE
	 WHEN sls_ship_dt = 0 OR LENGTH(sls_ship_dt) != 8 THEN NULL
	ELSE CAST(sls_ship_dt AS DATE)
	END;

	ALTER TABLE silver2.crm_sales_details
	MODIFY COLUMN sls_due_dt VARCHAR(50);

	UPDATE silver2.crm_sales_details
	SET sls_due_dt =
	CASE WHEN sls_due_dt = 0 OR LENGTH(sls_due_dt) != 8 THEN NULL
	ELSE CAST(sls_due_dt AS DATE) 
	END;

	UPDATE silver2.crm_sales_details
	SET sls_sales = CASE
	 WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
		THEN sls_quantity * ABS(sls_price)
		ELSE sls_sales
	END;

	UPDATE silver2.crm_sales_details
	SET sls_price = CASE
	 WHEN sls_price IS NULL OR sls_price <= 0
		THEN sls_price / NullIF(sls_quantity, 0)
		ELSE sls_price
	END;
	SELECT NOW();

	-- erp_cust_az12

	SELECT 'Updating erp_cust_az12';
	UPDATE silver2.erp_cust_az12
	SET Bdate = STR_TO_DATE(Bdate, '%m/%d/%Y');

	UPDATE silver2.erp_cust_az12
	SET cid =
	 CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING( cid, 4, LENGTH(cid))
		ELSE cid
	END;

	UPDATE silver2.erp_cust_az12
	SET Bdate =
	CASE WHEN Bdate > NOW() THEN NULL
		ELSE Bdate
	END;

	UPDATE silver2.erp_cust_az12
	SET gen =
		CASE
			WHEN UPPER(REPLACE(REPLACE(REPLACE(TRIM(gen), CHAR(13), ''), CHAR(10), ''), CHAR(9), ''))
				 IN ('F', 'FEMALE') THEN 'Female'
			WHEN UPPER(REPLACE(REPLACE(REPLACE(TRIM(gen), CHAR(13), ''), CHAR(10), ''), CHAR(9), ''))
				 IN ('M', 'MALE') THEN 'Male'
			ELSE 'N/A'
	END;
		
	SELECT NOW();

	-- erp_loc_a101

	SELECT 'Updating silvers.erp_loc_a101';

	Update silver2.erp_loc_a101
	SET cid = REPLACE(cid, '-', '');

	UPDATE silver2.erp_loc_a101
	SET cntry = CASE
			WHEN UPPER(
				 REPLACE(REPLACE(REPLACE(TRIM(cntry), CHAR(13), ''), CHAR(10), ''), CHAR(9), '')
			) = 'DE' THEN 'Germany'

			WHEN UPPER(
				 REPLACE(REPLACE(REPLACE(TRIM(cntry), CHAR(13), ''), CHAR(10), ''), CHAR(9), '')
			) IN ('US','USA') THEN 'United States'

			WHEN cntry IS NULL
			  OR TRIM(
				 REPLACE(REPLACE(REPLACE(cntry, CHAR(13), ''), CHAR(10), ''), CHAR(9), '')
			) = '' THEN 'N/A'

			ELSE TRIM(
				 REPLACE(REPLACE(REPLACE(cntry, CHAR(13), ''), CHAR(10), ''), CHAR(9), '')
			)
		END;
		SELECT NOW();

	-- erp_px_cat_g1v2

	SELECT 'erp_px_cat_g1v2 needs no updates';
	 SELECT NOW();
END $$
DELIMITER ;


-- Original Queries


SELECT 'updating crm_prd_info';
SELECT
prd_id,
prd_key,
REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS prd_key,
prd_nm,
REPLACE(prd_cost, " ", '0') AS prd_cost,
CASE WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
	WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
	WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
    WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
    ELSE 'N/A'
END AS prd_line,
CAST(prd_start_dt AS DATE) AS prd_start_dt,
LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt) -1 AS prd_end_dt
FROM silver2.crm_prd_info;

SELECT 
sls_ord_num,
sls_prd_key,
sls_cust_id,
CASE WHEN sls_order_dt = 0 OR LENGTH(sls_order_dt) != 8 THEN NULL
	ELSE CAST(sls_order_dt AS DATE) 
END AS sls_order_dt,
CASE WHEN sls_ship_dt = 0 OR LENGTH(sls_ship_dt) != 8 THEN NULL
	ELSE CAST(sls_ship_dt AS DATE) 
END AS sls_ship_dt,
CASE WHEN sls_due_dt = 0 OR LENGTH(sls_due_dt) != 8 THEN NULL
	ELSE CAST(sls_due_dt AS DATE) 
END AS sls_due_dt,
CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
	THEN sls_quantity * ABS(sls_price)
    ELSE sls_sales
END AS sls_sales,
sls_quantity,
CASE WHEN sls_price IS NULL OR sls_price <= 0
	THEN sls_price / NullIF(sls_quantity, 0)
    ELSE sls_price
END AS sls_price
FROM silver2.crm_sales_details;



SELECT 
CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid))
	ELSE cid
END cid,
CASE WHEN Bdate > NOW() THEN NULL
	ELSE Bdate
END AS Bdate,
CASE WHEN UPPER(TRIM(gen)) = 'F' THEN 'Female'
	WHEN UPPER(TRIM(gen)) = 'M' THEN 'Male'
    ELSE 'N/A'
END AS gen
FROM silver2.erp_cust_az12;



SELECT 
REPLACE(cid, '-', '') cid,
CASE WHEN TRIM(cntry) = 'DE' THEN 'GERMANY'
	WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
    WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'N/A'
    ELSE TRIM(cntry)
END AS cntry
FROM silver2.erp_loc_a101;