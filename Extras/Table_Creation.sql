/* ====================== Yasin YILDIRIM - YETGIM Final Projesi ======================

Veritabanı Yapısı
-Tablolar:
●	categories (kategoriler)
●	products (ürünler)
●	customers (müşteriler)
●	orders (siparişler)
●	order_items (sipariş detayları)
●	reviews (ürün yorumları)
●	shipping_addresses (teslimat adresleri)

*Karışıklık olmaması için created_at sütunlarına ve default'u now() olan sütunlara elle veri eklerken sadece yyyy-mm-dd kullanılmıştır. */

-- ============================================ TABLOLAR ============================================

-- Kategoriler Tablosunu Oluşturma

create table "categories" (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT
);

-- Ürünler Tablosunu Oluşturma

create table "products" (
    id SERIAL PRIMARY KEY,
    category_id INT NOT NULL,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    price NUMERIC(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW(),

    -- Join işlemleri için constraint/foreign key oluşturma
    CONSTRAINT "products_category_id_foreign"
        FOREIGN KEY("category_id") REFERENCES "categories"("id")
);

-- Müşteriler Tablosunu Oluşturma

CREATE TABLE "customers" (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    surname VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    gender VARCHAR(20),
    email VARCHAR(150) NOT NULL UNIQUE,
    phone VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Teslimat Adresi Tablosu Oluşturma

CREATE TABLE "shipping_adresses" (
    id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    address_line VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    zipcode VARCHAR(20) NOT NULL,

    FOREIGN KEY ("customer_id") REFERENCES "customers"("id")
);

-- Siparişler Tablosu Oluşturma

CREATE TABLE "orders" (
    id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    shipping_address_id INT NOT NULL,
    shipping_price NUMERIC(10,2) DEFAULT 0,
    total_price NUMERIC(10,2) NOT NULL,
    order_date TIMESTAMP DEFAULT NOW(),
    status VARCHAR(50) DEFAULT 'Hazırlanıyor',

    FOREIGN KEY ("customer_id") REFERENCES "customers"("id"),
    FOREIGN KEY ("shipping_address_id") REFERENCES "shipping_adresses"("id")
);
-- Alter komutunu kullanarak sütun ismini düzenliyoruz.
ALTER TABLE orders
RENAME COLUMN total_price TO price;


-- Sipariş Detaylerı Tablosunu Oluşturma

CREATE TABLE "order_items" (
    id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price NUMERIC(10,2) NOT NULL,

    FOREIGN KEY ("order_id") REFERENCES "orders"("id"),
    FOREIGN KEY ("product_id") REFERENCES "products"("id")
);
-- Örnek olması amacıyla alter komutunu kullanarak sütun ismini düzenliyoruz.
ALTER TABLE order_items
RENAME COLUMN unit_price TO total_price;

-- Ürün Yorumları Tablosunu Oluşturma

CREATE TABLE "reviews" (
    id SERIAL PRIMARY KEY,
    product_id INT NOT NULL,
    customer_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT NOW(),

    FOREIGN KEY ("product_id") REFERENCES "products"("id"),
    FOREIGN KEY ("customer_id") REFERENCES "customers"("id")
);
