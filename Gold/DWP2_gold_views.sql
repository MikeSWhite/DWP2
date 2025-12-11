


SELECT
ROW_NUMBER() OVER(ORDER BY cst_id) AS customer_key,
ci.cst_id AS customer_id,
ci.cst_key AS customer_number,
ci.cst_firstname AS first_name,
ci.cst_lastname AS last_name,
CASE WHEN ci.cst_gdr != 'N/A' THEN ci.cst_gdr -- CRM is the master for gender info
	ELSE COALESCE(ca.gen, 'N/A')
    END AS gender,
la.cntry AS country,
ci.cst_marital_status AS marital_status,
ca.bdate AS birthdate,
ci.cst_create_date AS create_date
FROM silver2.crm_cust_info AS ci
LEFT JOIN silver2.erp_cust_az12 AS ca
ON ci.cst_key = ca.cid
LEFT JOIN silver2.erp_loc_a101 AS la
ON ci.cst_key = la.cid;


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


SELECT 
sd.sls_ord_num AS order_number,
pr.product_key,
cu.customer_key,
sd.sls_order_dt AS order_date,
sd.sls_ship_dt AS shipping_date,
sd.sls_due_dt AS due_date,
sd.sls_sales AS sales_amount,
sd.sls_quantity AS quantity,
sd.sls_price AS price
FROM silver2.crm_sales_details AS sd
LEFT JOIN gold2.dim_products AS pr
ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold2.dim_customers AS cu
ON sd.sls_cust_id = cu.customer_id;
