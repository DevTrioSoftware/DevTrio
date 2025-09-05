package org.example.authservice.Extensions;

import lombok.Getter;

@Getter
public enum StatusCode {
    SUCCESS(200, "İşlem başarılı", "SUCCESS"),
    CREATED(201, "Kaynak oluşturuldu", "CREATED"),
    BAD_REQUEST(400, "Geçersiz istek", "BAD_REQUEST"),
    UNAUTHORIZED(401, "Yetkilendirme başarısız", "UNAUTHORIZED"),
    FORBIDDEN(403, "Erişim engellendi", "FORBIDDEN"),
    NOT_FOUND(404, "Kaynak bulunamadı", "NOT_FOUND"),
    INTERNAL_ERROR(500, "Sunucu hatası", "INTERNAL_ERROR");

    private final int httpCode;
    private final String message;
    private final String code;

    StatusCode(int httpCode, String message, String code) {
        this.httpCode = httpCode;
        this.message = message;
        this.code = code;
    }

}
