
  
  create view "bank"."main"."stg_bank__dbt_tmp" as (
    -- Reads a CSV; uses DuckDB's read_csv_auto (semicolon for UCI Bank Marketing)
SELECT *
FROM read_csv_auto('data/bank.csv', header=True, delim=';')
  );
