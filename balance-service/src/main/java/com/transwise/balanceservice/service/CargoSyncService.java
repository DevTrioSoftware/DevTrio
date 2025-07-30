package com.transwise.balanceservice.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.transwise.balanceservice.model.Cargo;
import com.transwise.balanceservice.model.CargoStatus;
import com.transwise.balanceservice.repository.CargoRepository;
import io.debezium.config.Configuration;
import io.debezium.embedded.EmbeddedEngine;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.kafka.connect.data.Field;
import org.apache.kafka.connect.data.Schema;
import org.apache.kafka.connect.data.Struct;
import org.apache.kafka.connect.source.SourceRecord;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import javax.annotation.PreDestroy;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

@Service
@RequiredArgsConstructor
@Slf4j
public class CargoSyncService {
    
    private final Configuration debeziumConfig;
    private final CargoRepository cargoRepository;
    private final RedisService redisService;
    private final ObjectMapper objectMapper;
    
    private EmbeddedEngine engine;
    private ExecutorService executor;
    
    @EventListener(ApplicationReadyEvent.class)
    public void startSync() {
        log.info("Cargo Sync Service başlatılıyor...");
        
        // İlk senkronizasyon - tüm mevcut verileri Redis'e yükle
        performInitialSync();
        
        // CDC engine'ini başlat
        startDebeziumEngine();
    }
    
    @Async
    public void performInitialSync() {
        try {
            log.info("İlk senkronizasyon başlatılıyor...");
            
            // Tüm kargo verilerini PostgreSQL'den al
            var allCargos = cargoRepository.findAll();
            
            // Redis'i temizle
            redisService.clearAllCargos();
            
            // Tüm verileri Redis'e yükle
            for (Cargo cargo : allCargos) {
                redisService.saveCargo(cargo);
            }
            
            log.info("İlk senkronizasyon tamamlandı. {} kargo verisi Redis'e yüklendi.", allCargos.size());
            
        } catch (Exception e) {
            log.error("İlk senkronizasyon hatası: {}", e.getMessage(), e);
        }
    }
    
    private void startDebeziumEngine() {
        engine = EmbeddedEngine.create()
                .using(debeziumConfig)
                .notifying(this::handleChangeEvent)
                .build();
        
        executor = Executors.newSingleThreadExecutor();
        executor.execute(engine);
        
        log.info("Debezium CDC Engine başlatıldı");
    }
    
    private void handleChangeEvent(SourceRecord sourceRecord) {
        try {
            Struct source = (Struct) sourceRecord.value();
            if (source == null) {
                return; // Tombstone event
            }
            
            Struct after = source.getStruct("after");
            Struct before = source.getStruct("before");
            String operation = source.getString("op");
            
            if (after != null) {
                Cargo cargo = convertStructToCargo(after);
                
                switch (operation) {
                    case "c" -> { // Create
                        log.info("Yeni kargo oluşturuldu: ID={}, Tracking={}", 
                                cargo.getId(), cargo.getTrackingNumber());
                        redisService.saveCargo(cargo);
                    }
                    case "u" -> { // Update
                        log.info("Kargo güncellendi: ID={}, Tracking={}", 
                                cargo.getId(), cargo.getTrackingNumber());
                        redisService.updateCargo(cargo);
                    }
                    case "d" -> { // Delete
                        if (before != null) {
                            Cargo deletedCargo = convertStructToCargo(before);
                            log.info("Kargo silindi: ID={}, Tracking={}", 
                                    deletedCargo.getId(), deletedCargo.getTrackingNumber());
                            redisService.deleteCargo(deletedCargo.getId());
                        }
                    }
                }
            }
            
        } catch (Exception e) {
            log.error("Change event işleme hatası: {}", e.getMessage(), e);
        }
    }
    
    private Cargo convertStructToCargo(Struct struct) {
        Cargo cargo = new Cargo();
        
        cargo.setId(getLongValue(struct, "id"));
        cargo.setTrackingNumber(getStringValue(struct, "tracking_number"));
        cargo.setSenderName(getStringValue(struct, "sender_name"));
        cargo.setSenderAddress(getStringValue(struct, "sender_address"));
        cargo.setSenderPhone(getStringValue(struct, "sender_phone"));
        cargo.setReceiverName(getStringValue(struct, "receiver_name"));
        cargo.setReceiverAddress(getStringValue(struct, "receiver_address"));
        cargo.setReceiverPhone(getStringValue(struct, "receiver_phone"));
        cargo.setWeight(getDoubleValue(struct, "weight"));
        cargo.setDimensions(getStringValue(struct, "dimensions"));
        cargo.setStatus(CargoStatus.valueOf(getStringValue(struct, "status")));
        cargo.setCurrentLocation(getStringValue(struct, "current_location"));
        cargo.setEstimatedDelivery(parseDateTime(getStringValue(struct, "estimated_delivery")));
        cargo.setActualDelivery(parseDateTime(getStringValue(struct, "actual_delivery")));
        cargo.setCreatedAt(parseDateTime(getStringValue(struct, "created_at")));
        cargo.setUpdatedAt(parseDateTime(getStringValue(struct, "updated_at")));
        
        return cargo;
    }
    
    private String getStringValue(Struct struct, String fieldName) {
        try {
            Object value = struct.get(fieldName);
            return value != null ? value.toString() : null;
        } catch (Exception e) {
            return null;
        }
    }
    
    private Long getLongValue(Struct struct, String fieldName) {
        try {
            Object value = struct.get(fieldName);
            return value != null ? Long.valueOf(value.toString()) : null;
        } catch (Exception e) {
            return null;
        }
    }
    
    private Double getDoubleValue(Struct struct, String fieldName) {
        try {
            Object value = struct.get(fieldName);
            return value != null ? Double.valueOf(value.toString()) : null;
        } catch (Exception e) {
            return null;
        }
    }
    
    private LocalDateTime parseDateTime(String dateTimeStr) {
        if (dateTimeStr == null || dateTimeStr.isEmpty()) {
            return null;
        }
        
        try {
            // PostgreSQL timestamp format: 2024-01-15 10:30:00
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            return LocalDateTime.parse(dateTimeStr, formatter);
        } catch (Exception e) {
            log.warn("Tarih parse hatası: {}", dateTimeStr);
            return null;
        }
    }
    
    @PreDestroy
    public void stopSync() {
        if (engine != null) {
            engine.stop();
            log.info("Debezium CDC Engine durduruldu");
        }
        
        if (executor != null) {
            executor.shutdown();
            log.info("Sync executor kapatıldı");
        }
    }
    
    // Manuel senkronizasyon için endpoint
    public void manualSync() {
        log.info("Manuel senkronizasyon başlatılıyor...");
        performInitialSync();
    }
} 