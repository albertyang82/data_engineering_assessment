--We need to sum the total_price of all transactions per member and order by spending descending:
SELECT 
    m."MEMBERSHIP_ID_TXT",
    m."FIRST_NAME",
    m."LAST_NAME",
    m."EMAIL_ADDR",
    SUM(t."TOTAL_PRICE_NO") AS total_spent
FROM "ASSESSMENT"."TB_MEMBERSHIP" m
JOIN "ASSESSMENT"."TB_TRANSACTION" t ON m."MEMBERSHIP_ID_TXT" = t."MEMBERSHIP_ID_TXT"
GROUP BY m."MEMBERSHIP_ID_TXT", m."FIRST_NAME", m."LAST_NAME", m."EMAIL_ADDR"
ORDER BY total_spent DESC
LIMIT 10;

--Explanation:
-- Join TB_MEMBERSHIP and TB_TRANSACTION on membership_id_txt.
-- Aggregate total spending per member (SUM(t.total_price)).
-- Order by total_spent descending and take the top 10.