{{
    config(
        materialized='table',
        tags=['intermediate', 'customers', 'metrics']
    )
}}

-- Intermediate model: Customer metrics
-- Aggregates customer-level metrics from orders

with customers as (
    select * from {{ ref('stg_customers') }}
),

orders as (
    select * from {{ ref('stg_orders') }}
),

customer_orders as (
    select
        c.customer_key,
        c.customer_id,
        c.email,
        c.full_name,
        c.city,
        c.state,
        c.country,
        c.created_date as customer_since_date,
        
        -- Order metrics
        count(distinct o.order_id) as total_orders,
        count(distinct case when o.order_status_normalized = 'COMPLETED' then o.order_id end) as completed_orders,
        count(distinct case when o.order_status_normalized = 'CANCELLED' then o.order_id end) as cancelled_orders,
        
        -- Financial metrics
        sum(case when o.order_status_normalized = 'COMPLETED' then o.total_amount else 0 end) as total_revenue,
        avg(case when o.order_status_normalized = 'COMPLETED' then o.total_amount else null end) as avg_order_value,
        min(case when o.order_status_normalized = 'COMPLETED' then o.total_amount else null end) as min_order_value,
        max(case when o.order_status_normalized = 'COMPLETED' then o.total_amount else null end) as max_order_value,
        
        -- Date metrics
        min(o.order_date) as first_order_date,
        max(o.order_date) as last_order_date,
        date_diff(current_date(), max(o.order_date), day) as days_since_last_order,
        
        -- Shipping metrics
        avg(o.days_to_ship) as avg_days_to_ship,
        avg(o.days_to_deliver) as avg_days_to_deliver
        
    from customers c
    left join orders o
        on c.customer_id = o.customer_id
    group by
        c.customer_key,
        c.customer_id,
        c.email,
        c.full_name,
        c.city,
        c.state,
        c.country,
        c.created_date
)

select * from customer_orders

