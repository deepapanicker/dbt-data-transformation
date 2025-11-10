{{
    config(
        materialized='table',
        tags=['marts', 'customers', 'orders']
    )
}}

-- Mart model: Customer Orders
-- Combines customer and order data for analysis

with customers as (
    select * from {{ ref('customers') }}
),

orders as (
    select * from {{ ref('orders') }}
),

customer_orders as (
    select
        -- Customer information
        c.customer_key,
        c.customer_id,
        c.full_name as customer_name,
        c.email as customer_email,
        c.customer_status,
        c.customer_segment,
        c.customer_since_date,
        
        -- Order information
        o.order_key,
        o.order_id,
        o.order_date,
        o.order_status,
        o.total_amount as order_total,
        
        -- Order timing
        o.order_year,
        o.order_quarter,
        o.order_month,
        
        -- Shipping information
        o.is_shipped,
        o.is_delivered,
        o.days_to_ship,
        o.days_to_deliver,
        
        -- Customer metrics at time of order
        c.total_revenue as customer_lifetime_value,
        c.total_orders as customer_total_orders,
        c.avg_order_value as customer_avg_order_value
        
    from orders o
    inner join customers c
        on o.customer_key = c.customer_key
    where o.is_completed = true
)

select * from customer_orders

