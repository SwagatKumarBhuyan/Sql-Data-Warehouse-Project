
 -- 1. Check For Nulls or Duplicates in primary key
-- Expectation: No Result
SELECT
cst_id,
Count(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL


 -- 2. Check For Unwanted Spaces
 -- Expectation : No results
 SELECT 
 cst_firstName
 FROM silver.crm_cust_info
 WHERE  cst_firstName != TRIM( cst_firstName);

 -- 3. Data Standardisation & Consistency
 SELECT DISTINCT cst_gndr
 FROM silver.crm_cust_info

-- 4.Check if prd_cost is negative or null
SELECT prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL

-- 5. Data Standardisation and Data Consistencty
SELECT DISTINCT prd_line
FROM bronze.crm_prd_info

-- 6. Check for Invalid Date Orders
SELECT *
FROM bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt

-- 7.Check For Invalid Dates
SELECT
NULLIF(sls_order_dt,0) AS sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0 
OR LEN(sls_order_dt) != 8
OR sls_order_dt > 20500101
OR sls_order_dt < 19000101

-- 8. Check For Invalid Date Orders
SELECT
*
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt

-- 9. Check Data Consistency : Between Sales , Quantity , and Price
--- >> Sales = Quantity * Price
---- >> Values must not be NULL , zero, or negative
SELECT DISTINCT
sls_sales,
sls_quantity,
sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales , sls_quantity , sls_price

-- 10. Identify Out-Of-Range Dates
SELECT DISTINCT
bdate
FROM bronze.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE()

-- 11.Data Standardisation & Consistency
SELECT DISTINCT gen
FROM bronze.erp_cust_az12

-- 12. Data Standardisation $ Consistency
SELECT DISTINCT cntry
FROM bronze.erp_loc_a101
ORDER BY cntry

-- 13. Check For Unwanted Spaces
SELECT * FROM bronze.erp_px_cat_g1v2
Where cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance)

-- 14. Data Standardisation $ Consistency
SELECT DISTINCT maintenance
FROM bronze.erp_px_cat_g1v2
