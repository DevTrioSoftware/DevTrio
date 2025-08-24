package com.example.userservice.Dto;

import com.example.userservice.Model.Enums.Role;
import lombok.Data;

import java.util.UUID;

@Data
public class UserResponseDto {

    private UUID id;
    private String name;
    private String surname;
    private String email;
    private Role role;
    private String licensePlate;
    private String serialNumber;
    private String jwtToken;
}
