{{
  config(
    materialized='table',
    description='Top 1000 clientes por faturamento (12 meses moveis).'
  )
}}

WITH vendas_com_itens AS (
    SELECT
        v.id_cliente,
        v.id_venda,
        v.dh_pedido,
        SUM(vi.valor_total) AS valor_pedido
    FROM {{ ref('stg_vendas') }} v
    INNER JOIN {{ ref('stg_vendas_itens') }} vi
      ON v.id_venda = vi.id_venda
    WHERE v.status IN ('paid', 'shipped', 'delivered')
      AND v.dh_pedido >= CAST('2025-05-04' AS TIMESTAMP)
    GROUP BY v.id_cliente, v.id_venda, v.dh_pedido
)

SELECT
    id_cliente,
    COUNT(DISTINCT id_venda) AS total_pedidos,
    SUM(valor_pedido)        AS faturamento_total,
    AVG(valor_pedido)        AS ticket_medio,
    MIN(dh_pedido)           AS primeira_compra,
    MAX(dh_pedido)           AS ultima_compra
FROM vendas_com_itens
GROUP BY id_cliente
ORDER BY faturamento_total DESC
LIMIT 1000
