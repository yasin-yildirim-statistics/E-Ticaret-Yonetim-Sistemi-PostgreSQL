-- ====================== TABLOLAR ======================

/*Veritabanı Yapısı
-Tablolar:
●	categories (kategoriler)
●	products (ürünler)
●	customers (müşteriler)
●	orders (siparişler)
●	order_items (sipariş detayları)
●	reviews (ürün yorumları)
●	shipping_addresses (teslimat adresleri)*/

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
-- Alter komutunu kullanarak sütun ismini düzenliyoruz.
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

-- ====================== TABLOLARA VERİ EKLEME ======================
-- 266. Satırda Veri Ekleme İşlemi Biter
-- Tabloların içini temizlemek için TRUNCATE TABLE tablox RESTART IDENTITY CASCADE;

-- Kategori Tablosuna Veri Ekleme (10)

INSERT INTO categories (name, description) VALUES
('Elektronik', 'Telefon, bilgisayar, tablet, kamera ve elektronik aksesuarlar'),
('Giyim', 'Kadın ve erkek kıyafetleri, günlük ve özel giysiler'),
('Ev & Mutfak', 'Mobilya, dekorasyon ve mutfak ürünleri'),
('Spor & Outdoor', 'Spor ekipmanları ve outdoor aktiviteleri için ürünler'),
('Oyuncak & Hobi', 'Çocuk oyuncakları ve hobi ürünleri'),
('Kozmetik & Kişisel Bakım', 'Makyaj, cilt bakımı ve kişisel bakım ürünleri'),
('Ayakkabı & Çanta', 'Spor, günlük ayakkabı ve çanta çeşitleri'),
('Saat & Takı', 'Saatler, bilezikler, kolyeler ve diğer aksesuarlar'),
('Bebek & Çocuk', 'Bebek bakım ürünleri, çocuk giysileri ve oyuncakları'),
('Sağlık & Vitamin', 'Vitamin, takviye ve sağlık ürünleri');


-- Ürünler Tablosuna Veri Ekleme (30)

