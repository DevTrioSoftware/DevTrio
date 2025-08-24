package com.example.userservice.Service.Interface;

import com.example.userservice.Dto.DriverRequestDto;
import com.example.userservice.Extension.Response;

public interface DriverRequestService {

    Response<Boolean> updateUserToDriverRequest(DriverRequestDto driverRequestDto);

}
