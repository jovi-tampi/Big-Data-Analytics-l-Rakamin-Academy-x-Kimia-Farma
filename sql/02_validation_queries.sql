Validation #1: (based on number of branch_id, unique branch_name, kota)
```sql
SELECT
  COUNT(DISTINCT branch_id)   AS unique_branch_ids,
  COUNT(DISTINCT branch_name) AS unique_branch_names,
  COUNT(DISTINCT kota)        AS unique_kota
FROM `kimia_farma.kf_analysis_table`;
```

Validation #2: (based on Transaction counts, nett_sales and nett_profit, Ratings, branch_id + kota + provinsi)
SELECT
  branch_id,
  branch_name,
  kota,
  provinsi,
  COUNT(*)                            AS total_transactions,
  SUM(nett_sales)                     AS total_nett_sales,
  SUM(nett_profit)                    AS total_nett_profit,
  AVG(rating_transaksi)               AS average_transaction_rating,
  AVG(rating_cabang)                  AS average_branch_rating,
  COUNT(DISTINCT customer_name)       AS total_customers
FROM `rakamin-kf-analytics-503706.kimia_farma.kf_analysis_table`
GROUP BY branch_id, branch_name, kota, provinsi
ORDER BY total_nett_sales DESC
LIMIT 10;
