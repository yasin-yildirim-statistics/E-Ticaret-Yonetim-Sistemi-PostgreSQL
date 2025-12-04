CREATE TABLE "categories"(
    "id" SERIAL NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "description" TEXT NOT NULL
);
ALTER TABLE
    "categories" ADD PRIMARY KEY("id");
CREATE TABLE "products"(
    "id" SERIAL NOT NULL,
    "name" VARCHAR(200) NOT NULL,
    "price" DECIMAL(10, 2) NOT NULL,
    "stock" INTEGER NOT NULL DEFAULT '0',
    "category_id" INTEGER NOT NULL,
    "created_at" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    "description" TEXT NULL
);
ALTER TABLE
    "products" ADD PRIMARY KEY("id");
CREATE TABLE "customers"(
    "id" SERIAL NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "surname" VARCHAR(100) NOT NULL,
    "age" INTEGER NOT NULL,
    "gender" VARCHAR(20) NOT NULL,
    "email" VARCHAR(100) NOT NULL,
    "phone" VARCHAR(50) NULL,
    "created_at" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL DEFAULT 'now()'
);
ALTER TABLE
    "customers" ADD PRIMARY KEY("id");
ALTER TABLE
    "customers" ADD CONSTRAINT "customers_email_unique" UNIQUE("email");
CREATE TABLE "orders"(
    "id" SERIAL NOT NULL,
    "customer_id" INTEGER NOT NULL,
    "shipping_adress_id" INTEGER NOT NULL,
    "price" DECIMAL(10, 2) NOT NULL,
    "shipping_price" DECIMAL(10, 2) NOT NULL,
    "order_date" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL DEFAULT 'now()',
    "status" VARCHAR(50) NOT NULL
);
ALTER TABLE
    "orders" ADD PRIMARY KEY("id");
CREATE TABLE "order_items"(
    "id" SERIAL NOT NULL,
    "order_id" INTEGER NOT NULL,
    "product_id" INTEGER NOT NULL,
    "quantity" INTEGER NOT NULL,
    "total_price" DECIMAL(10, 2) NOT NULL
);
ALTER TABLE
    "order_items" ADD PRIMARY KEY("id");
CREATE TABLE "reviews"(
    "id" SERIAL NOT NULL,
    "customer_id" INTEGER NOT NULL,
    "product_id" INTEGER NOT NULL,
    "rating" INTEGER NOT NULL,
    "comment" TEXT NOT NULL,
    "created_at" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL DEFAULT 'now()'
);
ALTER TABLE
    "reviews" ADD PRIMARY KEY("id");
CREATE TABLE "shipping_adresses"(
    "id" SERIAL NOT NULL,
    "customer_id" INTEGER NOT NULL,
    "open_adress" VARCHAR(255) NOT NULL,
    "city" VARCHAR(100) NOT NULL,
    "country" VARCHAR(100) NOT NULL,
    "zip_code" VARCHAR(20) NOT NULL
);
ALTER TABLE
    "shipping_adresses" ADD PRIMARY KEY("id");
ALTER TABLE
    "shipping_adresses" ADD CONSTRAINT "shipping_adresses_customer_id_foreign" FOREIGN KEY("customer_id") REFERENCES "customers"("id");
ALTER TABLE
    "order_items" ADD CONSTRAINT "order_items_product_id_foreign" FOREIGN KEY("product_id") REFERENCES "products"("id");
ALTER TABLE
    "orders" ADD CONSTRAINT "orders_customer_id_foreign" FOREIGN KEY("customer_id") REFERENCES "customers"("id");
ALTER TABLE
    "reviews" ADD CONSTRAINT "reviews_product_id_foreign" FOREIGN KEY("product_id") REFERENCES "products"("id");
ALTER TABLE
    "products" ADD CONSTRAINT "products_category_id_foreign" FOREIGN KEY("category_id") REFERENCES "categories"("id");
ALTER TABLE
    "reviews" ADD CONSTRAINT "reviews_customer_id_foreign" FOREIGN KEY("customer_id") REFERENCES "customers"("id");
ALTER TABLE
    "order_items" ADD CONSTRAINT "order_items_order_id_foreign" FOREIGN KEY("order_id") REFERENCES "orders"("id");
ALTER TABLE
    "orders" ADD CONSTRAINT "orders_shipping_adress_id_foreign" FOREIGN KEY("shipping_adress_id") REFERENCES "shipping_adresses"("id");