{{
    config(
        materialized='table',
        tags=['intermediate', 'orders', 'summary']
    )
}}

-- Intermediate model: Order summary
-- Creates order-level summary with customer details

with orders as (
    select * from {{ ref('stg_orders') }}
),

customers as (
    select * from {{ ref('stg_customers') }}
),

order_summary as (
    select
        o.order_key,
        o.order_id,
        o.order_date,
        o.order_status_normalized as order_status,
        
        -- Customer information
        c.customer_key,
        c.customer_id,
        c.full_name as customer_name,
        c.email as customer_email,
        c.city as customer_city,
        c.state as customer_state,
        c.country as customer_country,
        
        -- Order amounts
        o.order_amount,
        o.tax_amount,
        o.shipping_cost,
        o.total_amount,
        
        -- Shipping information
        o.shipping_address,
        o.shipping_city,
        o.shipping_state,
        o.shipping_postal_code,
        
        -- Shipping dates
        o.shipped_date,
        o.delivered_date,
        o.days_to_ship,
        o.days_to_deliver,
        
        -- Customer tenure
        date_diff(o.order_date, c.created_date, day) as customer_tenure_days,
        
        -- Order timing
        extract(year from o.order_date) as order_year,
        extract(quarter from o.order_date) as order_quarter,
        extract(month from o.order_date) as order_month,
        extract(dayofweek from o.order_date) as order_day_of_week,
        
        -- Metadata
        o.source_loaded_at
        
    from orders o
    inner join customers c
        on o.customer_id = c.customer_id
)

select * from order_summary

