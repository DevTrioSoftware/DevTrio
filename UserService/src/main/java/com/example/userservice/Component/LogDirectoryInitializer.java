package com.example.userservice.Component;

import jakarta.annotation.PostConstruct;
import org.springframework.stereotype.Component;

import java.io.File;

@Component
public class LogDirectoryInitializer {

    private static final String LOG_DIR = "logs";

    @PostConstruct
    public void createLogDirectory() {
        File logDir = new File(LOG_DIR);
        if (!logDir.exists()) {
            boolean created = logDir.mkdirs();
            if (created) {
                System.out.println("📁 'logs/' klasörü oluşturuldu.");
            } else {
                System.err.println("❌ 'logs/' klasörü oluşturulamadı.");
            }
        }
    }
}