INSERT INTO products (category_id, name, description, price, stock) VALUES
-- Elektronik
(1, 'Ajazz AJ179P', 'Ajazz AJ179 PRO optik mouse, 8000Hz raporlama hızı, ergonomik yapı ve şarj istasyonu', 25990.00, 50),
(1, 'AMD RX 9070', 'AMD RX 9070 ekran kartı, 16GB GDDR6 bellek, yüksek FPS oyun performansı ve ray tracing desteği', 27490.40, 40),
(1, 'Xiaomi Pad 7"', 'Xiaomi Pad 7 tablet, 11.2 inç IPS ekran, 256GB depolama, Wi-Fi ve multimedya kullanımı', 14999.99, 20),
-- Giyim
(2, 'Kadın Elbise', 'Yazlık pamuklu kadın elbisesi, rahat kesim, şık desen ve farklı renk seçenekleri', 800.00, 100),
(2, 'Erkek Gömlek', 'Günlük pamuklu erkek gömlek, klasik kesim ve uzun ömürlü kumaş', 510.20, 120),
(2, 'Unisex Mont', 'Kışlık su geçirmez unisex mont, rüzgar korumalı, kapüşonlu ve rahat kullanım', 1300.00, 60),
-- Ev & Mutfak
(3, 'Tencere Seti', 'Paslanmaz çelik 10 parçalık tencere seti, dayanıklı ve bulaşık makinesinde yıkanabilir', 700.00, 50),
(3, '3 Kişilik Kanepe', 'Modern tasarım, rahat oturma, kaliteli döşeme ve ev dekorasyonuna uyumlu', 5500.99, 10),
(3, 'Mutfak Robotu', 'Çok fonksiyonlu mutfak robotu, doğrama, karıştırma ve yoğurma özellikleri, güçlü motor', 1600.30, 30),
-- Spor & Outdoor
(4, 'Koşu Bandı', 'Elektrikli koşu bandı, hız ve eğim ayarlı, LCD ekran, ev ve spor salonu kullanımı için ideal', 9000.00, 15),
(4, 'Yoga Matı', '6mm kalınlığında kaymaz yoga matı, taşıma çantası ve kolay temizlenebilir yüzey', 300.10, 80),
(4, 'Dağ Bisikleti', 'Alüminyum kadro, 21 vites, dayanıklı lastikler, şehir ve dağ kullanımı için uygun', 3500.60, 20),
-- Oyuncak & Hobi
(5, 'LEGO Star Wars', 'LEGO Star Wars 1200 parçalık set, çocuk ve yetişkinler için yaratıcı oyun imkanı', 800.00, 60),
(5, 'Puzzle 1000 Parça', '1000 parçalık manzara puzzle, kaliteli karton ve net baskı ile eğlenceli hobi', 210.50, 100),
(5, 'RC Araba', 'Uzaktan kumandalı 1:16 ölçekli RC araba, şarj edilebilir batarya ve yüksek hız', 600.99, 40),
-- Kozmetik & Kişisel Bakım
(6, 'Ruj Seti', '6’lı mat ve parlak ruj seti, uzun süre kalıcı renkler ve çeşitli tonlar', 250.00, 70),
(6, 'Şampuan', 'Tüm saç tipleri için besleyici ve nemlendirici formüle sahip saç bakım şampuanı', 100.20, 120),
(6, 'Parfüm', 'Kadın ve erkek parfüm seti, 50ml, kalıcı koku ve şık ambalaj', 500.99, 50),
-- Ayakkabı & Çanta
(7, 'Spor Ayakkabı', 'Günlük koşu ve spor için hafif, nefes alabilir ve esnek spor ayakkabı', 600.00, 80),
(7, 'Kadın Çanta', 'Omuz çantası, şık tasarım, dayanıklı malzeme ve geniş iç hacim', 500.10, 60),
(7, 'Bot', 'Kışlık bot, su geçirmez, sıcak tutan iç astar ve kaymaz taban', 900.99, 40),
-- Saat & Takı
(8, 'Kol Saati', 'Analog kol saati, suya dayanıklı, paslanmaz çelik kasa ve şık tasarım', 1300.00, 30),
(8, 'Bilezik', 'Altın kaplama bilezik, zarif tasarım ve ayarlanabilir boy', 600.40, 50),
(8, 'Kolye', 'Gümüş kolye, 45cm zincir uzunluğu, şık taş detaylı tasarım', 400.99, 40),
-- Bebek & Çocuk
(9, 'Bebek Arabası', 'Katlanabilir bebek arabası, 3 pozisyonlu sırt dayanağı ve güvenlik kemeri', 3500.00, 20),
(9, 'Bebek Bezi Seti', '0-3 yaş için ekonomik paket bebek bezi, hipoalerjenik ve cilt dostu', 300.60, 150),
(9, 'Çocuk T-Shirt', 'Pamuklu çocuk tişörtü, renkli ve rahat kesim, uzun ömürlü kumaş', 200.00, 100),
-- Sağlık & Vitamin
(10, 'Vitamin C', '1000mg takviye vitamin, bağışıklık sistemini güçlendirir', 150.00, 100),
(10, 'Omega 3', 'Balık yağı kapsülleri, kalp ve beyin sağlığı için yüksek kaliteli içerik', 200.30, 80),
(10, 'Protein Tozu', 'Whey protein, sporcular için kas gelişimini destekler ve yüksek protein içerir', 500.99, 50);

-- Müşteri Tablosuna Veri Ekleme (20)

