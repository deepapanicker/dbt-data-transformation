{% macro pivot_columns(column_name, values, agg='sum', alias_prefix='') %}
    {#
        Pivot columns dynamically
        
        Args:
            column_name: Column to pivot
            values: List of values to pivot
            agg: Aggregation function (default: sum)
            alias_prefix: Prefix for column aliases
            
        Example:
            {{ pivot_columns('status', ['completed', 'cancelled'], 'count', 'order_') }}
    #}
    
    {%- for value in values -%}
        {{ agg }}(case when {{ column_name }} = '{{ value }}' then 1 else 0 end) as {{ alias_prefix }}{{ value }}
        {%- if not loop.last -%},{%- endif -%}
    {%- endfor -%}
    
{% endmacro %}

