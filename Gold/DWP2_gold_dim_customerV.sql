
CREATE SCHEMA gold2;


SELECT *
FROM silver2.crm_cust_info;

SELECT
ci.cst_id,
ci.cst_key,
ci.cst_firstname,
ci.cst_lastname,
ci.cst_marital_status,
ci.cst_gdr,
ci.cst_create_date,
ca.bdate,
ca.gen,
la.cntry
FROM silver2.crm_cust_info AS ci
LEFT JOIN silver2.erp_cust_az12 AS ca
ON ci.cst_key = ca.cid
LEFT JOIN silver2.erp_loc_a101 AS la
ON ci.cst_key = la.cid;


SELECT cst_id, COUNT(*) FROM (
SELECT
ci.cst_id,
ci.cst_key,
ci.cst_firstname,
ci.cst_lastname,
ci.cst_marital_status,
ci.cst_gdr,
ci.cst_create_date,
ca.bdate,
ca.gen,
la.cntry
FROM silver2.crm_cust_info AS ci
LEFT JOIN silver2.erp_cust_az12 AS ca
ON ci.cst_key = ca.cid
LEFT JOIN silver2.erp_loc_a101 AS la
ON ci.cst_key = la.cid) AS j_tables
GROUP BY cst_id
HAVING COUNT(*) > 1;


SELECT DISTINCT
ci.cst_gdr,
ca.gen,
CASE WHEN ci.cst_gdr != 'N/A' THEN ci.cst_gdr -- CRM is the master for gender info
	ELSE COALESCE(ca.gen, 'N/A')
    END AS new_gen
FROM silver2.crm_cust_info AS ci
LEFT JOIN silver2.erp_cust_az12 AS ca
ON ci.cst_key = ca.cid
LEFT JOIN silver2.erp_loc_a101 AS la
ON ci.cst_key = la.cid;


SELECT
ci.cst_id,
ci.cst_key,
ci.cst_firstname,
ci.cst_lastname,
ci.cst_marital_status,
ci.cst_create_date,
ca.bdate,
la.cntry,
CASE WHEN ci.cst_gdr != 'N/A' THEN ci.cst_gdr -- CRM is the master for gender info
	ELSE COALESCE(ca.gen, 'N/A')
    END AS new_gen
FROM silver2.crm_cust_info AS ci
LEFT JOIN silver2.erp_cust_az12 AS ca
ON ci.cst_key = ca.cid
LEFT JOIN silver2.erp_loc_a101 AS la
ON ci.cst_key = la.cid;


SELECT
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




CREATE VIEW gold2.dim_customers AS
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