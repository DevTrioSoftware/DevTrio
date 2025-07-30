package com.transwise.balanceservice.controller;

import com.transwise.balanceservice.model.Cargo;
import com.transwise.balanceservice.service.CargoSyncService;
import com.transwise.balanceservice.service.RedisService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/cargo")
@RequiredArgsConstructor
@Slf4j
public class CargoController {
    
    private final RedisService redisService;
    private final CargoSyncService cargoSyncService;
    
    @GetMapping("/{id}")
    public ResponseEntity<Cargo> getCargoById(@PathVariable Long id) {
        Optional<Cargo> cargo = redisService.getCargoById(id);
        return cargo.map(ResponseEntity::ok)
                   .orElse(ResponseEntity.notFound().build());
    }
    
    @GetMapping("/tracking/{trackingNumber}")
    public ResponseEntity<Cargo> getCargoByTrackingNumber(@PathVariable String trackingNumber) {
        Optional<Cargo> cargo = redisService.getCargoByTrackingNumber(trackingNumber);
        return cargo.map(ResponseEntity::ok)
                   .orElse(ResponseEntity.notFound().build());
    }
    
    @GetMapping("/status/{status}")
    public ResponseEntity<List<Cargo>> getCargosByStatus(@PathVariable String status) {
        List<Cargo> cargos = redisService.getCargosByStatus(status);
        return ResponseEntity.ok(cargos);
    }
    
    @GetMapping("/all")
    public ResponseEntity<List<Cargo>> getAllCargos() {
        List<Cargo> cargos = redisService.getAllCargos();
        return ResponseEntity.ok(cargos);
    }
    
    @PostMapping("/sync")
    public ResponseEntity<String> manualSync() {
        try {
            cargoSyncService.manualSync();
            return ResponseEntity.ok("Manuel senkronizasyon başlatıldı");
        } catch (Exception e) {
            log.error("Manuel senkronizasyon hatası: {}", e.getMessage());
            return ResponseEntity.internalServerError()
                    .body("Senkronizasyon hatası: " + e.getMessage());
        }
    }
    
    @GetMapping("/health")
    public ResponseEntity<String> healthCheck() {
        return ResponseEntity.ok("Balance Service çalışıyor");
    }
} 