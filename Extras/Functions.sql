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