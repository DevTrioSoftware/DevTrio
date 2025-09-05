package org.example.authservice.Service;

import org.example.authservice.Component.JwtUtil;
import org.example.authservice.Component.UserClient;
import org.example.authservice.Dto.LoginDto;
import org.example.authservice.Dto.ResponseDto;
import org.example.authservice.Dto.Role;
import org.example.authservice.Dto.UserServiceResponse;
import org.example.authservice.Extensions.LogLevel;
import org.example.authservice.Extensions.Response;
import org.example.authservice.Extensions.StatusCode;
import org.example.authservice.Service.Interface.AuthService;
import org.example.authservice.Validator.Validator;
import org.springframework.stereotype.Service;

@Service
public class AuthServiceImp implements AuthService {

    private final JwtUtil jwtUtil;
    private final EventPublisherService eventPublisherService;
    private final Validator validator;
    private final UserClient userClient;
    public AuthServiceImp(JwtUtil jwtUtil,
                          EventPublisherService eventPublisherService,
                          Validator validator,
                          UserClient userClient) {
        this.jwtUtil = jwtUtil;
        this.eventPublisherService = eventPublisherService;
        this.validator = validator;
        this.userClient = userClient;
    }

    @Override
    public Response<ResponseDto> login(LoginDto loginDto) {
        Response<Boolean> validateLogin = validator.validateLogin(loginDto);
        UserServiceResponse validateLoginUserServiceResponse=userClient.userLogin(loginDto);
        if (!validateLogin.isSuccess()) {
            eventPublisherService.logEventSend("login", LogLevel.ERROR,"validation failed");
            return Response.fail(validateLogin.getMessage(), validateLogin.getStatusCode());
        }
        if (!validateLoginUserServiceResponse.isSuccess()) {
            eventPublisherService.logEventSend("login", LogLevel.ERROR,"validation failed");
            return Response.fail(validateLoginUserServiceResponse.getMessage(), validateLogin.getStatusCode());
        }
        String token = generateToken(loginDto.getEmail(),Role.Customer);//role bilgisinin dinamik olarak almanın bir yolunu bul
        ResponseDto responseDto = new ResponseDto();
        responseDto.setEmail(loginDto.getEmail());
        responseDto.setJwtToken(token);
        eventPublisherService.logEventSend("login",LogLevel.INFO,"Successfully logged in: "+responseDto.getEmail());
        return Response.success(responseDto, validateLogin.getMessage(), StatusCode.SUCCESS);
    }
    @Override
    public Response<Void> sendResetCode(String email) {
        return null;
    }

    private String generateToken(String email, Role role) {
        return jwtUtil.generateToken(email,role);
    }
}
