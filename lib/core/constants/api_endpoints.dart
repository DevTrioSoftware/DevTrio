class ApiEndpoints {
  // Backend base URL - burayı kendi backend URL'iniz ile değiştirin
  static const String baseUrl = 'http://localhost:8080';

  // Auth endpoints
  static const String login = '/api/auth/login';
  static const String register = '/api/auth/register';

  // Diğer endpoints buraya eklenebilir
  static const String userProfile = '/api/user/profile';
  static const String updateProfile = '/api/user/update';
}
