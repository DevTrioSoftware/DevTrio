package com.example.userservice.Dto;

import com.example.userservice.Model.Enums.Status;
import lombok.Data;

@Data
public class DriverRequestDto {

    private  String licensePlate;
    private String serialNumber;
    private String email;
    private Status status;
}
