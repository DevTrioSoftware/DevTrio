package com.example.userservice.Validator;

import com.example.userservice.Dto.UserLoginDto;
import com.example.userservice.Dto.UserRegisterDto;
import com.example.userservice.Extension.Response;
import com.example.userservice.Extension.StatusCode;
import com.example.userservice.Model.Enums.Role;
import com.example.userservice.Model.UserModel;
import com.example.userservice.Service.Interface.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class UserValidator {

    private final Logger logger = LoggerFactory.getLogger(UserValidator.class);
    private final UserService userService;
    private final PasswordEncoder passwordEncoder;

    public UserValidator(UserService userService,PasswordEncoder passwordEncoder) {
        this.userService = userService;
        this.passwordEncoder = passwordEncoder;
    }


    public Response<Void> validateRegister(UserRegisterDto userRegisterDto) {
        if (!userRegisterDto.getEmail().matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
            logger.info("Invalid email address");
            return Response.fail("Invalid email address", StatusCode.BAD_REQUEST);
        }
        if (isNullOrEmpty(userRegisterDto.getEmail())) {
            logger.info("register cannot be completed cause email is empty or null");
            return Response.fail("Email cannot be null or empty", StatusCode.BAD_REQUEST);
        }
        if (userService.existsByEmail(userRegisterDto.getEmail())) {
            logger.info("register cannot be completed cause email already exists");
            return Response.fail("Email already exists", StatusCode.BAD_REQUEST);
        }
        if (isNullOrEmpty(userRegisterDto.getPassword())) {
            logger.info("register cannot be completed cause password is empty or null");
            return Response.fail("Password cannot be null or empty", StatusCode.BAD_REQUEST);
        }
        if (!userRegisterDto.getPassword().equals(userRegisterDto.getConfirmPassword())) {
            logger.info("register cannot be completed cause passwords do not match");
            return Response.fail("Passwords do not match", StatusCode.BAD_REQUEST);
        }
        if (userRegisterDto.getRole() == Role.Driver) {
            if (isNullOrEmpty(userRegisterDto.getLicensePlate())) {
                logger.info("register cannot be completed cause license plate is empty or null");
                return Response.fail("License plate cannot be null or empty", StatusCode.BAD_REQUEST);
            }
            /*if (userService.existsDriverLicensePlate(userRegisterDto.getLicensePlate())) {
                logger.info("register cannot be completed cause license plate already exists");
                return Response.fail("License plate already exists", StatusCode.BAD_REQUEST);
            }*/
            if (isNullOrEmpty(userRegisterDto.getSerialNumber())) {
                logger.info("register cannot be completed cause serial number is empty or null");
                return Response.fail("Serial number cannot be null or empty", StatusCode.BAD_REQUEST);
            }
            if (!isValidTcKimlikNo(userRegisterDto.getSerialNumber())) {
                logger.info("register cannot be completed cause serial number is invalid");
                return Response.fail("Serial number is invalid", StatusCode.BAD_REQUEST);
            }
            /*if (userService.existsDriverBySerialNumber(userRegisterDto.getSerialNumber())) {
                logger.info("register cannot be completed cause serial number already exists");
                return Response.fail("Serial number already exists", StatusCode.BAD_REQUEST);
            }*///yorum satırı olan bölümler validate driver gibi bir methoda eklenecek
        }

        return Response.success();
    }


    public Response<UserModel> validateLogin(UserLoginDto userLoginDto) {
        if (isNullOrEmpty(userLoginDto.getEmail())) {
            logger.info("login cannot be completed cause email is empty or null");
            return Response.fail("Email cannot be null or empty", StatusCode.BAD_REQUEST);
        }

        Optional<UserModel> userOpt = userService.findUserByEmail(userLoginDto.getEmail());
        if (userOpt.isEmpty()) {
            logger.info("login cannot be completed cause this email does not exist in DB");
            return Response.fail("Email does not exist", StatusCode.NOT_FOUND);
        }

        if (isNullOrEmpty(userLoginDto.getPassword())) {
            logger.info("login cannot be completed cause password is empty or null");
            return Response.fail("Password cannot be null or empty", StatusCode.BAD_REQUEST);
        }

        UserModel userModel = userOpt.get();
        if (!passwordEncoder.matches(userLoginDto.getPassword(), userModel.getPassword())) {
            logger.info("login cannot be completed cause passwords do not match");
            return Response.fail("Passwords do not match", StatusCode.BAD_REQUEST);
        }

        return Response.success(userModel,"Login successful", StatusCode.SUCCESS);
    }

    private boolean isNullOrEmpty(String value) {
        return value == null || value.isEmpty();
    }


    private boolean isValidTcKimlikNo(String tc) {
        if (!tc.matches("\\d{11}")) return false;

        int[] digits = tc.chars().map(c -> c - '0').toArray();

        int toplamTekler = digits[0] + digits[2] + digits[4] + digits[6] + digits[8];
        int toplamCiftler = digits[1] + digits[3] + digits[5] + digits[7];

        int onuncu = ((toplamTekler * 7) - toplamCiftler) % 10;
        if (onuncu != digits[9]) return false;

        int toplamOn = 0;
        for (int i = 0; i < 10; i++) toplamOn += digits[i];

        int onbirinci = toplamOn % 10;
        if (onbirinci != digits[10]) return false;

        return true;
    }



}
