# E-Ticaret Yönetim Sistemi (PostgreSQL) 🛒

[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-11%2B-blue?logo=postgresql)](https://www.postgresql.org/)
[![Docker](https://img.shields.io/badge/Docker-ready-blue?logo=docker)](https://www.docker.com/)
[![GitHub](https://img.shields.io/badge/GitHub-hosted-black?logo=github)](https://github.com/yasin-yildirim-statistics/E-Ticaret-Yonetim-Sistemi-PostgreSQL)
[![DrawSQL](https://img.shields.io/badge/ER%20Diagram-DrawSQL-green?logo=drawsql)](https://drawsql.app/)

## Proje Hakkında

Bu proje, **PostgreSQL** kullanılarak geliştirilmiş, e-ticaret yönetim süreçlerini kapsayan detaylı bir veritabanı yapısı sunar. Veritabanı modeli, kategorilerden ürünlere, müşterilerden siparişler ve yorumlara kadar tüm temel e-ticaret bileşenlerini kapsamaktadır. Proje kapsamında:

- **İlişkisel Veri Modeli**: ER diyagramı ve anahtar geçişlerle ürün, kategori, müşteri, sipariş, adres, yorum ilişkileri modellenmiştir.
- **Zengin SQL İçeriği**: View, Function, Trigger ve Procedure örnekleriyle veritabanı mantığı detaylandırılmıştır.
- **Docker Desteği**: Projenizi hızlıca kurup çalıştırmak için Docker ortamı hazırdır.
- **DrawSQL ile Görsel ER Diyagramı**: Tablolar arası ilişkiler DrawSQL diyagramı ile görsellenmiştir.
- **GitHub Üzerinden Sürüm Kontrolü ve Paylaşım**: Tüm kodlar ve dökümantasyon GitHub üzerinden erişilebilir ve versiyonlanmaktadır.

Detaylar ve örnek Docker kurulum adımlarına repo içinden ulaşabilirsiniz.

## DrawSQL Diyagramı

Tablolar ve ilişkiler [DrawSQL](https://drawsql.app/) ile modellenmiştir. 
Diyagramı görmek için: [Proje Linki](https://drawsql.app/teams/none-4350/diagrams/e-ticaret)

## CodeShare

Kodu görmek için: [CodeShare](https://codeshare.io/e-ticaret-portfolio)

## Kapsamda Yer Alan Tablolar

- `categories`: Kategoriler
- `products`: Ürünler
- `customers`: Müşteriler
- `orders`: Siparişler
- `order_items`: Sipariş detayları
- `shipping_addresses`: Teslimat adresleri
- `reviews`: Ürün yorumları

## İçerikte Neler Var?

- **Fonksiyonlar**: Sipariş toplam tutarı, müşteri yaşam boyu değeri, stok durumu hesaplayan fonksiyonlar
- **Trigger‘lar**: Sipariş sonrası stok güncelleme, ürün fiyat değişiminde loglama, sipariş iptalinde stok iade işlemleri
- **Stored Procedures**: Sipariş verme ve iptal etme için prosedürler
- **View‘lar**: Kategorilere göre satış istatistikleri, müşteri sipariş özetleri, ortalama sipariş üstü işlemler, en çok satanlar
- **Kompleks SQL Sorguları**: Analitik ve toplu rapor örnekleri

## Sorgulardan Örnekler

- Kategorilere göre ürün satışları ve getirileri
- Müşteri bazında toplam sipariş ve ortalama sepet tutarı
- En çok satan ürünler top10 listesi
- Ortalama sipariş tutarından yüksek siparişler
- Kategorilere göre ortalama ürün fiyat ve stok durumu

Detaylı tüm komutlar, fonksiyonlar ve prosedürler `Yasin_Yildirim_E_Ticaret_Yönetimi.sql` dosyasında açıklayıcı yorumlar ile birlikte sunulmuştur.
Her şeyi tek dosyada görmek istemeyenler için 'Extras' klasörü içinde her bir sql bileşeni için ayrı ayrı console dosyası eklenmiştir.

## Katkı ve İletişim

Pull request ve issue üzerinden öneri, düzeltme veya katkıda bulunabilirsiniz.

Her türlü soru için: 
- [GitHub profilim](https://github.com/yasin-yildirim-statistics)
- E-posta: yasinyildirim.work@gmail.com

---

**Proje çıktıları eğitim ve portfolyo amaçlıdır. Gelişmeye açıktır!**
