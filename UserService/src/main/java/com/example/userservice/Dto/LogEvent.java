package com.example.userservice.Dto;

import com.example.userservice.Model.Enums.LogLevel;
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
