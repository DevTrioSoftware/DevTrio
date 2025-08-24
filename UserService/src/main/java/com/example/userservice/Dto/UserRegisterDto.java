package com.example.userservice.Dto;

import com.example.userservice.Model.Enums.Role;
import lombok.Data;

@Data
public class UserRegisterDto {

    private String name;
    private String surname;
    private String email;
    private String password;
    private String confirmPassword;
    private Role role;
    private String licensePlate;
    private String serialNumber;
}
