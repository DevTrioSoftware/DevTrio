package com.example.userservice.Controller;

import com.example.userservice.Dto.DriverRequestDto;
import com.example.userservice.Extension.Response;
import com.example.userservice.Extension.StatusCode;
import com.example.userservice.Service.Interface.DriverRequestService;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/requests/driverrequests")
public class DriverRequestController {


    private final DriverRequestService driverRequestService;

    public DriverRequestController(DriverRequestService driverRequestService) {
        this.driverRequestService = driverRequestService;
    }

    @PostMapping
    public Response<Boolean> createDriverRequest(@RequestBody DriverRequestDto driverRequestDto) {
        try
        {
            driverRequestService.updateUserToDriverRequest(driverRequestDto);
            return Response.success(true,"Request is send", StatusCode.SUCCESS);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
