
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

-- ============================================ TABLOLARA VERİ EKLEME ============================================
-- Tüm verileri baştan sona seçerek, tek hamlede run yapabilirsiniz.
-- 340. Satırda Veri Ekleme İşlemi Biter
-- Tabloların içini temizlemek için TRUNCATE TABLE tablox RESTART IDENTITY CASCADE;
-- Örnek olarak orders tablosunun son 6 hanesini silmek için komut: DELETE FROM orders WHERE id IN (SELECT id FROM orders ORDER BY created_at DESC LIMIT 6);

-- Kategori Tablosuna Veri Ekleme (10)
-- select * from categories;

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
-- select * from products;

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
-- select * from customers;

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

-- Teslimat Adresi Tablosuna Veri Ekleme (25)
-- select * from shipping_adresses;

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
(20, 'Şehitler Cad. Park Evleri B Blok D:7', 'Ankara', 'Türkiye', '06010'),
(1, 'Yeni Mah. 123 Sok. No:10', 'İzmir', 'Türkiye', '35090'), --21
(3, 'Çınar Mah. 45 Cad. No:12', 'Bursa', 'Türkiye', '16060'), --22
(5, 'Barış Mah. 78 Sok. No:8', 'Kocaeli', 'Türkiye', '41050'), --23
(7, 'Gülbahçe Mah. 33 Cad. No:5', 'Samsun', 'Türkiye', '55070'), --24
(10, 'Atatürk Mah. 21 Sok. No:4', 'Eskişehir', 'Türkiye', '26040'); --25

-- Siparişler Tablosuna Veri Ekleme (30)
-- 1000tl ve üzeri siparişlere kargo ücretsiz
-- select * from orders;

INSERT INTO orders (id, customer_id, shipping_address_id, shipping_price, price, status, order_date) VALUES
(1, 7, 7, 0.00, 20000.00, 'Tamamlandı', '2025-01-15'),
(2, 6, 6, 49.90, 500.10, 'Tamamlandı', '2025-02-14'),
(3, 5, 5, 0.00, 1200.00, 'Tamamlandı', '2025-03-15'),
(4, 4, 4, 0.00, 1001.98, 'Tamamlandı', '2025-04-14'),
(5, 20, 20, 0.00, 6500.00, 'Tamamlandı', '2025-05-15'),
(6, 19, 19, 49.90, 1600.00, 'Tamamlandı', '2025-06-14'),
(7, 18, 18, 49.90, 2100.00, 'Tamamlandı', '2025-07-15'),
(8, 17, 17, 0.00, 1020.40, 'Tamamlandı', '2025-08-14'),
(9, 16, 16, 49.90, 500.00, 'Tamamlandı', '2025-09-15'),
(10, 15, 15, 0.00, 7001.20, 'Tamamlandı', '2025-10-14'),
(11, 14, 14, 49.90, 500.99, 'Teslim Edildi', '2025-10-15'),
(12, 13, 13, 0.00, 2403.96, 'Teslim Edildi', '2025-10-18'),
(13, 12, 12, 0.00, 1600.00, 'Teslim Edildi', '2025-10-21'),
(14, 11, 11, 0.00, 1200.80, 'Teslim Edildi', '2025-10-24'),
(15, 10, 25, 49.90, 500.10, 'Teslim Edildi', '2025-10-27'),
(16, 9, 9, 0.00, 8001.50, 'Teslim Edildi', '2025-10-30'),
(17, 8, 8, 0.00, 2600.00, 'Teslim Edildi', '2025-11-02'),
(18, 7, 24, 0.00, 27490.40, 'Teslim Edildi', '2025-11-05'),
(19, 6, 6, 0.00, 3200.00, 'Teslim Edildi', '2025-11-08'),
(20, 5, 23, 0.00, 600.20, 'Teslim Edildi', '2025-11-11'),
(21, 4, 4, 49.90, 250.00, 'Kargoya Verildi', '2025-11-14'),
(22, 3, 22, 0.00, 51980.00, 'Kargoya Verildi', '2025-11-17'),
(23, 2, 2, 49.90, 510.20, 'Kargoya Verildi', '2025-11-20'),
(24, 1, 21, 0.00, 44999.97, 'Kargoya Verildi', '2025-11-22'),
(25, 10, 10, 49.90, 421.00, 'Kargoya Verildi', '2025-11-24'),
(26, 11, 11, 0.00, 3200.60, 'Kargoya Verildi', '2025-11-25'),
(27, 12, 12, 49.90, 500.10, 'Kargoya Verildi', '2025-11-26'),
(28, 13, 13, 0.00, 1400.00, 'Hazırlanıyor', '2025-11-27'),
(29, 14, 14, 49.90, 2401.60, 'Hazırlanıyor', '2025-11-28'),
(30, 15, 15, 0.00, 10500.00, 'Hazırlanıyor', '2025-11-29');

