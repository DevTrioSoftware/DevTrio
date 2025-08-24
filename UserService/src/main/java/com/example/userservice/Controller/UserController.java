package com.example.userservice.Controller;

import com.example.userservice.Dto.UserResponseDto;
import com.example.userservice.Extension.Response;
import com.example.userservice.Model.UserModel;
import com.example.userservice.Service.Interface.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/users")
public class UserController {

    private final UserService userService;

    @Autowired
    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/mail")
    public ResponseEntity<Response<Optional<UserResponseDto>>> GetUserByEmail(@RequestParam String email) {
        Response<Optional<UserResponseDto>> response = userService.GetUserByEmail(email);
        return ResponseEntity.ok(response);
    }
}
