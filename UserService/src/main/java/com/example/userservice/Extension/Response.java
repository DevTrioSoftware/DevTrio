package com.example.userservice.Extension;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Data
public class Response<T> {

    private boolean success;
    private String message;
    private T data;
    private StatusCode statusCode;
    private long timeStamp;

    public static <T> Response<T> success(T data,String message,StatusCode statusCode) {
        return Response.<T>builder()
                .success(true)
                .message(message)
                .statusCode(statusCode)
                .data(data)
                .timeStamp(System.currentTimeMillis())
                .build();
    }
    public static <T> Response<T> loginSuccess(T data) {
        return Response.<T>builder()
                .success(true)
                .data(data)
                .timeStamp(System.currentTimeMillis())
                .build();
    }

    public static <T> Response<T> success()
    {
        return Response.<T>builder()
                .success(true)
                .timeStamp(System.currentTimeMillis())
                .build();
    }

    public static <T> Response<T> fail(String message,StatusCode statusCode) {
        return Response.<T>builder()
                .success(false)
                .message(message)
                .statusCode(statusCode)
                .timeStamp(System.currentTimeMillis())
                .build();
    }
}


