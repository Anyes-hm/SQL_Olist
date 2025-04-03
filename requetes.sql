-- =========================================================
-- 1. Création de la vue des catégories de produits
-- =========================================================
CREATE VIEW products_category AS
SELECT 
    p.product_id,
    COALESCE(t.product_category_name_english, 'Unknown') AS product_category_name,
    p.product_name_lenght, 
    p.product_description_lenght, 
    p.product_photos_qty,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm
FROM products p
LEFT JOIN product_category_name_translation t 
ON p.product_category_name = t.product_category_name;

-- =========================================================
-- 2. Chiffre d'affaires par ville client et par catégorie de produit
-- =========================================================

-- =========================================================
-- Analyse : 
-- Cette requête permet de visualiser le chiffre d'affaires généré par chaque
--  ville pour chaque catégorie de produit. Elle montre où les produits spécifiques ont le 
-- plus de succès et aide à comprendre les préférences des consommateurs selon leur localisation. 
-- Une ville avec un revenu élevé dans une catégorie donnée peut indiquer un marché porteur pour cette catégorie de produits, 
-- ce qui peut influencer les décisions de marketing et de distribution. Par exemple, certaines régions peuvent être plus sensibles 
-- à des produits électroniques, alors que d'autres préféreront des produits alimentaires ou de mode.
-- =========================================================

SELECT 
    c.customer_city,
    p.product_category_name,
    SUM(oi.price) AS total_revenue,  
    COUNT(DISTINCT o.order_id) AS total_orders,  
    COUNT(DISTINCT c.customer_id) AS total_customers  
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products_category p ON oi.product_id = p.product_id
GROUP BY c.customer_city, p.product_category_name
ORDER BY total_revenue DESC;

-- =========================================================
-- 3. Chiffre d'affaires et quantité de produits vendus par ville des vendeurs
-- =========================================================

-- =========================================================
-- Analyse :    
-- Cette requête examine les revenus et les quantités de produits vendus par ville et par état des vendeurs. 
-- Cela permet d’identifier les zones géographiques où les vendeurs réussissent le mieux. Par exemple, une ville avec une forte
--  concentration de revenus peut indiquer une forte demande locale ou une meilleure efficacité des vendeurs. Cela peut aussi révéler
--  des disparités régionales en termes de performance de vente, ce qui pourrait justifier l’allocation de ressources supplémentaires à 
-- certains marchés.
-- =========================================================

SELECT 
    s.seller_city, 
    s.seller_state, 
    SUM(oi.price) AS total_revenue, 
    COUNT(oi.order_id) AS total_quantity
FROM order_items oi
JOIN sellers s ON oi.seller_id = s.seller_id
GROUP BY s.seller_city, s.seller_state
ORDER BY total_revenue DESC;

-- =========================================================
-- 4. Panier moyen (valeur moyenne des commandes)
-- =========================================================
SELECT 
    SUM(oi.price) / COUNT(DISTINCT o.order_id) AS average_basket
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id;

-- =========================================================
-- 5. Panier moyen par score d'avis client
-- =========================================================
SELECT 
    r.review_score,
    SUM(oi.price) / COUNT(DISTINCT o.order_id) AS average_basket_per_review
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN order_reviews r ON o.order_id = r.order_id
WHERE r.review_score IS NOT NULL
GROUP BY r.review_score
ORDER BY r.review_score;

-- =========================================================
-- 6. Délais de livraison et impact sur les avis clients
-- =========================================================

-- =========================================================
-- Analyse :
-- Cette requête met en lumière la relation entre les retards de livraison et les avis clients. 
-- Si les retards de livraison augmentent les avis négatifs, cela indique qu'il y a un impact direct de la logistique
--  sur la satisfaction client. Une bonne gestion des délais de livraison est donc cruciale pour améliorer l'expérience client 
-- et optimiser les scores d'avis. Si les délais de livraison sont souvent longs, il pourrait être nécessaire de réévaluer les 
-- partenariats avec les transporteurs ou d'améliorer la gestion des stocks.
-- =========================================================

SELECT 
    r.review_score,
    AVG(o.order_delivered_customer_date - o.order_estimated_delivery_date) AS avg_delivery_delay,
    AVG(o.order_delivered_customer_date - o.order_purchase_timestamp) AS avg_order_to_delivery_time
FROM orders o
JOIN order_reviews r ON o.order_id = r.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY r.review_score
ORDER BY r.review_score;

