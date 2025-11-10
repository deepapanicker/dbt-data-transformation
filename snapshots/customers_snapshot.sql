{% snapshot customers_snapshot %}

    {{
        config(
            target_schema='snapshots',
            unique_key='customer_id',
            strategy='check',
            check_cols=['email', 'phone', 'address_line_1', 'city', 'state'],
            invalidate_hard_deletes=True
        )
    }}

    select * from {{ source('raw', 'customers') }}

{% endsnapshot %}

