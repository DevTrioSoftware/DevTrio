package com.example.userservice.Service.Implementations;

import com.example.userservice.Dto.UserResponseDto;
import com.example.userservice.Exception.UserNotFoundException;
import com.example.userservice.Extension.Mapper;
import com.example.userservice.Extension.Response;
import com.example.userservice.Extension.StatusCode;
import com.example.userservice.Model.UserModel;
import com.example.userservice.Repository.UserRepository;
import com.example.userservice.Service.Interface.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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
    public Response<Optional<UserResponseDto>> GetUserByEmail(String email) {
        if (email == null) {
            return Response.fail("Email cannot be null", StatusCode.BAD_REQUEST);
        }
        if (email.isEmpty()) {
            return Response.fail("Email cannot be empty", StatusCode.BAD_REQUEST);
        }
        Optional<UserModel> user = userRepository.findByEmail(email);
        if (user.isEmpty()) {
            throw  new UserNotFoundException("User not found", StatusCode.NOT_FOUND);
        }

        UserResponseDto response=mapper.toUserResponseDto(user.get());
        return Response.success(Optional.of(response),"User with email "+ email +" found",StatusCode.SUCCESS);
    }

    @Override
    public boolean existsByEmail(String email) {
        return userRepository.existsByEmail(email);
    }

    @Override
    public Optional<UserModel> findUserByEmail(String email) {
        return userRepository.findByEmail(email);
    }

}