INSERT INTO customers (name, surname, age, gender, email, phone) VALUES
('Yasin','Yıldırım',28,'Male','yasinyildirim.work@gmail.com','05077364511'),
('Bengisu','Uçar',27,'Female','mimarbengisuucar@gmail.com','05057654321'),
('Mehmet','Kaya',45,'Male','mehmet.kaya@gmail.com','05329876543'),
('Fatma','Şahin',29,'Female','fatma.sahin@hotmail.com','05053456789'),
('Emre','Çelik',32,'Male','emre.celik@gmail.com','05051239876'),
('Elif','Öztürk',27,'Female','elif.ozturk@gmail.com','05322345678'),
('Ali','Koç',40,'Male','ali.koc@gmail.com','05056781234'),
('Murat','Arslan',31,'Male','murat.arslan@gmail.com','05059871234'),
('Hülya','Kara',38,'Female','hulya.kara@gmail.com','05321237890'),
('Berk','Güneş',25,'Male','berk.gunes@hotmail.com','05053459876'),
('Okan','Polat',33,'Male','okan.polat@gmail.com','05051239087'),
('Derya','Kurt',28,'Female','derya.kurt@gmail.com','05322346789'),
('Barış','Aksoy',42,'Male','baris.aksoy@gmail.com','05053451234'),
('Selin','Çetin',26,'Female','selin.cetin@gmail.com','05325789012'),
('Ege','Demirtaş',35,'Male','ege.demirtas@gmail.com','05059870123'),
('Nihan','Özkan',31,'Female','nihan.ozkan@hotmail.com','05321239871'),
('Serkan','Yıldız',39,'Male','serkan.yildiz@gmail.com','05052349012'),
('Merve','Acar',27,'Female','merve.acar@gmail.com','05323451209'),
('Kaan','Taş',29,'Male','kaan.tas@gmail.com','05056789045'),
('Seda','Turan',33,'Female','seda.turan@gmail.com','05321237891');


-- Teslimat Adresi Tablosuna Veri Ekleme (20)

INSERT INTO shipping_adresses (customer_id, address_line, city, country, zipcode) VALUES
(1, 'Çamkule Mah. 4699 Sok. No:24_2', 'İzmir', 'Türkiye', '35080'),
(2, 'Atakum Mah. Sahil Yolu Cad. No:5', 'Samsun', 'Türkiye', '55100'),
(3, 'Yıldırım Beyazıt Mah. Yayla Sok. No:22', 'Bursa', 'Türkiye', '16050'),
(4, 'Barbaros Mah. Güneş Cad. No:8', 'Antalya', 'Türkiye', '07030'),
(5, 'Yenişehir Mah. 2. Etap Sitesi D:15', 'Kocaeli', 'Türkiye', '41040'),
(6, 'Kazım Karabekir Cad. No:5', 'İzmir', 'Türkiye', '35030'),
(7, 'Bahçelievler Mah. Papatya Sok. No:19', 'Samsun', 'Türkiye', '55060'),
(8, 'Esentepe Mah. Çamlık Cad. No:11', 'Sakarya', 'Türkiye', '54020'),
(9, 'Merkez Mah. Şelale Sok. No:3', 'Kayseri', 'Türkiye', '38010'),
(10, 'İnönü Cad. Beyaz Evler Sitesi A2 D:4', 'Eskişehir', 'Türkiye', '26030'),
(11, 'Deniz Mah. Sahil Cad. No:27', 'Mersin', 'Türkiye', '33070'),
(12, 'Yalı Mah. Kordonboyu Cad. No:6', 'Balıkesir', 'Türkiye', '10020'),
(13, 'Kurtuluş Mah. Okul Sok. No:14', 'Trabzon', 'Türkiye', '61040'),
(14, 'Gülbahçe Mah. Çınar Cad. No:9', 'Aydın', 'Türkiye', '09010'),
(15, 'Mevlana Mah. Yenişehir Cad. No:13', 'Konya', 'Türkiye', '42060'),
(16, 'Hürriyet Mah. Çamlık Sok. No:21', 'Gaziantep', 'Türkiye', '27090'),
(17, 'Yeşilvadi Mah. Tomurcuk Cad. No:4', 'Diyarbakır', 'Türkiye', '21080'),
(18, 'Mavişehir Cad. Gümüş Sk. No:12', 'Muğla', 'Türkiye', '48000'),
(19, 'Cumhuriyet Mah. Lale Sok. No:18', 'Malatya', 'Türkiye', '44030'),
(20, 'Şehitler Cad. Park Evleri B Blok D:7', 'Ankara', 'Türkiye', '06010');

