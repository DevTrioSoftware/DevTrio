class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }

  factory LoginRequest.fromJson(Map<String, dynamic> json) {
    return LoginRequest(
      email: json['email'] ?? '',
      password: json['password'] ?? '',
    );
  }
}

class RegisterRequestDto {
  final String name;
  final String surname;
  final String email;
  final String password;
  final String? phone;
  final String? serialNumber;

  RegisterRequestDto({
    required this.name,
    required this.surname,
    required this.email,
    required this.password,
    this.phone,
    this.serialNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'surname': surname,
      'email': email,
      'password': password,
      if (phone != null) 'phone': phone,
      if (serialNumber != null) 'serialNumber': serialNumber,
    };
  }

  factory RegisterRequestDto.fromJson(Map<String, dynamic> json) {
    return RegisterRequestDto(
      name: json['name'] ?? '',
      surname: json['surname'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      phone: json['phone'],
      serialNumber: json['serialNumber'],
    );
  }
}

class AuthResponse {
  final String token;
  final String refreshToken;
  final String userId;
  final String email;
  final String name;
  final String surname;
  final String? phone;
  final String? serialNumber;
  final String? role;
  final bool isAdmin;

  AuthResponse({
    required this.token,
    required this.refreshToken,
    required this.userId,
    required this.email,
    required this.name,
    required this.surname,
    this.phone,
    this.serialNumber,
    this.role,
    this.isAdmin = false,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      userId: json['userId'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      surname: json['surname'] ?? '',
      phone: json['phone'],
      serialNumber: json['serialNumber'],
      role: json['role'],
      isAdmin: json['isAdmin'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'refreshToken': refreshToken,
      'userId': userId,
      'email': email,
      'name': name,
      'surname': surname,
      if (phone != null) 'phone': phone,
      if (serialNumber != null) 'serialNumber': serialNumber,
      if (role != null) 'role': role,
      'isAdmin': isAdmin,
    };
  }
}

class Response<T> {
  final bool success;
  final String message;
  final T? data;
  final List<String>? errors;

  Response({
    required this.success,
    required this.message,
    this.data,
    this.errors,
  });

  factory Response.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return Response<T>(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      errors: json['errors'] != null ? List<String>.from(json['errors']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data,
      'errors': errors,
    };
  }
}