-- Sipariş Detayları Tablosuna Veri Ekleme (30)
-- select * from order_items;

INSERT INTO order_items (id, order_id, product_id, quantity, total_price) VALUES
(1, 1, 21, 2, 20000.00),
(2, 2, 20, 1, 500.10),
(3, 3, 19, 2, 1200.00),
(4, 4, 18, 2, 1001.98),
(5, 5, 22, 5, 6500.00),
(6, 6, 4, 2, 1600.00),
(7, 7, 7, 3, 2100.00),
(8, 8, 5, 2, 1020.40),
(9, 9, 16, 2, 500.00),
(10, 10, 12, 2, 7001.20),
(11, 11, 30, 1, 500.99),
(12, 12, 15, 4, 2403.96),
(13, 13, 4, 2, 1600.00),
(14, 14, 23, 2, 1200.80),
(15, 15, 20, 1, 500.10),
(16, 16, 9, 5, 8001.50),
(17, 17, 6, 2, 2600.00),
(18, 18, 2, 1, 27490.40),
(19, 19, 13, 4, 3200.00),
(20, 20, 11, 2, 600.20),
(21, 21, 16, 1, 250.00),
(22, 22, 1, 2, 51980.00),
(23, 23, 5, 1, 510.20),
(24, 24, 3, 3, 44999.97),
(25, 25, 14, 2, 421.00),
(26, 26, 9, 2, 3200.60),
(27, 27, 20, 1, 500.10),
(28, 28, 7, 2, 1400.00),
(29, 29, 23, 4, 2401.60),
(30, 30, 25, 3, 10500.00);

-- Ürün Yorumları Tablosuna Veri Ekleme (13)
-- select * from reviews;

