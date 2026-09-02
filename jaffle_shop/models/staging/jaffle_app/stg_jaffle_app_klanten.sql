with source as (
        select * from {{ source('jaffle_app', 'klanten') }}
  ),
  renamed as (
      select
          {{ adapter.quote("ID") }} as customer_id,
        {{ adapter.quote("FIRST_NAME") }},
        {{ adapter.quote("LAST_NAME") }}

      from source
  )
  select * from renamed
    