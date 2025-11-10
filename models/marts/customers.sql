{{
    config(
        materialized='table',
        tags=['marts', 'customers']
    )
}}

-- Mart model: Customers
-- Final customer dimension table with all metrics

with customer_metrics as (
    select * from {{ ref('int_customer_metrics') }}
),

customers as (
    select * from {{ ref('stg_customers') }}
),

final as (
    select
        -- Customer keys
        c.customer_key,
        c.customer_id,
        
        -- Customer information
        c.full_name,
        c.first_name,
        c.last_name,
        c.email,
        c.phone,
        
        -- Address
        c.address_line_1,
        c.address_line_2,
        c.city,
        c.state,
        c.postal_code,
        c.country,
        
        -- Customer dates
        c.created_date as customer_since_date,
        c.updated_date,
        
        -- Order metrics
        coalesce(cm.total_orders, 0) as total_orders,
        coalesce(cm.completed_orders, 0) as completed_orders,
        coalesce(cm.cancelled_orders, 0) as cancelled_orders,
        
        -- Financial metrics
        coalesce(cm.total_revenue, 0) as total_revenue,
        cm.avg_order_value,
        cm.min_order_value,
        cm.max_order_value,
        
        -- Customer status
        case
            when cm.total_orders = 0 then 'New'
            when cm.days_since_last_order <= 30 then 'Active'
            when cm.days_since_last_order <= 90 then 'At Risk'
            else 'Inactive'
        end as customer_status,
        
        -- Customer segment
        case
            when cm.total_revenue >= 10000 then 'VIP'
            when cm.total_revenue >= 5000 then 'Premium'
            when cm.total_revenue >= 1000 then 'Standard'
            else 'Basic'
        end as customer_segment,
        
        -- Date metrics
        cm.first_order_date,
        cm.last_order_date,
        cm.days_since_last_order,
        
        -- Shipping metrics
        cm.avg_days_to_ship,
        cm.avg_days_to_deliver,
        
        -- Metadata
        c.source_loaded_at,
        current_timestamp() as dbt_updated_at
        
    from customers c
    left join customer_metrics cm
        on c.customer_key = cm.customer_key
)

select * from final

