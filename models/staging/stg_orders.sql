{{
    config(
        materialized='view',
        tags=['staging', 'orders']
    )
}}

-- Staging model for orders data
-- Cleans and standardizes raw order data

with source as (
    select * from {{ source('raw', 'orders') }}
),

renamed as (
    select
        -- Primary key
        order_id,
        customer_id,
        
        -- Order information
        order_date,
        order_status,
        trim(upper(order_status)) as order_status_normalized,
        
        -- Financial information
        cast(order_amount as decimal(10, 2)) as order_amount,
        cast(tax_amount as decimal(10, 2)) as tax_amount,
        cast(shipping_cost as decimal(10, 2)) as shipping_cost,
        cast(order_amount + tax_amount + shipping_cost as decimal(10, 2)) as total_amount,
        
        -- Shipping information
        trim(shipping_address) as shipping_address,
        trim(shipping_city) as shipping_city,
        trim(shipping_state) as shipping_state,
        trim(shipping_postal_code) as shipping_postal_code,
        
        -- Dates
        date(order_date) as order_date_only,
        date(shipped_date) as shipped_date,
        date(delivered_date) as delivered_date,
        
        -- Metadata
        _loaded_at as source_loaded_at
        
    from source
    where order_id is not null
        and customer_id is not null
),

final as (
    select
        *,
        -- Generate order key
        {{ generate_surrogate_key(['order_id']) }} as order_key,
        
        -- Calculate days to ship
        case
            when shipped_date is not null and order_date is not null
            then date_diff(shipped_date, order_date, day)
            else null
        end as days_to_ship,
        
        -- Calculate days to deliver
        case
            when delivered_date is not null and shipped_date is not null
            then date_diff(delivered_date, shipped_date, day)
            else null
        end as days_to_deliver
        
    from renamed
)

select * from final

