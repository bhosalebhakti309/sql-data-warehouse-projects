truncate table silver.erp_cust_AZ12;
insert into silver.erp_cust_AZ12(cid,bdate, gen )
select
case when cid like 'NAS%' then substring(cid,4, len(cid))
else cid
end cid,
case when bdate > getdate() then null
else bdate
end as bdate,
case when upper(trim(gen)) in ('F','Female') then 'Female'
when upper(trim(gen)) in ('M' , 'Male') then 'Male'
else 'n/a'
end as gen
from bronze.erp_cust_AZ12;
--select* from [silver].[crm_cst_info];
select distinct gen from silver.erp_cust_AZ12;