package com.transwise.balanceservice.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.transwise.balanceservice.model.Cargo;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.util.List;
import java.util.Optional;
import java.util.Set;

@Service
@RequiredArgsConstructor
@Slf4j
public class RedisService {
    
    private final RedisTemplate<String, Object> redisTemplate;
    private final ObjectMapper objectMapper;
    
    private static final String CARGO_KEY_PREFIX = "cargo:";
    private static final String CARGO_TRACKING_PREFIX = "tracking:";
    private static final String CARGO_STATUS_PREFIX = "status:";
    private static final String CARGO_ALL_KEY = "cargo:all";
    private static final Duration DEFAULT_TTL = Duration.ofHours(24);
    
    public void saveCargo(Cargo cargo) {
        try {
            String cargoJson = objectMapper.writeValueAsString(cargo);
            String cargoKey = CARGO_KEY_PREFIX + cargo.getId();
            String trackingKey = CARGO_TRACKING_PREFIX + cargo.getTrackingNumber();
            String statusKey = CARGO_STATUS_PREFIX + cargo.getStatus().name();
            
            // Ana kargo verisi
            redisTemplate.opsForValue().set(cargoKey, cargoJson, DEFAULT_TTL);
            
            // Tracking number ile hızlı erişim
            redisTemplate.opsForValue().set(trackingKey, cargoJson, DEFAULT_TTL);
            
            // Status bazlı index
            redisTemplate.opsForSet().add(statusKey, cargo.getId().toString());
            redisTemplate.expire(statusKey, DEFAULT_TTL);
            
            // Tüm kargolar listesi
            redisTemplate.opsForSet().add(CARGO_ALL_KEY, cargo.getId().toString());
            redisTemplate.expire(CARGO_ALL_KEY, DEFAULT_TTL);
            
            log.info("Kargo Redis'e kaydedildi: ID={}, Tracking={}", cargo.getId(), cargo.getTrackingNumber());
            
        } catch (JsonProcessingException e) {
            log.error("Kargo JSON serileştirme hatası: {}", e.getMessage());
        }
    }
    
    public void updateCargo(Cargo cargo) {
        saveCargo(cargo); // Update işlemi de aynı save işlemi gibi
        log.info("Kargo Redis'te güncellendi: ID={}", cargo.getId());
    }
    
    public void deleteCargo(Long cargoId) {
        String cargoKey = CARGO_KEY_PREFIX + cargoId;
        redisTemplate.delete(cargoKey);
        
        // Tracking number ve status indexlerini de temizle
        // Bu işlem için önce cargo verisini alıp sonra silmek gerekir
        Optional<Cargo> cargo = getCargoById(cargoId);
        if (cargo.isPresent()) {
            String trackingKey = CARGO_TRACKING_PREFIX + cargo.get().getTrackingNumber();
            String statusKey = CARGO_STATUS_PREFIX + cargo.get().getStatus().name();
            
            redisTemplate.delete(trackingKey);
            redisTemplate.opsForSet().remove(statusKey, cargoId.toString());
            redisTemplate.opsForSet().remove(CARGO_ALL_KEY, cargoId.toString());
        }
        
        log.info("Kargo Redis'ten silindi: ID={}", cargoId);
    }
    
    public Optional<Cargo> getCargoById(Long cargoId) {
        String key = CARGO_KEY_PREFIX + cargoId;
        return getCargoFromRedis(key);
    }
    
    public Optional<Cargo> getCargoByTrackingNumber(String trackingNumber) {
        String key = CARGO_TRACKING_PREFIX + trackingNumber;
        return getCargoFromRedis(key);
    }
    
    public List<Cargo> getCargosByStatus(String status) {
        String statusKey = CARGO_STATUS_PREFIX + status;
        Set<Object> cargoIds = redisTemplate.opsForSet().members(statusKey);
        
        return cargoIds.stream()
                .map(id -> getCargoById(Long.valueOf(id.toString())))
                .filter(Optional::isPresent)
                .map(Optional::get)
                .toList();
    }
    
    public List<Cargo> getAllCargos() {
        Set<Object> cargoIds = redisTemplate.opsForSet().members(CARGO_ALL_KEY);
        
        return cargoIds.stream()
                .map(id -> getCargoById(Long.valueOf(id.toString())))
                .filter(Optional::isPresent)
                .map(Optional::get)
                .toList();
    }
    
    private Optional<Cargo> getCargoFromRedis(String key) {
        Object value = redisTemplate.opsForValue().get(key);
        if (value == null) {
            return Optional.empty();
        }
        
        try {
            Cargo cargo = objectMapper.readValue(value.toString(), Cargo.class);
            return Optional.of(cargo);
        } catch (JsonProcessingException e) {
            log.error("Redis'ten kargo verisi parse hatası: {}", e.getMessage());
            return Optional.empty();
        }
    }
    
    public void clearAllCargos() {
        Set<String> keys = redisTemplate.keys(CARGO_KEY_PREFIX + "*");
        if (keys != null && !keys.isEmpty()) {
            redisTemplate.delete(keys);
        }
        
        Set<String> trackingKeys = redisTemplate.keys(CARGO_TRACKING_PREFIX + "*");
        if (trackingKeys != null && !trackingKeys.isEmpty()) {
            redisTemplate.delete(trackingKeys);
        }
        
        Set<String> statusKeys = redisTemplate.keys(CARGO_STATUS_PREFIX + "*");
        if (statusKeys != null && !statusKeys.isEmpty()) {
            redisTemplate.delete(statusKeys);
        }
        
        redisTemplate.delete(CARGO_ALL_KEY);
        log.info("Tüm kargo verileri Redis'ten temizlendi");
    }
} 