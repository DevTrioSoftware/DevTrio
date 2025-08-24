package com.example.userservice.Exception;


import com.example.userservice.Extension.Response;
import com.example.userservice.Extension.StatusCode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class GlobalExceptionHandler {
    private static final Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    @ExceptionHandler(UserNotFoundException.class)
    public ResponseEntity<Response<Object>> handleUserNotFound(UserNotFoundException userNotFoundException) {
        Response<Object> response = Response.fail(
                userNotFoundException.getMessage(),
                userNotFoundException.getErrorCode()
        );
        return ResponseEntity
                .status(StatusCode.NOT_FOUND.getHttpCode())
                .body(response);
    }
    @ExceptionHandler(CouldNotCreateUser.class)
    public ResponseEntity<Response<Object>> handleCouldNotCreateUser(CouldNotCreateUser couldNotCreateUser) {
        Response<Object> response = Response.fail(
                couldNotCreateUser.getMessage(),
                couldNotCreateUser.getStatusCode()
        );
        return ResponseEntity
                .status(StatusCode.BAD_REQUEST.getHttpCode())
                .body(response);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<Response<Object>> handleException(Exception exception) {
        Response<Object> response = Response.fail(
                "An unexpected error occured",
                StatusCode.INTERNAL_ERROR
        );
        logger.error(exception.getMessage(), exception);
        return ResponseEntity
                .status(StatusCode.INTERNAL_ERROR.getHttpCode())
                .body(response);
    }


}
