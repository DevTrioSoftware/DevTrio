package com.example.userservice.Service.Implementations;

import com.example.userservice.Component.JwtUtil;
import com.example.userservice.Dto.*;
import com.example.userservice.Exception.CouldNotCreateUser;
import com.example.userservice.Exception.UserNotFoundException;
import com.example.userservice.Extension.Mapper;
import com.example.userservice.Extension.Response;
import com.example.userservice.Extension.StatusCode;
import com.example.userservice.Model.Enums.LogLevel;
import com.example.userservice.Model.UserModel;
import com.example.userservice.Repository.UserRepository;
import com.example.userservice.Service.EmailService;
import com.example.userservice.Service.EventPublisherService;
import com.example.userservice.Service.Interface.AuthService;
import com.example.userservice.Service.RedisService;
import com.example.userservice.Validator.UserValidator;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import java.util.concurrent.TimeUnit;


@Service
public class AuthServiceImpl implements AuthService {

    private final UserRepository userRepository;
    private final Mapper mapper;
    private final JwtUtil jwtUtil;
    private final PasswordEncoder passwordEncoder;
    private final EmailService emailService;
    private final UserValidator userValidator;
    private final RedisService redisService;

    private final EventPublisherService eventPublisherService;



    public AuthServiceImpl(UserRepository userRepository, Mapper mapper, JwtUtil jwtUtil, PasswordEncoder passwordEncoder, EmailService emailService, UserValidator userValidator, RedisService redisService, EventPublisherService eventPublisherService) {
        this.userRepository = userRepository;
        this.mapper = mapper;
        this.jwtUtil = jwtUtil;
        this.passwordEncoder = passwordEncoder;
        this.emailService = emailService;
        this.userValidator = userValidator;
        this.redisService = redisService;
        this.eventPublisherService = eventPublisherService;
    }

    @Override
    public Response<UserResponseDto> login(UserLoginDto userLoginDto) {
        Response<UserModel> validateLogin = userValidator.validateLogin(userLoginDto);
        if (!validateLogin.isSuccess()) {
            eventPublisherService.logEventSend("login", LogLevel.ERROR,"validation failed");
            return Response.fail(validateLogin.getMessage(), validateLogin.getStatusCode());
        }
        UserModel userModel = validateLogin.getData();

        String token = generateToken(userModel.getEmail());
        UserResponseDto userResponseDto = mapper.toUserResponseDto(userModel);
        userResponseDto.setJwtToken(token);

        eventPublisherService.logEventSend("login",LogLevel.INFO,"Successfully logged in: "+userResponseDto.getId());
        return Response.success(userResponseDto, validateLogin.getMessage(), StatusCode.SUCCESS);
    }

    @Override
    public Response<UserResponseDto> register(UserRegisterDto userRegisterDto) {
        Response<Void> validationResult = userValidator.validateRegister(userRegisterDto);
        if (!validationResult.isSuccess()) {
            eventPublisherService.logEventSend("register",LogLevel.ERROR,"validation failed");
            return Response.fail(validationResult.getMessage(), validationResult.getStatusCode());
        }
        return saveUserMethod(userRegisterDto);
    }

    @Override
    public Response<Void> sendResetCode(String email) {

        if (!userRepository.existsByEmail(email)) {
            throw eventPublisherService.logAndThrow(
                    "log-topic",
                    LogLevel.ERROR,
                    "Kullanıcı bu mail ile bulunamadı: "+email,
                    new UserNotFoundException("Kullanıcı bu mail ile bulunamadı: "+email,StatusCode.NOT_FOUND));
        }

        String resetCode = emailService.generate();
        String key = "resetCode:" + email;
        redisService.setValue(key, resetCode, 10, TimeUnit.MINUTES);

        emailService.sendResetPasswordMail(email, "Şifre sıfırlama kodu", resetCode);
        eventPublisherService.logEventSend("sendResetCode",LogLevel.INFO,"Successfully sent reset code mail: "+email);
        return Response.success();
    }


    @Override
    public Response<UserResponseDto> resetPassword(ResetPasswordDto resetPasswordDto) {
        String key = "resetCode:" + resetPasswordDto.getEmail();
        String storedCode = redisService.getValue(key);

        if (storedCode != null && storedCode.equals(resetPasswordDto.getCode())) {
            UserModel user = userRepository.findByEmail(resetPasswordDto.getEmail())
                    .orElseThrow(() -> new UserNotFoundException("User not found", StatusCode.NOT_FOUND));

            String hashedPassword = passwordEncoder.encode(resetPasswordDto.getNewPassword());
            user.setPassword(hashedPassword);
            userRepository.save(user);
            UserResponseDto userResponseDto = mapper.toUserResponseDto(user);
            redisService.deleteKey(key);

            eventPublisherService.logEventSend("resetPassword",LogLevel.INFO,"Successfully reset password: "+userResponseDto.getId());

            return Response.success(userResponseDto, "Password reset successfully", StatusCode.SUCCESS);
        } else {
            eventPublisherService.logEventSend("resetPassword",LogLevel.ERROR,"Reset password failed");
            return Response.fail("Password reset failed. Code mismatch or expired.", StatusCode.BAD_REQUEST);
        }
    }


    private Response<UserResponseDto> saveUserMethod(UserRegisterDto userRegisterDto) {
        try {
            String token = generateToken(userRegisterDto.getEmail());

            userRegisterDto.setPassword(passwordEncoder.encode(userRegisterDto.getPassword()));

            UserModel userModel = mapper.toUserModel(userRegisterDto);
            userRepository.save(userModel);

            UserResponseDto userResponseDto = mapper.toUserResponseDto(userModel);
            userResponseDto.setJwtToken(token);

            eventPublisherService.logEventSend("register",LogLevel.INFO,"Kullanıcı bu mail ile başarılı bir şekilde oluşturuldu: "+userResponseDto.getEmail());
            emailService.sendHtmlMailWithImage(userResponseDto.getEmail(), "Kaydınız başarı ile oluşturulmuştur", userResponseDto.getName());

            return Response.success(userResponseDto, "Kayıt basarili", StatusCode.CREATED);
        } catch (Exception ex) {
            throw eventPublisherService.logAndThrow(
                    "register",
                    LogLevel.ERROR,
                    "Kullanıcı bilinmeyen bir sebeple oluşturulamadı",
                    new CouldNotCreateUser("Kullanıcı bilinmeyen bir sebeple oluşturulamadı", StatusCode.BAD_REQUEST)
            );
        }
    }

    private String generateToken(String email) {
        return jwtUtil.generateToken(email);
    }

}
