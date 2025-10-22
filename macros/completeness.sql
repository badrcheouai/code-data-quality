{% macro completeness(column_name, table_name) %}
SELECT 
  1.0 - (SUM(CASE WHEN {{ column_name }} IS NULL OR CAST({{ column_name }} AS VARCHAR) = '' THEN 1 ELSE 0 END) * 1.0 / COUNT(*)) 
  AS completeness_score
FROM {{ table_name }}
{% endmacro %}
