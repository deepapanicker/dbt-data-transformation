{% macro generate_surrogate_key(field_list) %}
    {#
        Generate a surrogate key from a list of fields
        
        Args:
            field_list: List of field names to use for key generation
            
        Returns:
            SQL expression that generates a hash key
    #}
    
    {%- if field_list is iterable and field_list is not string -%}
        {{ dbt_utils.generate_surrogate_key(field_list) }}
    {%- else -%}
        {{ exceptions.raise_compiler_error("generate_surrogate_key macro requires a list of fields") }}
    {%- endif -%}
    
{% endmacro %}

