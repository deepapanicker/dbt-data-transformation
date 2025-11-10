{{
    config(
        materialized='incremental',
        unique_key='order_id',
        on_schema_change='fail',
        incremental_strategy='merge'
    )
}}

-- Example incremental model
-- This shows how to create an incremental model that only processes new data

with source_data as (
    select * from {{ source('raw', 'orders') }}
),

filtered_data as (
    select
        order_id,
        customer_id,
        order_date,
        order_amount,
        order_status,
        _loaded_at
    from source_data
    {% if is_incremental() %}
        -- Only process records loaded after the last run
        where _loaded_at > (select max(_loaded_at) from {{ this }})
    {% endif %}
)

select * from filtered_data

