{{
    config(
        materialized='view',
        tags=['staging', 'customers']
    )
}}

-- Staging model for customers data
-- Cleans and standardizes raw customer data

with source as (
    select * from {{ source('raw', 'customers') }}
),

renamed as (
    select
        -- Primary key
        customer_id,
        
        -- Customer information
        trim(upper(first_name)) as first_name,
        trim(upper(last_name)) as last_name,
        trim(lower(email)) as email,
        trim(phone) as phone,
        
        -- Address information
        trim(address_line_1) as address_line_1,
        trim(address_line_2) as address_line_2,
        trim(city) as city,
        trim(state) as state,
        trim(postal_code) as postal_code,
        trim(country) as country,
        
        -- Dates
        date(created_at) as created_date,
        date(updated_at) as updated_date,
        
        -- Metadata
        _loaded_at as source_loaded_at
        
    from source
    where customer_id is not null
),

final as (
    select
        *,
        -- Generate full name
        concat(first_name, ' ', last_name) as full_name,
        
        -- Generate customer key
        {{ generate_surrogate_key(['customer_id']) }} as customer_key
        
    from renamed
)

select * from final

