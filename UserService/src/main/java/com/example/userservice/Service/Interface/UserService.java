package com.example.userservice.Service.Interface;


import com.example.userservice.Dto.UserResponseDto;
import com.example.userservice.Extension.Response;
import com.example.userservice.Model.UserModel;

import java.util.Optional;

public interface UserService {
    Response<Optional<UserResponseDto>> GetUserByEmail(String email);
    boolean existsByEmail(String email);
    Optional<UserModel> findUserByEmail(String email);

}
