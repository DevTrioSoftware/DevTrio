# TransWiseAI
# Bu dosya bilgilendirme amaçlıdır, npm install ile yüklenir!
next
react
react-dom
tailwindcss
postcss
autoprefixer
lucide-react
@headlessui/react
shadcn-ui

## Proje Yapısı

### 🚀 Ana Uygulama (FastAPI)
- **Port**: 8000
- **Teknoloji**: Python FastAPI
- **Amaç**: Rota planlama ve API servisleri

### 🔄 Balance Service (Spring Boot)
- **Port**: 8081
- **Teknoloji**: Java Spring Boot
- **Amaç**: PostgreSQL → Redis gerçek zamanlı senkronizasyon

## Kurulum ve Çalıştırma

### 1. Ana Uygulama (FastAPI)

**Sanal Ortam Oluşturun (Önerilir):**
```powershell
python -m venv venv
.\venv\Scripts\activate
```

**Gerekli Paketleri Yükleyin:**
```powershell
pip install -r requirements.txt
```

**Projeyi Başlatın:**
```powershell
uvicorn app.main:app --reload
```

**API'ye Erişim:**
- [http://127.0.0.1:8000](http://127.0.0.1:8000)
- Swagger dokümantasyonu: [http://127.0.0.1:8000/docs](http://127.0.0.1:8000/docs)

### 2. Balance Service (Spring Boot)

**Gereksinimler:**
- Java 17+
- Maven 3.6+
- PostgreSQL 12+
- Redis 6+

**PostgreSQL Kurulumu:**
```sql
CREATE DATABASE cargo_db;
psql -d cargo_db -f balance-service/src/main/resources/schema.sql
```

**PostgreSQL Konfigürasyonu (postgresql.conf):**
```conf
wal_level = logical
max_replication_slots = 10
max_wal_senders = 10
```

**Redis Başlatma:**
```bash
redis-server
```

**Balance Service Başlatma:**
```bash
cd balance-service
mvn spring-boot:run
```

**Balance Service API:**
- [http://localhost:8081/api/cargo/health](http://localhost:8081/api/cargo/health)
- [http://localhost:8081/actuator/health](http://localhost:8081/actuator/health)

## Servisler

### Ana Uygulama (FastAPI)
- `app` klasörü içinde servisler ve modeller yer almaktadır
- Google Maps API entegrasyonu
- Redis önbellekleme
- Rota planlama servisleri

### Balance Service (Spring Boot)
- PostgreSQL Change Data Capture (CDC)
- Redis gerçek zamanlı senkronizasyon
- Kargo verisi yönetimi
- REST API endpoints

## Notlar
- Hata veya eksik paket durumunda, terminaldeki hata mesajına göre requirements.txt dosyasına ekleme yapabilirsiniz
- Balance Service için PostgreSQL logical replication aktif olmalıdır
- Redis bağlantısı için gerekli ayarlar application.yml dosyasında yapılandırılabilir
