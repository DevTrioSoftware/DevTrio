import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/auth_models.dart';
import '../constants/api_endpoints.dart';

class AuthService {
  static const String baseUrl = ApiEndpoints.baseUrl;

  // Login işlemi
  Future<Response<AuthResponse>> login(LoginRequest loginRequest) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(loginRequest.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return Response<AuthResponse>.fromJson(
          responseData,
          (json) => AuthResponse.fromJson(json),
        );
      } else {
        // Hata durumunda
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        return Response<AuthResponse>(
          success: false,
          message: errorData['message'] ?? 'Giriş başarısız',
          data: null,
          errors: errorData['errors'] != null
              ? List<String>.from(errorData['errors'])
              : null,
        );
      }
    } catch (e) {
      return Response<AuthResponse>(
        success: false,
        message: 'Bağlantı hatası: $e',
        data: null,
        errors: ['Ağ bağlantısı hatası'],
      );
    }
  }

  // Register işlemi
  Future<Response<AuthResponse>> register(
    RegisterRequestDto registerRequest,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(registerRequest.toJson()),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return Response<AuthResponse>.fromJson(
          responseData,
          (json) => AuthResponse.fromJson(json),
        );
      } else {
        // Hata durumunda
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        return Response<AuthResponse>(
          success: false,
          message: errorData['message'] ?? 'Kayıt başarısız',
          data: null,
          errors: errorData['errors'] != null
              ? List<String>.from(errorData['errors'])
              : null,
        );
      }
    } catch (e) {
      return Response<AuthResponse>(
        success: false,
        message: 'Bağlantı hatası: $e',
        data: null,
        errors: ['Ağ bağlantısı hatası'],
      );
    }
  }
}
