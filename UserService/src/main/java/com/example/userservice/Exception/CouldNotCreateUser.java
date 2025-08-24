package com.example.userservice.Exception;

import com.example.userservice.Extension.StatusCode;
import lombok.Getter;

@Getter
public class CouldNotCreateUser extends RuntimeException {
    private final StatusCode statusCode;

    public CouldNotCreateUser(String message, StatusCode statusCode) {
        super(message);
        this.statusCode=statusCode;
    }
}
