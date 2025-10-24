SELECT s.customer_code,COUNT(*) AS num_visits,
SUM(m.price) AS total_spent
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY s.customer_code
ORDER BY total_spent DESC;

SELECT s.customer_code,m.product_name,
TO_CHAR(s.order_date, 'YYYY-MM-DD') AS first_purchase_date
FROM sales s
JOIN menu m ON s.product_id = m.product_id
JOIN (
    
    SELECT customer_code, MIN(order_date) AS first_date
    FROM sales
    GROUP BY customer_code
) f ON s.customer_code = f.customer_code AND s.order_date = f.first_date
ORDER BY s.customer_code;

SELECT m.product_id,m.product_name,
COUNT(*) AS times_sold
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY m.product_id, m.product_name
ORDER BY times_sold DESC
FETCH FIRST 5 ROWS ONLY;

WITH item_counts AS (
  SELECT s.customer_code, s.product_id, m.product_name, COUNT(*) AS cnt
  FROM sales s
  JOIN menu m ON s.product_id = m.product_id
  GROUP BY s.customer_code, s.product_id, m.product_name
)
SELECT customer_code, product_id, product_name, cnt
FROM (
  SELECT ic.*, ROW_NUMBER() OVER (PARTITION BY customer_code ORDER BY cnt DESC) AS rn
  FROM item_counts ic
)
WHERE rn = 1
ORDER BY customer_code;

SELECT mb.customer_code, m.product_name,
s.order_date AS last_purchase_date
FROM sales s
JOIN menu m ON s.product_id = m.product_id
JOIN members mb ON s.customer_code = mb.customer_code
WHERE s.order_date = (
    SELECT MAX(order_date)
    FROM sales
    WHERE customer_code = mb.customer_code
      AND order_date < mb.date_of_join
)
ORDER BY mb.customer_code;










