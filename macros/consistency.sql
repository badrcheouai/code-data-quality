{% macro consistency(col1, col2, table_name) %}
SELECT 
  SUM(CASE WHEN {{ col1 }} = {{ col2 }} THEN 1 ELSE 0 END) * 1.0 / COUNT(*) AS consistency_score
FROM {{ table_name }}
{% endmacro %}
