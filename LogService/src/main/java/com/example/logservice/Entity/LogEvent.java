package com.example.logservice.Entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class LogEvent {
    private String level; // INFO, ERROR, WARN
    private String timestamp;
    private String service;
    private String message;
}