INSERT INTO reviews (product_id, customer_id, rating, comment, created_at) VALUES
(21, 7, 5, 'Muhteşem bir ürün, tam beklediğim gibi. Hızlı kargo.', '2025-01-20'),
(20, 6, 4, 'Fiyatına göre performansı çok iyi. Sadece biraz daha hızlı olabilirdi.', '2025-02-20'),
(19, 5, 5, 'Çok şık ve kullanışlı. Bayıldım!', '2025-03-20'),
(18, 4, 3, 'Ortalama bir ürün. İşimi gördü ancak kalitesi çok yüksek değil.', '2025-04-20'),
(22, 20, 5, 'Beklediğimden bile iyi çıktı. Kesinlikle tavsiye ederim.', '2025-05-20'),
(4, 19, 4, 'Kullanımı basit, dayanıklı malzeme. Beklenenden daha iyi.', '2025-06-20'),
(7, 18, 5, 'Tamamen sorunsuz bir alışveriş. Ürün açıklaması doğruydu.', '2025-07-20'),
(5, 17, 4, 'Hediye olarak aldım, çok beğenildi. Paketleme özenliydi.', '2025-08-20'),
(16, 16, 3, 'Kargo yavaştı ama ürün iyi paketlenmişti. Fena değil.', '2025-09-20'),
(12, 15, 5, 'Mükemmel, bu fiyata kaçırılmaz. Kesinlikle tavsiye.', '2025-10-20'),
(30, 14, 4, 'Görseldeki gibi geldi. Rengi canlı ve kaliteli his veriyor.', '2025-10-20'),
(15, 13, 5, 'Süper hızlı teslimat ve kaliteli ürün. Tekrar sipariş verilebilir.', '2025-10-23'),
(4, 12, 4, 'Ambalaj biraz hasarlıydı ama ürün sağlam. İyi ki almışım.', '2025-10-26'),
(23, 11, 3, 'Boyutu beklediğimden küçüktü. İşlevi iyi ve kullanışlı.', '2025-10-29'),
(20, 10, 5, 'Tam bir fiyat/performans ürünü. Çok memnun kaldım.', '2025-11-01'),
(9, 9, 4, 'Yorumlarda yazıldığı kadar iyi. Tavsiye ederim.', '2025-11-04'),
(6, 8, 5, 'Kurulumu çok kolay oldu. Hiç zorlanmadım.', '2025-11-07'),
(2, 7, 4, 'Harika bir tasarım, çok zarif duruyor. Kullanımı rahat.', '2025-11-10'),
(13, 6, 3, 'Uzun vadede nasıl olur bilemem ama şimdilik sorun yok gibi.', '2025-11-13'),
(11, 5, 5, 'Kesinlikle beş yıldızı hak ediyor. Çok hızlı ulaştı.', '2025-11-14');

-- ============================================ FONKSİYONLAR ============================================

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
create or replace function customer_lifetime_value(f_customer_id int)
returns numeric(10,2)
language sql
as $$
    select sum(p.price * oi.quantity) + sum(o.shipping_price)
    from orders o
    inner join order_items oi on  oi.order_id = o.id
    inner join products p on p.id = oi.product_id
    inner join customers c on c.id = o.customer_id
    where c.id = f_customer_id;
    $$;
--Kullanmak için
select customer_lifetime_value(11);
-- orders tablosuna yeni eklenen veriler için order_items tablosuna da veriler eklenmeden doğru çalışmaz.

-- BONUS OLARAK
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
select stock_status(6);

-- BONUS
-- stok miktarı elle girildiğinde, sadece yazılan sayının stok durumunu yazan fonksiyon
create or replace function stock_status_check(stok int)
returns varchar
language plpgsql
as $$
    DECLARE
        durum varchar;
    BEGIN
        if stok >= 100 then
            durum:= 'Bol';
        elseif stok >= 30 then
            durum:= 'Orta';
        elseif stok >= 0 then
            durum:= 'Az';
        elseif stok = 0 then
            durum:= 'Tükendi';
        else
            durum:= 'Girmiş olduğunuz stok miktarı 0 dan büyük olmalıdır.';
        end if;
        return durum;
    end;
    $$;
--Kullanmak için:
select stock_status_check(29);

-- ============================================ TRIGGER'LAR ============================================

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

-- Trigger fonksiyonu
create or replace function log_price_change()
returns trigger
language plpgsql
as $$
    BEGIN
        if new.price <> old.price then -- fiyat değiştiğinde log almak
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

--3	Sipariş iptal edildiğinde stokları geri yükleyen trigger (tekrar bakılması lazım)

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

-- ============================================ STORED PROCEDURE'LAR ============================================

-- 1	sp_place_order() - Sipariş verme işlemi (stok kontrolü dahil)

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
        --zaten order_date = now() ve status = 'Hazırlanıyor' default değerlerine sahip oldukları için veri olarak eklenmeyecek
        insert into orders(customer_id, shipping_address_id, shipping_price, price) values
        (s_customer_id, s_shipping_address_id, s_shipping_price, s_price);
    end;
    $$;
