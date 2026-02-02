--Identify duplicate records and records with a NULL Customer ID
select cst_id, count(*)
from silver.crm_cst_info
group by cst_id
having count(*)> 1 OR cst_id is null;

-- Identify rows where the first name has leading or trailing spaces
select cst_firstname
from silver.crm_cst_info
where cst_firstname!=trim(cst_firstname);

-- data standarization & data consistency 
select  distinct cst_gndr
from silver.crm_cst_info;


