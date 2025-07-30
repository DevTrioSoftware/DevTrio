-- Cargo veritabanı ve tablo oluşturma script'i

-- Veritabanı oluştur (eğer yoksa)
-- CREATE DATABASE cargo_db;

-- Cargo tablosu
CREATE TABLE IF NOT EXISTS cargo (
    id BIGSERIAL PRIMARY KEY,
    tracking_number VARCHAR(50) UNIQUE NOT NULL,
    sender_name VARCHAR(100) NOT NULL,
    sender_address TEXT NOT NULL,
    sender_phone VARCHAR(20),
    receiver_name VARCHAR(100) NOT NULL,
    receiver_address TEXT NOT NULL,
    receiver_phone VARCHAR(20),
    weight DECIMAL(10,2),
    dimensions VARCHAR(100),
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    current_location VARCHAR(200),
    estimated_delivery TIMESTAMP,
    actual_delivery TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Index'ler
CREATE INDEX IF NOT EXISTS idx_cargo_tracking_number ON cargo(tracking_number);
CREATE INDEX IF NOT EXISTS idx_cargo_status ON cargo(status);
CREATE INDEX IF NOT EXISTS idx_cargo_created_at ON cargo(created_at);
CREATE INDEX IF NOT EXISTS idx_cargo_updated_at ON cargo(updated_at);

-- Updated_at trigger fonksiyonu
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Updated_at trigger
DROP TRIGGER IF EXISTS update_cargo_updated_at ON cargo;
CREATE TRIGGER update_cargo_updated_at
    BEFORE UPDATE ON cargo
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- PostgreSQL logical replication için gerekli ayarlar
-- postgresql.conf dosyasında şu ayarların aktif olması gerekir:
-- wal_level = logical
-- max_replication_slots = 10
-- max_wal_senders = 10

-- Debezium için publication oluştur
-- CREATE PUBLICATION cargo_publication FOR TABLE cargo;

-- Örnek veri ekleme
INSERT INTO cargo (
    tracking_number, 
    sender_name, 
    sender_address, 
    sender_phone,
    receiver_name, 
    receiver_address, 
    receiver_phone,
    weight,
    dimensions,
    status,
    current_location,
    estimated_delivery
) VALUES 
('TRK001', 'Ahmet Yılmaz', 'İstanbul, Kadıköy', '0532-123-4567', 'Mehmet Demir', 'Ankara, Çankaya', '0533-987-6543', 2.5, '30x20x15 cm', 'IN_TRANSIT', 'İstanbul Dağıtım Merkezi', '2024-01-20 14:00:00'),
('TRK002', 'Fatma Kaya', 'İzmir, Konak', '0534-111-2222', 'Ali Özkan', 'Bursa, Nilüfer', '0535-333-4444', 1.8, '25x18x12 cm', 'PENDING', 'İzmir Dağıtım Merkezi', '2024-01-21 10:00:00'),
('TRK003', 'Mustafa Çelik', 'Antalya, Muratpaşa', '0536-555-6666', 'Ayşe Yıldız', 'İstanbul, Beşiktaş', '0537-777-8888', 3.2, '35x25x20 cm', 'OUT_FOR_DELIVERY', 'İstanbul Dağıtım Merkezi', '2024-01-19 16:00:00'); 