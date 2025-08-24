package com.example.userservice.Controller;

import com.example.userservice.Dto.ResetPasswordDto;
import com.example.userservice.Dto.UserLoginDto;
import com.example.userservice.Dto.UserRegisterDto;
import com.example.userservice.Dto.UserResponseDto;
import com.example.userservice.Extension.Response;
import com.example.userservice.Service.Interface.AuthService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class AuthController {
    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/register")
    public ResponseEntity<Response<UserResponseDto>> register(@RequestBody UserRegisterDto userRegisterDto) {
        Response<UserResponseDto> response = authService.register(userRegisterDto);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/login")
    public ResponseEntity<Response<UserResponseDto>> login(@RequestBody UserLoginDto userLoginDto) {
        Response<UserResponseDto> response = authService.login(userLoginDto);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/reset-password/request")
    public ResponseEntity<Response<Void>> requestResetPassword(@RequestParam String email) {
        return ResponseEntity.ok(authService.sendResetCode(email));
    }

    @PostMapping("/reset-password/confirm")
    public ResponseEntity<Response<UserResponseDto>> confirmResetPassword(@RequestBody ResetPasswordDto resetPasswordDto) {
        return ResponseEntity.ok(authService.resetPassword(resetPasswordDto));
    }

}
