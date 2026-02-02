use DataWarehouse;

select * 
from bronze.crm_cst_info
where cst_id = 29466;

truncate table silver.crm_cst_info;
insert into silver.crm_cst_info(cst_id, cst_key, cst_firstname, cst_lastname , cst_marital_status, cst_gndr, cst_create_date)
select 
cst_id,
cst_key,
trim(cst_firstname) as cst_firstname,
trim(cst_lastname) as cst_lastname,
case when upper(trim(cst_marital_status)) = 'S' then 'Single'
when upper(trim(cst_marital_status))= 'M' then 'married'
else 'n/a'
end as cst_marital_status,
case when upper(trim(cst_gndr)) = 'F' then 'female'
when upper(trim(cst_gndr)) = 'M' then 'male'
else 'n/a'
end as cst_gndr,
cst_create_date from
(select 
*,
row_number() over (partition by cst_id order by cst_create_date DESC) as flag_last 
from bronze.crm_cst_info
where cst_id is not null
)t 
where flag_last=1;









use DataWarehouse;

--Check for Nulls or Duplicates in Primary key
select cst_id, count(*) as repeated_time
from bronze.crm_cst_info
group by cst_id
having count(*)> 1 OR cst_id is null;

-- check for unwanted spaces
-- expectation : no result 
select cst_firstname
from bronze.crm_cst_info
where cst_firstname!= trim(cst_firstname);

-- data standarization & consistency 
select  distinct cst_gndr
from bronze.crm_cst_info;