-- Siparişler Tablosuna Veri Ekleme (15)
-- 1000tl ve üzerine kargo ücretsiz

INSERT INTO orders (customer_id, shipping_address_id, price, shipping_price, status, order_date) VALUES
(1, 1, 800.00, 49.90, 'Tamamlandı', '2025-05-10'),
(2, 2, 510.20, 49.90, 'Tamamlandı', '2025-05-22'),
(3, 3, 14999.99, 0, 'Tamamlandı', '2025-06-05'),
(4, 4, 1300.00, 0, 'Tamamlandı', '2025-06-28'),
(5, 5, 2600.00, 0, 'Teslim Edildi', '2025-07-03'),
(6, 6, 840.00, 49.90, 'Teslim Edildi', '2025-07-18'),
(7, 7, 3490.00, 0, 'Teslim Edildi', '2025-08-02'),
(8, 8, 920.00, 49.90, 'Teslim Edildi', '2025-08-27'),
(9, 9, 1500.00, 0, 'Teslim Edildi', '2025-09-06'),
(10, 10, 780.00, 49.90, 'Teslim Edildi', '2025-09-25'),
(11, 11, 3200.00, 0, 'Kargoda', '2025-10-03'),
(12, 12, 600.00, 49.90, 'Kargoda', '2025-10-11'),
(13, 13, 1600.00, 0, 'Kargoda', '2025-10-22'),
(14, 14, 450.00, 49.90, 'Kargoda', '2025-10-29'),
(15, 15, 2799.00, 0, 'Hazırlanıyor', '2025-11-02');

-- Sipariş Detayları Tablosuna Veri Ekleme (15)

INSERT INTO order_items (order_id, product_id, quantity, total_price) VALUES
(1, 4, 1, 849.90),
(2, 5, 1, 560.10),
(3, 3, 1, 14999.99),
(4, 6, 1, 1300.00),
(5, 1, 1, 2600.00),
(6, 16, 1, 889.90),
(7, 3, 1, 3490.00),
(8, 14, 1, 969.90),
(9, 2, 1, 1500.00),
(10, 19, 1, 829.90),
(11, 5, 1, 3200.00),
(12, 8, 1, 649.90),
(13, 12, 1, 1600.00),
(14, 11, 1, 499.90),
(15, 4, 1, 2799.00);

-- Ürün Yorumları Tablosuna Veri Ekleme (13)

INSERT INTO reviews (product_id, customer_id, rating, comment) VALUES
(4, 1, 5, 'Ürün kaliteli ve tam bedenime oldu. Tavsiye ederim.'),
(5, 2, 3, 'Kumaşı güzel ama biraz ince, yine de memnun kaldım.'),
(3, 3, 5, 'Tablet çok hızlı ve ekranı mükemmel. Beklentimi aştı.'),
(6, 4, 4, 'Tencere seti kaliteli, sadece kapaklar biraz hafif.'),
(1, 5, 5, 'Mouse performansı efsane, 8000Hz farkını hissettiriyor.'),
(16, 6, 5, 'Renkleri harika, kalıcılığı da oldukça iyi.'),
(3, 7, 4, 'Tablet gayet iyi fakat kargo biraz gecikti.'),
(14, 8, 4, 'Puzzle baskısı kaliteli, parçalar tam oturuyor.'),
(2, 9, 5, 'Ekran kartı performansı mükemmel, fiyatına değer.'),
(19, 10, 3, 'Bebek bezi kaliteli ama paket biraz ezik geldi.');

