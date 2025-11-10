-- Custom test: Assert positive amount
-- Tests that amount fields are positive

select
    order_id,
    order_amount,
    tax_amount,
    shipping_cost,
    total_amount
from {{ ref('orders') }}
where order_amount < 0
    or tax_amount < 0
    or shipping_cost < 0
    or total_amount < 0

