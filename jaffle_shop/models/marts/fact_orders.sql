SELECT o.order_id, o.customer_id, o.order_date, o. order_status, p.AMOUNT
FROM
{{ ref("stg_jaffle_app_bestellingen")}} o

inner join {{ ref("stg_stripe_inkomende_betalingen")}} p 
on o.order_id = p.order_id

where p.payment_status = 'success'
 --and o.order_status = 'completed'


