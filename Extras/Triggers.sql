-- ============================================ TRIGGER'LAR ============================================
-- TEKRAR YAP

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