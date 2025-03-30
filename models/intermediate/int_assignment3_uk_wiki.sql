{{ config(materialized='view') }}

with base as (
    select *
    from {{ ref('stg_assignment3_uk_wiki') }}
),

classified as (
    select
        *,
        case
            when regexp_contains(title, r'^(Вікіпедія|Файл|Категорія|Спеціальна|Шаблон|Портал|Довідка|Модуль|MediaWiki):')
            then true
            else false
        end as is_meta_page,
        case
            when regexp_contains(title, r'^Вікіпедія:') then 'Вікіпедія'
            when regexp_contains(title, r'^Файл:') then 'Файл'
            when regexp_contains(title, r'^Категорія:') then 'Категорія'
            when regexp_contains(title, r'^Спеціальна:') then 'Спеціальна'
            when regexp_contains(title, r'^Шаблон:') then 'Шаблон'
            when regexp_contains(title, r'^Портал:') then 'Портал'
            when regexp_contains(title, r'^Довідка:') then 'Довідка'
            when regexp_contains(title, r'^Модуль:') then 'Модуль'
            when regexp_contains(title, r'^MediaWiki:') then 'MediaWiki'
            else null

{#            regexp_extract#}
        end as meta_page_type
    from base
)

select *
from classified