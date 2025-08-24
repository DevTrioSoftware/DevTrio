package com.example.userservice.Service;


import jakarta.mail.internet.MimeMessage;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.ThreadLocalRandom;

@Service
public class EmailService {

    private final JavaMailSender mailSender;
    private final ResourceLoader resourceLoader;

    public EmailService(JavaMailSender mailSender, ResourceLoader resourceLoader) {
        this.mailSender = mailSender;
        this.resourceLoader = resourceLoader;
    }

    public void sendHtmlMailWithImage(String to, String subject, String name) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom("devtriosoftware@gmail.com");
            helper.setTo(to);
            helper.setSubject(subject);

            String html = loadHtmlTemplate("templates/register_mail.html");
            html = html.replace("{{name}}", name);

            helper.setText(html, true);

            ClassPathResource image = new ClassPathResource("static/images/banner.png");
            helper.addInline("banner-image", image);

            mailSender.send(message);

        } catch (Exception ex) {
            throw new RuntimeException("Mail gönderilemedi: " + ex.getMessage(), ex);
        }
    }
    public void sendResetPasswordMail(String to, String subject,String resetCode) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom("devtriosoftware@gmail.com");
            helper.setTo(to);
            helper.setSubject(subject);

            String html = loadHtmlTemplate("templates/reset_password_mail.html");
            html = html.replace("{{code}}", resetCode);

            helper.setText(html, true);

            ClassPathResource image = new ClassPathResource("static/images/banner.png");
            if (image.exists()) {
                helper.addInline("banner-image", image);
            }

            mailSender.send(message);

        } catch (Exception ex) {
            throw new RuntimeException("Mail gönderilemedi: " + ex.getMessage(), ex);
        }
    }


    private String loadHtmlTemplate(String path) throws IOException {
        InputStream inputStream = resourceLoader.getResource("classpath:" + path).getInputStream();
        return new String(inputStream.readAllBytes(), StandardCharsets.UTF_8);
    }

    public String generate()
    {
        int code = ThreadLocalRandom.current().nextInt(100_000, 1_000_000);
        return String.valueOf(code);
    }
}
