{{
  config(
    materialized='view',
    description='Staging de vendas: limpa colunas tecnicas (_batch_id, _ingested_at) e tipa campos.'
  )
}}

SELECT
    id_venda,
    numero_pedido,
    id_cliente,
    id_cupom,
    canal,
    status,
    CAST(valor_subtotal AS DECIMAL(12,2)) AS valor_subtotal,
    CAST(valor_desconto AS DECIMAL(12,2)) AS valor_desconto,
    CAST(valor_frete    AS DECIMAL(12,2)) AS valor_frete,
    CAST(valor_total    AS DECIMAL(12,2)) AS valor_total,
    qtd_itens,
    moeda,
    dh_pedido,
    dh_pagamento,
    dh_envio,
    dh_entrega,
    dh_atualizacao
FROM {{ source('sales', 'vendas') }}
WHERE id_venda IS NOT NULL
