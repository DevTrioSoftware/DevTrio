package com.example.userservice.Exception;

import com.example.userservice.Extension.StatusCode;
import lombok.Getter;

@Getter
public class UserNotFoundException extends RuntimeException {

    private final StatusCode errorCode;
    public UserNotFoundException(String message,StatusCode errorCode) {
        super(message);
        this.errorCode = errorCode;
    }

}
