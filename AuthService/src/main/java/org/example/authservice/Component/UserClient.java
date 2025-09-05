package org.example.authservice.Component;


import org.example.authservice.Dto.LoginDto;
import org.example.authservice.Dto.UserServiceResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;

@Component
public class UserClient {

    private final WebClient webClient;

    public UserClient(WebClient.Builder builder)
    {
        this.webClient =builder.baseUrl("http://localhost:8081").build();
    }

    public UserServiceResponse userLogin(LoginDto loginDto)
    {
        return webClient.post()
                .uri("/api/user/validate/login")
                .bodyValue(loginDto)
                .retrieve()
                .bodyToMono(UserServiceResponse.class)
                .block();
    }

}