-- ====================== FONKSİYONLAR ======================

/* 1. Fonksiyonlar (3 adet)
1	calculate_order_total(order_id) - Sipariş toplam tutarını hesaplayan fonksiyon
2	customer_lifetime_value(customer_id) - Müşterinin toplam alışveriş tutarını hesaplayan
3	stock_status(product_id) - Stok durumunu kontrol eden (Bol/Orta/Az/Tükendi) fonksiyon */

-- 1 calculate_order_total(order_id) - Sipariş toplam tutarını hesaplayan fonksiyon
-- (product.price * order_items.quantity) + orders.shipping_price
create or replace function calculate_order_total(a integer)
returns numeric(10,2)
language sql
as $$
    select (p.price * oi.quantity) + o.shipping_price
    from orders o
    inner join order_items oi on  oi.order_id = o.id
    inner join products p ON p.id = oi.product_id
    where o.id = a;
    $$;
--Kullanmak için
select calculate_order_total(2);

-- 2 customer_lifetime_value(customer_id) - Müşterinin toplam alışveriş tutarını hesaplayan
-- (product.price * order_items.quantity) + orders.shipping_price where customer.id = ...
create or replace function customer_lifetime_value(a int)
returns numeric(10,2)
language sql
as $$
    select sum(p.price * oi.quantity) + sum(o.shipping_price)
    from orders o
    inner join order_items oi on  oi.order_id = o.id
    inner join products p on p.id = oi.product_id
    inner join customers c on c.id = o.customer_id
    where c.id = a;
    $$;
--Kullanmak için
select customer_lifetime_value(1);

-- BONUS
-- 2 ad soyad girildiğinde müşterinin toplam alışverişini hesaplayan fonksiyon
create or replace function customer_lifetime_value_name(a varchar(30), b varchar(30))
returns numeric(10,2)
language sql
as $$
    select sum(p.price * oi.quantity) + sum(o.shipping_price)
    from orders o
    inner join order_items oi on  oi.order_id = o.id
    inner join products p on p.id = oi.product_id
    inner join customers c on c.id = o.customer_id
    where c.name ilike a and c.surname ilike b;
    $$;
--Kullanmak için örnek
select customer_lifetime_value('Yasin','yıldırım');

-- 3 stock_status(product_id) - Stok durumunu kontrol eden (Bol/Orta/Az/Tükendi) fonksiyon
-- 100 ve üstü stok durumu Bol, 50 ve üstü Orta, 0 ile 50 arası az ve 0 stok miktarı Tükendi
create or replace function stock_status(c integer)
returns varchar
language plpgsql
as $$
    DECLARE
        stok int;
        durum varchar(100);
    BEGIN
    stok:= (select stock from products where c = id);

    if stok >= 100 then
            durum:= 'Bol';
        elseif stok>= 50 then
            durum:= 'Orta';
        elseif stok>= 0 then
            durum:= 'Az';
        elseif stok = 0 then
            durum:= 'Tükendi';
        else
            durum:= 'Girmiş olduğunuz stok miktarı 0 dan büyük olmalıdır.';
        end if;
        return durum;
    end;
    $$;
--Kullanmak için örnek
select stock_status(5);

-- BONUS
-- stok miktarı elle girildiğinde, stok durumunu yazan fonksiyon
create or replace function stock_status_check(stok int)
returns varchar
language plpgsql
as $$
    DECLARE
        durum varchar;
    BEGIN
        if stok >= 100 then
            durum:= 'Bol';
        elseif stok>= 50 then
            durum:= 'Orta';
        elseif stok>= 0 then
            durum:= 'Az';
        elseif stok = 0 then
            durum:= 'Tükendi';
        else
            durum:= 'Girmiş olduğunuz stok miktarı 0 dan büyük olmalıdır.';
        end if;
        return durum;
    end;
    $$;

