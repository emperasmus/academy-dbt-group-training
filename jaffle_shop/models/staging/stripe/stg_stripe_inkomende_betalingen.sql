with source as (
        select * from {{ source('stripe', 'inkomende_betalingen') }}
  ),
  renamed as (
      select 
        {{ adapter.quote("ID") }} as payment_id,
        {{ adapter.quote("ORDERID") }} as order_id,
        {{ adapter.quote("PAYMENTMETHOD") }},
        {{ adapter.quote("STATUS") }} as payment_status,
        {{ adapter.quote("AMOUNT") }} ,
        {{ adapter.quote("CREATED") }}

      from source
  )
  select * from renamed
    