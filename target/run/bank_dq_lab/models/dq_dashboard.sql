
  
    
    

    create  table
      "bank"."main"."dq_dashboard__dbt_tmp"
  
    as (
      

WITH base AS (
  SELECT * FROM "bank"."main"."stg_bank"
),
age_completeness AS (
  
SELECT 
  1.0 - (SUM(CASE WHEN age IS NULL OR CAST(age AS VARCHAR) = '' THEN 1 ELSE 0 END) * 1.0 / COUNT(*)) 
  AS completeness_score
FROM base

),
job_validity AS (
  
SELECT 
  SUM(CASE WHEN CAST(job AS VARCHAR) ~ '^[A-Za-z ]+$' THEN 1 ELSE 0 END) * 1.0 / COUNT(*) AS validity_score
FROM base

),
contact_uniqueness AS (
  
SELECT 
  1.0 - ((COUNT(*) - COUNT(DISTINCT contact)) * 1.0 / COUNT(*)) AS uniqueness_score
FROM base

),
loan_consistency AS (
  
SELECT 
  SUM(CASE WHEN housing = loan THEN 1 ELSE 0 END) * 1.0 / COUNT(*) AS consistency_score
FROM base

)
SELECT 
  age_completeness.completeness_score AS age_completeness,
  job_validity.validity_score AS job_validity,
  contact_uniqueness.uniqueness_score AS contact_uniqueness,
  loan_consistency.consistency_score AS loan_consistency
FROM age_completeness
CROSS JOIN job_validity
CROSS JOIN contact_uniqueness
CROSS JOIN loan_consistency
    );
  
  