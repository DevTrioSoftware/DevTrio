package com.example.userservice.Model;


import com.example.userservice.Model.Enums.Status;
import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "DriverRequests")
@Data
public class DriverRequest {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private  String licensePlate;
    private String serialNumber;
    private String email;
    private Status status;
}
