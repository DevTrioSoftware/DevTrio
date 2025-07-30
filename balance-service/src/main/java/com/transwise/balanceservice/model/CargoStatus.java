package com.transwise.balanceservice.model;

public enum CargoStatus {
    PENDING("Beklemede"),
    PICKED_UP("Alındı"),
    IN_TRANSIT("Yolda"),
    OUT_FOR_DELIVERY("Dağıtımda"),
    DELIVERED("Teslim Edildi"),
    FAILED_DELIVERY("Teslim Başarısız"),
    RETURNED("İade Edildi"),
    CANCELLED("İptal Edildi");
    
    private final String displayName;
    
    CargoStatus(String displayName) {
        this.displayName = displayName;
    }
    
    public String getDisplayName() {
        return displayName;
    }
} 