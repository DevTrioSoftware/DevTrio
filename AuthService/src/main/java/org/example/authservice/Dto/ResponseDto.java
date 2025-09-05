package org.example.authservice.Dto;

import lombok.Data;

@Data
public class ResponseDto {
    private String email;
    private Role role;
    private String jwtToken;
}
