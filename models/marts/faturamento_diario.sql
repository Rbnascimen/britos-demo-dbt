{{
  config(
    materialized='table',
    description='Faturamento agregado por dia e canal de venda.'
  )
}}

SELECT
    CAST(dh_pedido AS DATE) AS data_venda,
    canal,
    COUNT(DISTINCT id_venda)             AS total_pedidos,
    SUM(qtd_itens)                       AS total_itens,
    SUM(valor_subtotal)                  AS subtotal_bruto,
    SUM(valor_desconto)                  AS total_descontos,
    SUM(valor_frete)                     AS total_frete,
    SUM(valor_total)                     AS faturamento_liquido,
    AVG(valor_total)                     AS ticket_medio
FROM {{ ref('stg_vendas') }}
WHERE status IN ('paid', 'shipped', 'delivered')
GROUP BY 1, 2
ORDER BY 1 DESC, 2
