package com.example.userservice.Service.Interface;

import com.example.userservice.Dto.ResetPasswordDto;
import com.example.userservice.Dto.UserLoginDto;
import com.example.userservice.Dto.UserRegisterDto;
import com.example.userservice.Dto.UserResponseDto;
import com.example.userservice.Extension.Response;

public interface AuthService {

    Response<UserResponseDto> login(UserLoginDto userLoginDto);
    Response<UserResponseDto> register(UserRegisterDto userRegisterDto);
    Response<Void> sendResetCode(String email);
    Response<UserResponseDto> resetPassword(ResetPasswordDto resetPasswordDto);
}
