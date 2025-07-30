package com.transwise.balanceservice.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.time.LocalDateTime;

@Entity
@Table(name = "cargo")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Cargo {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "tracking_number", unique = true, nullable = false)
    private String trackingNumber;
    
    @Column(name = "sender_name", nullable = false)
    private String senderName;
    
    @Column(name = "sender_address", nullable = false)
    private String senderAddress;
    
    @Column(name = "sender_phone")
    private String senderPhone;
    
    @Column(name = "receiver_name", nullable = false)
    private String receiverName;
    
    @Column(name = "receiver_address", nullable = false)
    private String receiverAddress;
    
    @Column(name = "receiver_phone")
    private String receiverPhone;
    
    @Column(name = "weight")
    private Double weight;
    
    @Column(name = "dimensions")
    private String dimensions;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private CargoStatus status;
    
    @Column(name = "current_location")
    private String currentLocation;
    
    @Column(name = "estimated_delivery")
    private LocalDateTime estimatedDelivery;
    
    @Column(name = "actual_delivery")
    private LocalDateTime actualDelivery;
    
    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }
    
    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
} 