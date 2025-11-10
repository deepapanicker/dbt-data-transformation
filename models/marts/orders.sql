{{
    config(
        materialized='table',
        tags=['marts', 'orders']
    )
}}

-- Mart model: Orders
-- Final order fact table

with order_summary as (
    select * from {{ ref('int_order_summary') }}
),

final as (
    select
        -- Order keys
        order_key,
        order_id,
        
        -- Customer keys
        customer_key,
        customer_id,
        customer_name,
        customer_email,
        customer_city,
        customer_state,
        customer_country,
        
        -- Order information
        order_date,
        order_status,
        
        -- Order amounts
        order_amount,
        tax_amount,
        shipping_cost,
        total_amount,
        
        -- Shipping information
        shipping_address,
        shipping_city,
        shipping_state,
        shipping_postal_code,
        
        -- Shipping dates
        shipped_date,
        delivered_date,
        days_to_ship,
        days_to_deliver,
        
        -- Customer metrics
        customer_tenure_days,
        
        -- Time dimensions
        order_year,
        order_quarter,
        order_month,
        order_day_of_week,
        
        -- Order flags
        case when order_status = 'COMPLETED' then true else false end as is_completed,
        case when order_status = 'CANCELLED' then true else false end as is_cancelled,
        case when shipped_date is not null then true else false end as is_shipped,
        case when delivered_date is not null then true else false end as is_delivered,
        
        -- Metadata
        source_loaded_at,
        current_timestamp() as dbt_updated_at
        
    from order_summary
)

select * from final