-- ====================== TRIGGERLAR ======================

/* 2. Triggerlar (3 adet)
1	Sipariş oluşturulduğunda stok miktarını düşüren trigger
2	Ürün fiyatı güncellendiğinde log tutan trigger
3	Sipariş iptal edildiğinde stokları geri yükleyen trigger */



-- 1 Sipariş oluşturulduğunda stok miktarını düşüren trigger

create or replace function update_stock()
returns trigger
language plpgsql
as $$
    BEGIN
       update products
           set stock = stock - new.quantity -- siparişteki ürün adedi
               where id = new.product_id;
        return  new;
    END;
    $$;

create trigger trg_update_stock
    after insert on order_items
    for each row
    execute function update_stock();

-- 2 Ürün fiyatı güncellendiğinde log tutan trigger
-- Bunun için bir logları tutan bir tablo oluşturmamız gerek

create table product_price_change_log(
    id serial primary key,
    product_id int not null,
    old_price numeric(10,2), --eski fiyatı tutan sütun
    new_price numeric(10,2), --yeni fiyatı tutan sütun
    changed_at timestamp default now() --değişim zamanını tutar
);

-- trigger fonksiyonu
create or replace function log_price_change()
returns trigger
language plpgsql
as $$
    BEGIN -- fiyat değiştiğinde log almak
        if new.price <> old.price then
            insert into product_price_change_log (product_id, old_price, new_price) VALUES(
            old.id, old_price, new_price);
        end if;
        return new;
    end;
    $$;

create trigger trg_log_price_change
    after update on products
    for each row
    execute function log_price_change();

--3	Sipariş iptal edildiğinde stokları geri yükleyen trigger

create or replace function restore_stock_on_cancel()
returns trigger
language plpgsql
as $$
    BEGIN -- status'de büyük küçük harf farketmeksizin iptal yazarsa çalıştırma
        if new.status ilike 'İptal' and old.status not ilike 'İptal' then
            update products p
            set stock = stock + oi.quantity
            from order_items oi
            where oi.product_id = p.id and oi.order_id = new.id;
        end if;
        return new;
    end;
    $$;

create trigger trg_restore_stock_quantity
after update on products
for each row
execute function restore_stock_on_cancel();

-- ====================== STORED PROCEDURELAR ======================
/*
1	sp_place_order() - Sipariş verme işlemi (stok kontrolü dahil)
2	sp_cancel_order() - Sipariş iptal etme işlemi */

create or replace procedure sp_place_order(
s_customer_id int,
s_shipping_address_id int,
s_shipping_price numeric(10,2),
s_price numeric(10,2),
s_products_id int,
s_quantity int)
language plpgsql
as $$
    DECLARE
        stock_check int:= null;
    BEGIN -- seçtiğimiz product_id, products tablosundaki id'ye bakarak stok miktarını stock_check değerine atar.
        select stock into stock_check from products where id = s_products_id;

        if stock_check = null then
            raise exception 'Bu üründe stok kalmamıştır.';
        elseif stock_check < s_quantity then
            raise exception 'Bu üründe % tane stok bulunmamaktadır.', s_quantity;
        end if;
        --order_date = now() ve status = 'Hazırlanıyor' default değerlerine sahip oldukları için eklenmeyecek
        insert into orders(customer_id, shipping_address_id, shipping_price, price) values --order_date = now(), status = 'Hazırlanıyor' default değerlerine sahip oldukları için bu yüzden eklenmedi
        (s_customer_id, s_shipping_address_id, s_shipping_price, s_price);
    end;
    $$;
--Kullanmak için;
call sp_place_order(1, 1, 0.00, 14999.99,3, 1);
-- Stok Kontrol Hatasını Test Etmek İçin;
call sp_place_order(1, 1, 0.00, 82514.85,8, 15);















