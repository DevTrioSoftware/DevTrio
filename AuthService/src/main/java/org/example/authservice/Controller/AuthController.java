package org.example.authservice.Controller;

import org.example.authservice.Dto.LoginDto;
import org.example.authservice.Extensions.Response;
import org.example.authservice.Service.Interface.AuthService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/auth")
public class AuthController {

    private final AuthService authService;
    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/login")
    public ResponseEntity<Response<Boolean>> login(LoginDto  loginDto) {
        authService.login(loginDto);
        return new ResponseEntity<>(Response.loginSuccess(true), HttpStatus.OK);
    }
}
