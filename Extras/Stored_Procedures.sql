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