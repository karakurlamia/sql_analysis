---Hiç siparis vermeyen müsteriler 
SELECT C.customer_id ,C.customer_name FROM customers c 
LEFT JOIN orders o ON c.customer_id=o.customer_id
WHERE O.order_id IS NULL

---Hic satýlmamýs ürünler 
SELECT p.product_id , p.product_name FROM products p
LEFT JOIN order_details od ON  p.product_id=od.product_id
WHERE od.product_id IS NULL

---En çok ciro getiren ilk 5 ürün
SELECT TOP 5 p.product_id , p.product_name , SUM(OD.quantity * od.Unit_price) AS Kazanc FROM products p
INNER JOIN order_details od ON p.product_id=od.product_id
GROUP BY p.product_id , p.product_name
ORDER BY SUM(OD.quantity * od.Unit_price) DESC

---Toplam satýsý olmayan ürün kategorileri
SELECT p.category , SUM(od.quantity * od.Unit_price) AS Kazanc  FROM products p
LEFT JOIN order_details  od ON p.product_id=od.product_id
GROUP BY p.category
HAVING SUM(od.quantity * od.Unit_price) IS NULL

---Hiç siparis vermemis ama kayýt tarihi eski müsteriler
SELECT c.customer_id , c.customer_name , c.registration_date  FROM customers c
LEFT JOIN orders o ON c.customer_id=o.customer_id
WHERE o.order_id IS NULL AND c.registration_date < '2024-01-01'

---Sadece bir kere siparis vermis müsteriler
SELECT c.customer_id , c.customer_name , COUNT(o.order_id) FROM customers c
LEFT JOIN orders o ON c.customer_id=o.customer_id
GROUP BY c.customer_id,c.customer_name
HAVING COUNT(o.order_id) = 1

---Stokta var ama hiç satýlmamýs ürünler
SELECT p.product_id , p.product_name , p.stock FROM products p
LEFT JOIN order_details od ON p.product_id=od.product_id
WHERE p.stock >= 1 AND od.product_id IS NULL 

---Kategori bazlý toplam ciro + siparis sayýsý
SELECT p.category , SUM(od.quantity * od.Unit_price ) AS ToplamCiro , COUNT(DISTINCT o.order_id) AS SiparisSayýsý FROM orders o
INNER JOIN order_details od ON od.order_id=o.order_id
INNER JOIN products p ON p.product_id=od.product_id
GROUP BY p.category

---Son 3 ayda hiç siparis almayan müsteriler 
SELECT c.customer_id ,c.customer_name FROM customers c
LEFT JOIN orders o ON c.customer_id=o.customer_id AND o.order_date > DATEADD(MONTH , -3 , GETDATE())
WHERE o.order_id IS NULL

--- 0 Siparis veren müsteriler 
SELECT c.customer_id ,c.customer_name , COUNT(DISTINCT o.order_id) FROM customers c  
LEFT JOIN orders o ON c.customer_id=o.customer_id
GROUP BY C.customer_id,C.customer_name
HAVING COUNT(DISTINCT o.order_id) = 0
