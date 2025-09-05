package com.example.userservice.Extension;

import com.example.userservice.Dto.DriverRequestDto;
import com.example.userservice.Dto.UserResponseDto;
import com.example.userservice.Model.DriverRequest;
import com.example.userservice.Model.UserModel;
import org.springframework.stereotype.Component;

@Component
public class Mapper {

    public UserResponseDto toUserResponseDto(UserModel userModel) {
        UserResponseDto userResponseDto = new UserResponseDto();
        userResponseDto.setId(userModel.getId());
        userResponseDto.setEmail(userModel.getEmail());
        userResponseDto.setName(userModel.getName());
        userResponseDto.setSurname(userModel.getSurname());
        userResponseDto.setRole(userModel.getRole());
        return userResponseDto;
    }
    

    public DriverRequest toDriverRequest(DriverRequestDto dto) {
        DriverRequest driverRequest = new DriverRequest();
        driverRequest.setEmail(dto.getEmail());
        driverRequest.setLicensePlate(dto.getLicensePlate());
        driverRequest.setSerialNumber(dto.getSerialNumber());
        driverRequest.setStatus(dto.getStatus());

        return driverRequest;
    }
}
