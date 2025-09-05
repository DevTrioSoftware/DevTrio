package org.example.authservice.Dto;

import org.example.authservice.Extensions.LogLevel;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class LogEvent {
    private LogLevel level;
    private String timestamp;
    private String message;
    private String service;
}

