--We need to count total quantity purchased for each item across all transactions:
SELECT i."ITEM_ID_NO", i."ITEM_NAME", SUM(ti."QUANTITY_NO") AS total_quantity_sold
FROM "ASSESSMENT"."TB_TRANSACTION_ITEM_MAPPING" ti
JOIN "ASSESSMENT"."TB_ITEM" i ON ti."ITEM_ID_NO" = i."ITEM_ID_NO"
GROUP BY i."ITEM_ID_NO", i."ITEM_NAME"
ORDER BY total_quantity_sold DESC
LIMIT 3;

--Explanation:
--Join TB_ITEM and TB_TRANSACTION_ITEM_MAPPING to get purchase quantities.
--Aggregate total quantity per item (SUM(ti.QUANTITY_NO)).
--Order descending and take the top 3 most frequently purchased items.