-- =========================================================
-- 7. Création de la vue pour le marketing (leads qualifiés et conclus)
-- =========================================================
CREATE VIEW marketing AS
SELECT 
    q.mql_id, 
    q.first_contact_date, 
    q.landing_page_id, 
    q.origin, 
    c.seller_id, 
    c.sdr_id, 
    c.sr_id, 
    c.won_date, 
    c.business_segment, 
    c.lead_type, 
    c.lead_behaviour_profile, 
    c.has_company, 
    c.has_gtin, 
    c.average_stock, 
    c.business_type, 
    c.declared_product_catalog_size, 
    c.declared_monthly_revenue
FROM leads_qualified q
LEFT JOIN leads_closed c ON q.mql_id = c.mql_id;

-- =========================================================
-- 8. Taux de conversion des leads qualifiés en transactions conclues
-- =========================================================
SELECT 
    (COUNT(DISTINCT lc.mql_id)::float / COUNT(DISTINCT lq.mql_id)) * 100 AS conversion_rate
FROM leads_qualified lq
LEFT JOIN leads_closed lc 
ON lq.mql_id = lc.mql_id;

-- =========================================================
-- 9. Dates de la première et dernière transaction et durée totale des ventes
-- =========================================================
SELECT 
    MIN(won_date) AS first_transaction,
    MAX(won_date) AS last_transaction,
    EXTRACT(DAY FROM MAX(won_date) - MIN(won_date)) AS timelapse_days
FROM leads_closed;

-- =========================================================
-- 10. Nombre de transactions conclues un samedi
-- =========================================================
SELECT 
    COUNT(*) AS transactions_on_saturday
FROM leads_closed
WHERE EXTRACT(DOW FROM won_date) = 6;

-- =========================================================
-- 11. Top 3 des commerciaux ayant conclu le plus de transactions
-- =========================================================
SELECT 
    seller_id,
    COUNT(*) AS transaction_count
FROM leads_closed
GROUP BY seller_id
ORDER BY transaction_count DESC
LIMIT 3;

-- =========================================================
-- 12. Nombre de leads "cat" signés en avril
-- =========================================================
SELECT 
    COUNT(*) AS cat_leads_signed_in_april
FROM leads_closed lc
JOIN leads_qualified lq 
ON lc.mql_id = lq.mql_id
WHERE lc.lead_type = 'cat'  
AND EXTRACT(MONTH FROM lc.won_date) = 4;

-- =========================================================
-- 13. Secteurs d'activité ayant conclu le plus de transactions
-- =========================================================
SELECT 
    business_segment,
    COUNT(*) AS transaction_count
FROM leads_closed
GROUP BY business_segment
ORDER BY transaction_count DESC
LIMIT 3;

-- =========================================================
-- 14. Nombre de transactions conclues par mois et année
-- =========================================================
SELECT 
    EXTRACT(YEAR FROM won_date) AS year,
    EXTRACT(MONTH FROM won_date) AS month,
    COUNT(*) AS transaction_count
FROM leads_closed
GROUP BY year, month
ORDER BY year, month;

-- =========================================================
-- 15. Évolution du chiffre d'affaires mensuel déclaré
-- =========================================================
SELECT 
    EXTRACT(YEAR FROM won_date) AS year,
    EXTRACT(MONTH FROM won_date) AS month,
    SUM(declared_monthly_revenue) AS total_declared_revenue
FROM leads_closed
GROUP BY year, month
ORDER BY year, month;

-- =========================================================
-- 16. Analyse des cohortes des vendeurs (évolution des ventes dans le temps)
-- =========================================================

-- =============================================================
-- Analyse : 
-- L’analyse des cohortes permet d’observer l’évolution des ventes au fil du temps pour chaque groupe de vendeurs 
-- en fonction de leur date de première vente. Cette analyse aide à identifier si les nouveaux vendeurs performent mieux 
-- ou moins bien que les anciens et à évaluer l’impact des stratégies de recrutement de vendeurs au fil du temps. 
-- Elle peut également fournir des informations sur la rétention des vendeurs et sur l’évolution des ventes en fonction de l’expérience.
-- =============================================================

WITH first_transaction AS (
    SELECT 
        seller_id, 
        MIN(won_date) AS cohort_date
    FROM leads_closed
    GROUP BY seller_id
)
SELECT 
    EXTRACT(YEAR FROM f.cohort_date) AS cohort_year,
    EXTRACT(MONTH FROM f.cohort_date) AS cohort_month,
    COUNT(DISTINCT l.seller_id) AS seller_count
FROM first_transaction f
JOIN leads_closed l ON f.seller_id = l.seller_id
GROUP BY cohort_year, cohort_month
ORDER BY cohort_year, cohort_month;
