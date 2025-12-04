-- ============================================ KOMPLEKS SORGULAR ============================================

-- 1. En çok satan ürünler sorgusu (TOP10):
select p.name as "Ürün Adı",
       sum(oi.quantity) as "Ürün Toplam Satış Miktarı"
from order_items oi
inner join products p on oi.product_id = p.id
group by p.name
order by "Ürün Toplam Satış Miktarı" desc limit 10;

-- 2. Kategorilere göre ortalama ürün fiyatları ve stok durumları
select
    c.name as "Kategori Adı",
    round(AVG(P.price)) as "Ortalama Ürün Fiyatı", -- virgülden sonraki sayılardan kurtulmak için
    round(avg(p.stock)) as "Ortalama Stok Durumu"  -- round özelliğini kullanıyorum
    from categories c
inner join products p on c.id = p.category_id
group by c.name
order by c.name;

-- 3. Subquery ile: Ortalama sipariş tutarından yüksek siparişler
-- Yapılacak subquery = select avg(price) from orders; 6856.12
select
o.id AS "Sipariş ID",
concat(c.name,' ',c.surname) as "Müşteri Tam Adı",
o.price AS "Toplam Sipariş Fiyatı"
from orders o
inner join customers c on c.id = o.customer_id
where o.price > (select avg(price) from orders) -- "o.price >" dan sonra ortalama sipariş tutarını veren query yazılır.
order by o.price desc;

 -- En yüksek tutarlı siparişten sıralandı