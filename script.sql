CREATE TABLE IF NOT EXISTS customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix VARCHAR(10),
    customer_city VARCHAR(50),
    customer_state VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS geolocation (
    geolocation_zip_code_prefix VARCHAR(10),
    geolocation_lat DOUBLE PRECISION,
    geolocation_lng DOUBLE PRECISION,
    geolocation_city VARCHAR(50),
    geolocation_state VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS order_items (
    order_id VARCHAR(50),
    order_item_id INTEGER,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date TIMESTAMP,
    price NUMERIC(10,2),
    freight_value NUMERIC(10,2),
    PRIMARY KEY (order_id, product_id, order_item_id)
);

CREATE TABLE IF NOT EXISTS order_payments (
    order_id VARCHAR(50),
    payment_sequential INTEGER,
    payment_type VARCHAR(20),
    payment_installments INTEGER,
    payment_value NUMERIC(10,2)
);

CREATE TABLE IF NOT EXISTS order_reviews (
    review_id VARCHAR(50) PRIMARY KEY,
    order_id VARCHAR(50),
    review_score INTEGER,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP
);

CREATE TABLE IF NOT EXISTS orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(20),
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);

CREATE TABLE IF NOT EXISTS products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(50),
    product_name_lenght INTEGER,
    product_description_lenght INTEGER,
    product_photos_qty INTEGER,
    product_weight_g INTEGER,
    product_length_cm INTEGER,
    product_height_cm INTEGER,
    product_width_cm INTEGER
);

CREATE TABLE IF NOT EXISTS sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix VARCHAR(10),
    seller_city VARCHAR(50),
    seller_state VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS product_category_name_translation (
    product_category_name VARCHAR(50) PRIMARY KEY,
    product_category_name_english VARCHAR(50)
);

-- Relier les commandes aux clients
ALTER TABLE orders 
ADD CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id) 
REFERENCES customers(customer_id) ON DELETE CASCADE;

-- Relier les paiements aux commandes
ALTER TABLE order_payments 
ADD CONSTRAINT fk_payments_order FOREIGN KEY (order_id) 
REFERENCES orders(order_id) ON DELETE CASCADE;

-- Relier les avis aux commandes
ALTER TABLE order_reviews 
ADD CONSTRAINT fk_reviews_order FOREIGN KEY (order_id) 
REFERENCES orders(order_id) ON DELETE CASCADE;

-- Relier les articles aux commandes
ALTER TABLE order_items 
ADD CONSTRAINT fk_items_order FOREIGN KEY (order_id) 
REFERENCES orders(order_id) ON DELETE CASCADE;

-- Relier les articles aux produits
ALTER TABLE order_items 
ADD CONSTRAINT fk_items_product FOREIGN KEY (product_id) 
REFERENCES products(product_id) ON DELETE CASCADE;

-- Relier les articles aux vendeurs
ALTER TABLE order_items 
ADD CONSTRAINT fk_items_seller FOREIGN KEY (seller_id) 
REFERENCES sellers(seller_id) ON DELETE CASCADE;

CREATE TABLE leads_closed (
    mql_id VARCHAR(255) PRIMARY KEY,
    seller_id VARCHAR(255),
    sdr_id VARCHAR(255),
    sr_id VARCHAR(255),
    won_date TIMESTAMP,
    business_segment VARCHAR(255),
    lead_type VARCHAR(255),
    lead_behaviour_profile VARCHAR(255),
    has_company BOOLEAN,
    has_gtin BOOLEAN,
    average_stock VARCHAR(255),
    business_type VARCHAR(255),
    declared_product_catalog_size DOUBLE PRECISION,
    declared_monthly_revenue DOUBLE PRECISION
);

CREATE TABLE leads_qualified (
    mql_id VARCHAR(255) PRIMARY KEY,
    first_contact_date TIMESTAMP,
    landing_page_id VARCHAR(255),
    origin VARCHAR(255)
);
