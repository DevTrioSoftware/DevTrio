package org.example.authservice.Service.Interface;

import org.example.authservice.Dto.LoginDto;
import org.example.authservice.Dto.ResponseDto;
import org.example.authservice.Extensions.Response;

public interface AuthService {
    Response<ResponseDto> login(LoginDto loginDto);
    Response<Void> sendResetCode(String email);

}