--Kullanmak için;
call sp_place_order(1, 1, 0.00, 14999.99,3, 1);
-- Stok Kontrol Hatasını Test Etmek İçin;
call sp_place_order(1, 1, 0.00, 82514.85,8, 15);

-- 2 sp_cancel_order() - Sipariş iptal etme işlemi

create or replace procedure sp_cancel_order(s_order_id int)
language plpgsql
as $$
    DECLARE
        sp_order_id_check int:= null;
        sp_order_status_check varchar(50):= null;
    BEGIN
        -- Girilen s_order_id siparişlerde var mı yok mu (valid) kontrol etmek
        select id into sp_order_id_check from orders where id = s_order_id;
        if sp_order_id_check is null then
        raise exception 'Doğru sipariş numarası giriniz.';
        end if;

         -- Girilen order_id valid ise devam;
        select status into sp_order_status_check from orders where id = s_order_id;

        if sp_order_status_check ilike 'Kargoda' then
            raise exception 'Siparişinizi iptal etmek için ürünler tarafınıza ulaşınca, anlaşmalı kargo firması ile ürünleri iade edin.';
        elseif sp_order_status_check ilike 'Teslim Edildi' then
            raise exception 'Lütfen siparişin iptali için, ürünleri anlaşmalı kargo firmasına teslim edin';
        elseif sp_order_status_check ilike 'İade Kargoda' then
            raise exception 'Ürünlerin iadesi, ürünleri teslim aldığımız andan itibaren 2(iki) iş günü içerisinde yapılacaktır.';
        elseif sp_order_status_check ilike 'Tamamlandı' then
            raise exception 'Siparişin iptali için sizlere tanınan süre bitmiştir. Lütfen ürünlerle ilgili bir sorun var ise garanti işlemlerini başlatınız.';
        else delete from orders where id = s_order_id;
        raise notice '% nolu siparişiniz iptal edilmiştir.', s_order_id;
        end if;

    end;
    $$;

--Kullanmak için
call sp_cancel_order(22);

-- ============================================ VIEW'LAR ============================================

-- 1 Kategorilere göre ürün satış istatistikleri

-- Basit
create view vm_product_sales_by_category as
select
    c.name as "Kategori Adı",
    sum(oi.quantity) as "Ürün Satış Miktarı"
    from categories c
inner join products p on c.id = p.category_id
inner join order_items oi on oi.product_id = p.id
inner join orders o on oi.order_id = o.id
group by c.id, c.name;
-- Kullanmak için:
select * from vm_product_sales_by_category;

-- Detaylı
create view vm_product_sales_by_category_detailed as
select
    c.name as "Kategori Adı",
    count(oi.id) as "Kategori Sipariş Sayısı",
    sum(oi.quantity) as "Ürün Satış Miktarı",
    sum(oi.total_price) as "Kategori Toplam Getirisi"
    from categories c
inner join products p on c.id = p.category_id
inner join order_items oi on oi.product_id = p.id
inner join orders o on oi.order_id = o.id
group by c.id, c.name
order by "Kategori Toplam Getirisi" desc;
-- Kullanmak için:
select * from vm_product_sales_by_category_detailed;

-- 2	Müşteri sipariş özeti (toplam sipariş, toplam tutar, ortalama sepet)

create view vm_customer_order_details as
select
concat(c.name,' ',c.surname) as "Müşteri Tam Adı",
count(o.id) as "Toplam Sipariş",
sum(o.price) as "Toplam Tutar",
avg(o.price) as "Ortalama Sepet Tutarı"
from customers c
    inner join orders o on c.id = o.customer_id
group by c.name, c.surname
order by "Müşteri Tam Adı";

-- Kullanmak için
select * from vm_customer_order_details;

-- ============================================ KOMPLEKS SORGULAR ============================================
/*
 5. Kompleks Sorgular
●	En çok satan ürünler (TOP 10)
●	Kategorilere göre ortalama ürün fiyatları ve stok durumları
●	Subquery ile: Ortalama sipariş tutarından yüksek siparişler
 */
