package com.example.userservice.Service;

import com.example.userservice.Configuration.JacksonConfig;
import com.example.userservice.Dto.LogEvent;
import com.example.userservice.Exception.UserNotFoundException;
import com.example.userservice.Extension.StatusCode;
import com.example.userservice.Model.Enums.LogLevel;
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

    public RuntimeException logAndThrow(String service, LogLevel level, String message,RuntimeException ex) {
        LogEvent log = new LogEvent(level,Instant.now().toString(),service,message);
        send("log-topic", toJackson(log));
        throw ex;
    }

    public String toJackson(LogEvent logEvent) {
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
        send("log-topic", toJackson(log));
    }
}
