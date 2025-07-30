# Balance Service

PostgreSQL'den Redis'e gerçek zamanlı kargo verisi senkronizasyonu sağlayan Spring Boot uygulaması.

## 🚀 Özellikler

- **Change Data Capture (CDC)**: Debezium ile PostgreSQL değişikliklerini gerçek zamanlı izleme
- **Redis Senkronizasyonu**: PostgreSQL değişikliklerini anında Redis'e yansıtma
- **Yüksek Performans**: Redis üzerinden hızlı veri erişimi
- **Manuel Senkronizasyon**: Gerektiğinde manuel senkronizasyon imkanı
- **REST API**: Kargo verilerine HTTP API üzerinden erişim

## 🛠️ Teknolojiler

- **Spring Boot 3.2.0**
- **Java 17**
- **PostgreSQL** (Ana veritabanı)
- **Redis** (Önbellek ve hızlı erişim)
- **Debezium** (Change Data Capture)
- **Maven** (Dependency Management)

## 📋 Gereksinimler

- Java 17+
- Maven 3.6+
- PostgreSQL 12+
- Redis 6+

## 🔧 Kurulum

### 1. PostgreSQL Kurulumu

```sql
-- Veritabanı oluştur
CREATE DATABASE cargo_db;

-- Schema.sql dosyasını çalıştır
psql -d cargo_db -f src/main/resources/schema.sql
```

### 2. PostgreSQL Konfigürasyonu

`postgresql.conf` dosyasında şu ayarları aktif edin:

```conf
wal_level = logical
max_replication_slots = 10
max_wal_senders = 10
```

### 3. Redis Kurulumu

```bash
# Redis'i başlat
redis-server
```

### 4. Uygulama Konfigürasyonu

`application.yml` dosyasında veritabanı bağlantı bilgilerini güncelleyin:

```yaml
spring:
  datasource:
    url: jdbc:postgresql://localhost:5432/cargo_db
    username: your_username
    password: your_password
  data:
    redis:
      host: localhost
      port: 6379
```

### 5. Uygulamayı Başlat

```bash
# Maven ile derle ve çalıştır
mvn spring-boot:run
```

## 📡 API Endpoints

### Kargo Verileri

- `GET /api/cargo/{id}` - ID ile kargo getir
- `GET /api/cargo/tracking/{trackingNumber}` - Tracking number ile kargo getir
- `GET /api/cargo/status/{status}` - Duruma göre kargoları getir
- `GET /api/cargo/all` - Tüm kargoları getir

### Senkronizasyon

- `POST /api/cargo/sync` - Manuel senkronizasyon başlat
- `GET /api/cargo/health` - Servis durumu kontrolü

## 🔄 Senkronizasyon Süreci

1. **İlk Senkronizasyon**: Uygulama başlatıldığında tüm PostgreSQL verileri Redis'e yüklenir
2. **Gerçek Zamanlı İzleme**: Debezium CDC ile PostgreSQL değişiklikleri izlenir
3. **Otomatik Senkronizasyon**: Değişiklikler anında Redis'e yansıtılır

### Desteklenen İşlemler

- ✅ **INSERT**: Yeni kargo oluşturma
- ✅ **UPDATE**: Kargo güncelleme
- ✅ **DELETE**: Kargo silme

## 📊 Redis Veri Yapısı

```
cargo:{id} -> Kargo JSON verisi
tracking:{trackingNumber} -> Tracking number ile kargo
status:{status} -> Duruma göre kargo ID'leri
cargo:all -> Tüm kargo ID'leri
```

## 🐛 Sorun Giderme

### PostgreSQL CDC Sorunları

1. **Logical Replication Aktif Değil**:
   ```sql
   SHOW wal_level; -- logical olmalı
   ```

2. **Publication Eksik**:
   ```sql
   CREATE PUBLICATION cargo_publication FOR TABLE cargo;
   ```

3. **Replication Slot Sorunu**:
   ```sql
   SELECT * FROM pg_replication_slots;
   ```

### Redis Bağlantı Sorunları

1. **Redis Çalışmıyor**:
   ```bash
   redis-cli ping # PONG döndürmeli
   ```

2. **Bağlantı Ayarları**:
   ```yaml
   spring:
     data:
       redis:
         host: localhost
         port: 6379
         timeout: 2000ms
   ```

## 📈 Monitoring

### Health Check
```bash
curl http://localhost:8081/api/cargo/health
```

### Actuator Endpoints
- `http://localhost:8081/actuator/health`
- `http://localhost:8081/actuator/metrics`
- `http://localhost:8081/actuator/info`

## 🔒 Güvenlik

- Production ortamında güvenli veritabanı bağlantıları kullanın
- Redis authentication aktif edin
- Firewall kurallarını yapılandırın

## 📝 Loglar

Uygulama logları şu seviyelerde tutulur:
- **DEBUG**: Detaylı senkronizasyon bilgileri
- **INFO**: Genel işlem bilgileri
- **ERROR**: Hata durumları

## 🤝 Katkıda Bulunma

1. Fork yapın
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Commit yapın (`git commit -m 'Add amazing feature'`)
4. Push yapın (`git push origin feature/amazing-feature`)
5. Pull Request oluşturun 