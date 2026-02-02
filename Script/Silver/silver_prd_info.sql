truncate table silver.crm_prd_info ;
insert into silver.crm_prd_info(
prd_id,cat_id, prd_key,prd_nm,prd_cost, prd_line,prd_start_dt, prd_end_dt
)
select 
    prd_id,
    replace(SUBSTRING(prd_key, 1, 5),'-','_') as cat_id,
    SUBSTRING(prd_key, 7, len(prd_key)) as prd_key,
    prd_nm,
    isnull(prd_cost,0) as prd_cost,
    case upper(trim(prd_line))
        when 'M' then 'Mountain'
        when 'R' then 'Road'
        when 'S' then 'Other Sales'
        when 'T' then 'Touring'
        else 'N/A'
    end as prd_line,
    cast(prd_start_dt as date) as prd_start_dt,
    
    -- ? FIX: Use DATEADD instead of subtracting 1 from a date
    cast(
        DATEADD(
            day,
            -1,
            lead(prd_start_dt) over (
                partition by prd_key 
                order by prd_start_dt
            )
        ) as date
    ) as prd_end_dt_test

from bronze.crm_prd_info;











-- before moivng toward data we have to check quality issues in our data 
-- first will check for the values which duplicates as well null i will group it by using primary key

select distinct id from bronze.erp_px_cat_G1V2;
use DataWarehouse;
select * from bronze.crm_prd_info;

select prd_cost from bronze.crm_prd_info
where prd_cost <0 or prd_cost is null;

select Prd_line from bronze.crm_prd_info;
--check for invalid date 
select * from bronze.crm_prd_info;
select * from bronze.crm_prd_info
where prd_end_dt < prd_start_dt;

-- checking for data quality issues
select* from silver.crm_prd_info;
-- check for nulls or duplicates in primary key
select prd_id , count(*)
from silver.crm_prd_info 
group by prd_id
having prd_id is null or count(*)>1;

-- data normalization
select distinct prd_line
from silver.crm_prd_info;

-- check for invalid date orders
select* 
from silver.crm_prd_info
where prd_end_dt< prd_start_dt;