package com.transwise.balanceservice.repository;

import com.transwise.balanceservice.model.Cargo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface CargoRepository extends JpaRepository<Cargo, Long> {
    
    Optional<Cargo> findByTrackingNumber(String trackingNumber);
    
    List<Cargo> findByStatus(CargoStatus status);
    
    @Query("SELECT c FROM Cargo c WHERE c.updatedAt >= :since")
    List<Cargo> findUpdatedSince(@Param("since") LocalDateTime since);
    
    @Query("SELECT c FROM Cargo c WHERE c.estimatedDelivery BETWEEN :start AND :end")
    List<Cargo> findByEstimatedDeliveryBetween(@Param("start") LocalDateTime start, 
                                             @Param("end") LocalDateTime end);
    
    boolean existsByTrackingNumber(String trackingNumber);
} 