truncate table silver.erp_px_cat_G1V2;
insert into silver.erp_px_cat_G1V2 (id,cat,subcat,maintenance)
select 
 id,

cat,
subcat,
maintenance
from bronze.erp_px_cat_G1V2 
where id not in (select cat_id from silver.crm_prd_info)
;

select * from silver.crm_prd_info;
use DataWarehouse;

--check for unwanted spaces
select * from bronze.erp_px_cat_G1V2
where cat != trim(cat) or subcat != trim(subcat)
 or maintenance != trim(maintenance)

 --data standardization & consistency
 select distinct subcat from bronze.erp_px_cat_G1V2;
