{% macro uniqueness(column_name, table_name) %}
SELECT 
  1.0 - ((COUNT(*) - COUNT(DISTINCT {{ column_name }})) * 1.0 / COUNT(*)) AS uniqueness_score
FROM {{ table_name }}
{% endmacro %}
