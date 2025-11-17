/*
=================================================================
Create Database and Schemas 
=================================================================
Script Purpose:
This script creates a new database named 'DataWarehouse' after checking if it already exists. If the database exists, it is dropped and recreated.
Additionally, the script sets up three schemas within the database: 'bronze' , 'silver'  and 'gold'.
*/


-- Create Database 'Datawarehouse

Use master;


--Drop and recreate the 'DataWarehouse' database
If exists( select 1 from sys.databases where name = 'DataWarehouse')
Begin
alter database DataWarehouse set single_user with rollback immediate;
drop database dataWarehouse;
End;
go


-- create the DataWarehouse database
create database DataWarehouse;

use DataWarehouse;


-- create schemas
create schema bronze;
Go

create schema silver;
Go

create schema gold;
Go
