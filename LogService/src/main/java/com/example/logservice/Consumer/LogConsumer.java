package com.example.logservice.Consumer;

import com.example.logservice.Entity.LogEvent;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

@Component
@Slf4j
public class LogConsumer {

    private ObjectMapper objectMapper;
    public LogConsumer(ObjectMapper objectMapper) {
        this.objectMapper = objectMapper;
    }
    @KafkaListener(topics = "log-topic")
    public void consume(String json) {
        try {
            LogEvent event =  objectMapper.readValue(json, LogEvent.class);

            String logMessage = String.format("%s | %s | %s | %s",
                    event.getTimestamp(), event.getLevel(), event.getService(), event.getMessage());

            switch (event.getLevel()) {
                case "ERROR":
                    log.error(logMessage);
                    break;
                case "INFO":
                    log.info(logMessage);
                    break;
                case "WARN":
                    log.warn(logMessage);
                    break;
                default:
                    log.debug(logMessage);
                    break;
            }
        } catch (JsonProcessingException e) {
            log.error("❌ JSON parse hatası: {}", e.getMessage(), e);
        }
    }


}
