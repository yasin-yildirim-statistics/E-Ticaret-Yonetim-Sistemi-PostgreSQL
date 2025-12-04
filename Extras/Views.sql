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