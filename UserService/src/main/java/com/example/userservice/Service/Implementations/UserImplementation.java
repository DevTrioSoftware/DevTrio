package com.example.userservice.Service.Implementations;

import com.example.userservice.Dto.UserResponseDto;
import com.example.userservice.Exception.UserNotFoundException;
import com.example.userservice.Extension.Mapper;
import com.example.userservice.Extension.Response;
import com.example.userservice.Extension.StatusCode;
import com.example.userservice.Model.UserModel;
import com.example.userservice.Repository.UserRepository;
import com.example.userservice.Service.Interface.UserService;
import org.springframework.stereotype.Service;

import java.util.Optional;


@Service
public class UserImplementation implements UserService {


    private final UserRepository userRepository;
    private final Mapper mapper;

    public UserImplementation(UserRepository userRepository,Mapper mapper) {
        this.userRepository = userRepository;
        this.mapper = mapper;
    }

    @Override
    public Response<UserResponseDto> GetUserByEmail(String email) {
        if (email == null) {
            return Response.fail("Email cannot be null", StatusCode.BAD_REQUEST);
        }
        if (email.isEmpty()) {
            return Response.fail("Email cannot be empty", StatusCode.BAD_REQUEST);
        }
        UserModel user = userRepository.findByEmail(email).orElseThrow(()-> new UserNotFoundException("Kullanıcı bulunamadı",StatusCode.NOT_FOUND));


        UserResponseDto response=mapper.toUserResponseDto(user);
        return Response.success(response,"User with email "+ email +" found",StatusCode.SUCCESS);
    }

    public Response<UserResponseDto> GetUserByUsername(String username) {}
    @Override
    public Optional<UserModel> findUserByEmail(String email) {
        return userRepository.findByEmail(email);
    }

}
