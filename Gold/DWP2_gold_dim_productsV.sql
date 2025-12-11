

SELECT 
pn.prd_id,
pn.cat_id,
pn.prd_key,
pn.prd_nm,
pn.prd_cost,
pn.prd_line,
pn.prd_start_dt,
pn.prd_end_dt
FROM silver2.crm_prd_info AS pn
WHERE prd_end_dt IS NULL; -- filter out all historical data


SELECT 
	pn.prd_id,
    pn.prd_key,
    pn.prd_nm,
	pn.cat_id,
    pc.cat,
    pc.subcat,
    pc.maintenance,
	pn.prd_cost,
	pn.prd_line,
	pn.prd_start_dt
FROM silver2.crm_prd_info AS pn
LEFT JOIN silver2.erp_px_cat_g1v2 AS pc
ON pn.cat_id = pc.id
WHERE prd_end_dt IS NULL;

SELECT prd_key, COUNT(*) FROM (
SELECT 
	pn.prd_id,
	pn.cat_id,
	pn.prd_key,
	pn.prd_nm,
	pn.prd_cost,
	pn.prd_line,
	pn.prd_start_dt,
	pc.cat,
	pc.subcat,
	pc.maintenance
FROM silver2.crm_prd_info AS pn
LEFT JOIN silver2.erp_px_cat_g1v2 AS pc
ON pn.cat_id = pc.id
WHERE prd_end_dt IS NULL) AS check1
GROUP BY prd_key
HAVING COUNT(*) >1;



CREATE VIEW gold2.dim_products AS 
SELECT 
	ROW_NUMBER() OVER(ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,
	pn.prd_id AS product_id,
    pn.prd_key AS product_number,
    pn.prd_nm AS product_name,
	pn.cat_id AS catagory_id,
    pc.cat AS catagory,
    pc.subcat AS subcatagory,
    pc.maintenance,
	pn.prd_cost AS cost,
	pn.prd_line AS product_line,
	pn.prd_start_dt AS start_date
FROM silver2.crm_prd_info AS pn
LEFT JOIN silver2.erp_px_cat_g1v2 AS pc
ON pn.cat_id = pc.id
WHERE prd_end_dt IS NULL;