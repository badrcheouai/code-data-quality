{{ config(materialized='table') }}

WITH base AS (
  SELECT * FROM {{ ref('stg_bank') }}
),
age_completeness AS (
  {{ completeness('age', 'base') }}
),
job_validity AS (
  {{ validity('job', 'base', '^[A-Za-z ]+$') }}
),
contact_uniqueness AS (
  {{ uniqueness('contact', 'base') }}
),
loan_consistency AS (
  {{ consistency('housing', 'loan', 'base') }}
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
