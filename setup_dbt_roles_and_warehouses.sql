-- ============================================
-- Script: setup_dbt_roles_and_warehouses.sql
-- Purpose: Initialize dbt roles, user, warehouses, and permissions in Snowflake
-- Author: Cheikh Tidiane
-- ============================================

-- Step 1: Use the SECURITYADMIN role to create and manage roles and users
USE ROLE securityadmin;

-- Create roles for development and production environments
CREATE OR REPLACE ROLE dbt_dev_role;
CREATE OR REPLACE ROLE dbt_prod_role;

-- Create a dbt user and assign the previously created roles
CREATE OR REPLACE USER dbt_user PASSWORD = "dbtquickstarts9494";
GRANT ROLE dbt_dev_role, dbt_prod_role TO USER dbt_user;

-- Also assign the roles to SYSADMIN for admin-level access
GRANT ROLE dbt_dev_role, dbt_prod_role TO ROLE sysadmin;

-- Step 2: Switch to SYSADMIN to create and manage warehouses and databases
USE ROLE sysadmin;

-- Create development and production warehouses with auto-suspend/resume enabled
CREATE OR REPLACE WAREHOUSE dbt_dev_wh WITH 
    WAREHOUSE_SIZE = 'XSMALL' 
    AUTO_SUSPEND = 60 
    AUTO_RESUME = TRUE 
    MIN_CLUSTER_COUNT = 1 
    MAX_CLUSTER_COUNT = 1 
    INITIALLY_SUSPENDED = TRUE;

CREATE OR REPLACE WAREHOUSE dbt_dev_heavy_wh WITH 
    WAREHOUSE_SIZE = 'LARGE' 
    AUTO_SUSPEND = 60 
    AUTO_RESUME = TRUE 
    MIN_CLUSTER_COUNT = 1 
    MAX_CLUSTER_COUNT = 1 
    INITIALLY_SUSPENDED = TRUE;

CREATE OR REPLACE WAREHOUSE dbt_prod_wh WITH 
    WAREHOUSE_SIZE = 'XSMALL' 
    AUTO_SUSPEND = 60 
    AUTO_RESUME = TRUE 
    MIN_CLUSTER_COUNT = 1 
    MAX_CLUSTER_COUNT = 1 
    INITIALLY_SUSPENDED = TRUE;

CREATE OR REPLACE WAREHOUSE dbt_prod_heavy_wh WITH 
    WAREHOUSE_SIZE = 'LARGE' 
    AUTO_SUSPEND = 60 
    AUTO_RESUME = TRUE 
    MIN_CLUSTER_COUNT = 1 
    MAX_CLUSTER_COUNT = 1 
    INITIALLY_SUSPENDED = TRUE;

-- Grant warehouse access to appropriate roles
GRANT ALL ON WAREHOUSE dbt_dev_wh TO ROLE dbt_dev_role;
GRANT ALL ON WAREHOUSE dbt_dev_heavy_wh TO ROLE dbt_dev_role;
GRANT ALL ON WAREHOUSE dbt_prod_wh TO ROLE dbt_prod_role;
GRANT ALL ON WAREHOUSE dbt_prod_heavy_wh TO ROLE dbt_prod_role;

-- Create dev and prod databases for dbt
CREATE OR REPLACE DATABASE dbt_hol_dev;
CREATE OR REPLACE DATABASE dbt_hol_prod;

-- Grant access to the dbt roles on the databases
GRANT ALL ON DATABASE dbt_hol_dev TO ROLE dbt_dev_role;
GRANT ALL ON DATABASE dbt_hol_prod TO ROLE dbt_prod_role;

-- Grant permissions on all schemas within those databases
GRANT ALL ON ALL SCHEMAS IN DATABASE dbt_hol_dev TO ROLE dbt_dev_role;
GRANT ALL ON ALL SCHEMAS IN DATABASE dbt_hol_prod TO ROLE dbt_prod_role;

-- Step 3: Grant access to external raw data sources (if applicable)
-- Use ACCOUNTADMIN to access and grant marketplace data permissions
USE ROLE accountadmin;

-- Grant usage and select permissions on the RAW database and its schemas
GRANT USAGE ON DATABASE RAW TO ROLE dbt_dev_role;
GRANT USAGE ON DATABASE RAW TO ROLE dbt_prod_role;

GRANT USAGE ON ALL SCHEMAS IN DATABASE RAW TO ROLE dbt_dev_role;
GRANT USAGE ON ALL SCHEMAS IN DATABASE RAW TO ROLE dbt_prod_role;

-- Grant read-only access on specific schemas/tables used by dbt
GRANT SELECT ON ALL TABLES IN SCHEMA RAW.JAFFLE_SHOP TO ROLE dbt_dev_role;
GRANT SELECT ON ALL TABLES IN SCHEMA RAW.JAFFLE_SHOP TO ROLE dbt_prod_role;

GRANT SELECT ON ALL TABLES IN SCHEMA RAW.STRIPE TO ROLE dbt_dev_role;
GRANT SELECT ON ALL TABLES IN SCHEMA RAW.STRIPE TO ROLE dbt_prod_role;

-- Step 4: Switch to the dbt_dev_role to start working
USE ROLE dbt_dev_role;
