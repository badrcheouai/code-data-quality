{% macro validity(column_name, table_name, pattern) %}
SELECT 
  SUM(CASE WHEN CAST({{ column_name }} AS VARCHAR) ~ '{{ pattern }}' THEN 1 ELSE 0 END) * 1.0 / COUNT(*) AS validity_score
FROM {{ table_name }}
{% endmacro %}
