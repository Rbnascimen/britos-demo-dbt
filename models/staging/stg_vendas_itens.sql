{{
  config(
    materialized='view',
    description='Staging de itens da venda: limpa metadados e tipa decimais.'
  )
}}

SELECT
    id_venda_item,
    id_venda,
    id_produto,
    quantidade,
    CAST(preco_unitario AS DECIMAL(10,2)) AS preco_unitario,
    CAST(valor_desconto AS DECIMAL(10,2)) AS valor_desconto,
    CAST(valor_total    AS DECIMAL(12,2)) AS valor_total,
    dh_criacao
FROM {{ source('sales', 'vendas_itens') }}
WHERE id_venda_item IS NOT NULL
