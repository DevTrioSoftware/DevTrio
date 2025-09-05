package org.example.authservice.Service;

import org.example.authservice.Configuration.JacksonConfig;
import org.example.authservice.Dto.LogEvent;
import org.example.authservice.Extensions.LogLevel;
import com.fasterxml.jackson.core.JsonProcessingException;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;

import java.time.Instant;

@Service
public class EventPublisherService {
    private final KafkaTemplate<?, String> kafkaTemplate;
    private final JacksonConfig jacksonConfig;
    public EventPublisherService(KafkaTemplate<?, String> kafkaTemplate, JacksonConfig jacksonConfig)
    {
        this.kafkaTemplate = kafkaTemplate;
        this.jacksonConfig = jacksonConfig;
    }

    public void send(String topic, String message) {
        kafkaTemplate.send(topic, message);
    }

    public String logeventToJackson(LogEvent logEvent) {
        try
        {
            return jacksonConfig.objectMapper().writeValueAsString(logEvent);
        }catch (JsonProcessingException e)
        {
            return "{\"level\":\"ERROR\",\"timestamp\":\""+Instant.now()+"\",\"service\":\"EventPublisher\",\"message\":\"Failed to convert log to JSON\"}";
        }
    }

    public void logEventSend(String service, LogLevel level, String message) {
        LogEvent log = new LogEvent(level, Instant.now().toString(), service, message);
        send("log-topic", logeventToJackson(log));
    }
}
