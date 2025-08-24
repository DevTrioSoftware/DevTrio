package com.example.userservice.Service.Implementations;

import com.example.userservice.Dto.DriverRequestDto;
import com.example.userservice.Exception.UserNotFoundException;
import com.example.userservice.Extension.Mapper;
import com.example.userservice.Extension.Response;
import com.example.userservice.Extension.StatusCode;
import com.example.userservice.Model.Enums.LogLevel;
import com.example.userservice.Model.Enums.Status;
import com.example.userservice.Repository.DriverRequestRepository;
import com.example.userservice.Service.EventPublisherService;
import com.example.userservice.Service.Interface.DriverRequestService;
import com.example.userservice.Service.Interface.UserService;
import org.springframework.stereotype.Service;

@Service
public class DriverRequestServiceImpl implements DriverRequestService {


    private final DriverRequestRepository driverRequestRepository;
    private final UserService userService;
    private final Mapper mapper;
    private final EventPublisherService eventPublisherService;

    public DriverRequestServiceImpl (DriverRequestRepository driverRequestRepository, Mapper mapper, UserService userService, EventPublisherService eventPublisherService) {
        this.driverRequestRepository = driverRequestRepository;
        this.mapper = mapper;
        this.userService = userService;
        this.eventPublisherService = eventPublisherService;
    }

    @Override
    public Response<Boolean> updateUserToDriverRequest(DriverRequestDto driverRequestDto) {
        userService.findUserByEmail(driverRequestDto.getEmail())
                .orElseThrow(()-> new UserNotFoundException("UserNot found with this mail: "+driverRequestDto.getEmail(),StatusCode.NOT_FOUND));

        driverRequestDto.setStatus(Status.PENDING);
        driverRequestRepository.save(mapper.toDriverRequest(driverRequestDto));

        eventPublisherService.logEventSend("DriverService", LogLevel.INFO,"Driver request send to admin");
        return Response.success(true,"Driver request send to admin",StatusCode.SUCCESS);

    }//adminservice tarafına bu isteği onaylayan bir method yazılacak ve geri döndürülecek cevap gene UserService üzerinden verilmeli
}
