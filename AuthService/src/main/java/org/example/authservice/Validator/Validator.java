package org.example.authservice.Validator;


import org.example.authservice.Dto.LoginDto;
import org.example.authservice.Extensions.Response;
import org.example.authservice.Extensions.StatusCode;
import org.springframework.stereotype.Service;


@Service
public class Validator {


    public Response<Boolean> validateLogin(LoginDto userLoginDto) {
        if (isNullOrEmpty(userLoginDto.getEmail())) {
            return Response.fail("Email cannot be null or empty", StatusCode.BAD_REQUEST);
        }
        if (isNullOrEmpty(userLoginDto.getPassword())) {
            return Response.fail("Password cannot be null or empty", StatusCode.BAD_REQUEST);
        }
        return Response.success(Boolean.TRUE,"Login successful", StatusCode.SUCCESS);
    }
    private boolean isNullOrEmpty(String value) {
        return value == null || value.isEmpty();
    }

}
