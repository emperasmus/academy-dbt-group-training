with customers as (

select *
from {{ ref('stg_jaffle_app_klanten')}}

),

orders as (

select *
from {{ ref('stg_jaffle_app_bestellingen') }}

),

lifetime_value as
(
SELECT o.customer_id, (SUM(p.AMOUNT))/100 as lifetime_value
FROM
{{ ref("stg_jaffle_app_bestellingen")}} o

inner join {{ ref("stg_stripe_inkomende_betalingen")}} p 
on o.order_id = p.order_id
where p.payment_status = 'success'
GROUP BY o.customer_id

),

customer_orders as (

    select
        customer_id,

        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders

    from orders

    group by 1

),


final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        lifetime_value,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders
    from customers

    left join customer_orders on
    customers.customer_id = customer_orders.customer_id

    left join lifetime_value on
    lifetime_value.customer_id = customers.customer_id

)

select * from final
