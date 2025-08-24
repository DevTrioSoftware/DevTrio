package com.example.userservice.Dto;

import lombok.Data;

@Data
public class ResetPasswordDto {
    String email;
    String code;
    String newPassword;
}
