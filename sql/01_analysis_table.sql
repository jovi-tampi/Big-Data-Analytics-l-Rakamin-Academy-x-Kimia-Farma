CREATE OR REPLACE TABLE `rakamin-kf-analytics-503706.kimia_farma.kf_analysis_table` AS

WITH transaction_base AS (
  SELECT
    transaction_id,
    date,
    branch_id,
    customer_name,
    product_id,
    price                          AS actual_price,
    discount_percentage,
    rating                         AS rating_transaksi
  FROM `rakamin-kf-analytics-503706.kimia_farma.kf_final_transaction`
),

joined AS (
  SELECT
    t.transaction_id,
    t.date,
    t.branch_id,
    b.branch_name,
    b.kota,
    b.provinsi,
    b.rating                       AS rating_cabang,
    t.customer_name,
    t.product_id,
    p.product_name,
    t.actual_price,
    t.discount_percentage,
    t.rating_transaksi
  FROM transaction_base t
  INNER JOIN `rakamin-kf-analytics-503706.kimia_farma.kf_kantor_cabang` b
    ON t.branch_id = b.branch_id
  INNER JOIN `rakamin-kf-analytics-503706.kimia_farma.kf_product` p
    ON t.product_id = p.product_id
)

SELECT
  transaction_id,
  date,
  branch_id,
  branch_name,
  kota,
  provinsi,
  rating_cabang,
  customer_name,
  product_id,
  product_name,
  actual_price,
  discount_percentage,

  CASE
    WHEN actual_price <= 50000                          THEN 0.10
    WHEN actual_price > 50000  AND actual_price <= 100000 THEN 0.15
    WHEN actual_price > 100000 AND actual_price <= 300000 THEN 0.20
    WHEN actual_price > 300000 AND actual_price <= 500000 THEN 0.25
    WHEN actual_price > 500000                           THEN 0.30
  END AS persentase_gross_laba,

  ROUND(actual_price * (1 - discount_percentage), 2) AS nett_sales,

  ROUND(
    actual_price * (1 - discount_percentage) *
    CASE
      WHEN actual_price <= 50000                          THEN 0.10
      WHEN actual_price > 50000  AND actual_price <= 100000 THEN 0.15
      WHEN actual_price > 100000 AND actual_price <= 300000 THEN 0.20
      WHEN actual_price > 300000 AND actual_price <= 500000 THEN 0.25
      WHEN actual_price > 500000                           THEN 0.30
    END, 2
  ) AS nett_profit,

  rating_transaksi

FROM joined;
