import 'package:flutter/material.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/models/auth_models.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoggedIn = false;
  bool _isLoading = false;
  AuthResponse? _currentUser;
  String? _errorMessage;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  AuthResponse? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isAdmin => _currentUser?.isAdmin ?? false;

  // Login işlemi - GEÇİCİ HARDCODED AUTHENTİCATİON
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      // Geçici test bilgileri
      const String testEmail = 'test@test.com';
      const String testPassword = '123456';
      const String adminEmail = 'admin@admin.com';
      const String adminPassword = 'admin123';

      // 2 saniye bekleme (gerçek API çağrısını simüle eder)
      await Future.delayed(const Duration(seconds: 2));

      if (email.trim().toLowerCase() == testEmail && password == testPassword) {
        // Başarılı normal kullanıcı girişi
        _currentUser = AuthResponse(
          userId: '1',
          name: 'Test',
          surname: 'Kullanıcı',
          email: testEmail,
          token: 'mock_token_12345',
          refreshToken: 'mock_refresh_token_67890',
          isAdmin: false,
        );
        _isLoggedIn = true;
        _setLoading(false);
        notifyListeners();
        return true;
      } else if (email.trim().toLowerCase() == adminEmail &&
          password == adminPassword) {
        // Başarılı admin girişi
        _currentUser = AuthResponse(
          userId: 'admin_1',
          name: 'Admin',
          surname: 'Yönetici',
          email: adminEmail,
          token: 'admin_token_12345',
          refreshToken: 'admin_refresh_token_67890',
          isAdmin: true,
        );
        _isLoggedIn = true;
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _setError(
          'E-posta veya şifre hatalı!\nKullanıcı: test@test.com / 123456\nAdmin: admin@admin.com / admin123',
        );
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Giriş işlemi sırasında hata oluştu: $e');
      _setLoading(false);
      return false;
    }
  }

  // Register işlemi - GEÇİCİ HARDCODED AUTHENTİCATİON
  Future<bool> register(
    String name,
    String surname,
    String email,
    String password,
  ) async {
    _setLoading(true);
    _clearError();

    try {
      // 2 saniye bekleme (gerçek API çağrısını simüle eder)
      await Future.delayed(const Duration(seconds: 2));

      // Basit validasyon kontrolü
      if (name.trim().isEmpty ||
          surname.trim().isEmpty ||
          email.trim().isEmpty ||
          password.trim().isEmpty) {
        _setError('Tüm alanlar zorunludur!');
        _setLoading(false);
        return false;
      }

      if (password.length < 6) {
        _setError('Şifre en az 6 karakter olmalıdır!');
        _setLoading(false);
        return false;
      }

      // Başarılı kayıt - mock user data
      _currentUser = AuthResponse(
        userId: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name.trim(),
        surname: surname.trim(),
        email: email.trim().toLowerCase(),
        token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
        refreshToken:
            'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
      );
      _isLoggedIn = true;
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Kayıt işlemi sırasında hata oluştu: $e');
      _setLoading(false);
      return false;
    }
  }

  // Logout işlemi
  void logout() {
    _isLoggedIn = false;
    _currentUser = null;
    _clearError();
    notifyListeners();
  }

  // Profil güncelleme işlemi
  Future<bool> updateProfile({
    required String name,
    required String surname,
    String? phone,
  }) async {
    if (!_isLoggedIn || _currentUser == null) {
      _setError('Giriş yapılmamış!');
      return false;
    }

    _setLoading(true);
    _clearError();

    try {
      // 2 saniye bekleme (gerçek API çağrısını simüle eder)
      await Future.delayed(const Duration(seconds: 2));

      // Basit validasyon kontrolü
      if (name.trim().isEmpty || surname.trim().isEmpty) {
        _setError('Ad ve soyad alanları zorunludur!');
        _setLoading(false);
        return false;
      }

      // Profil güncelleme - mevcut user data'yı güncelle
      _currentUser = AuthResponse(
        userId: _currentUser!.userId,
        name: name.trim(),
        surname: surname.trim(),
        email: _currentUser!.email,
        token: _currentUser!.token,
        refreshToken: _currentUser!.refreshToken,
        phone: phone?.trim(),
        serialNumber: _currentUser!.serialNumber,
        role: _currentUser!.role,
        isAdmin: _currentUser!.isAdmin,
      );

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Profil güncellenirken hata oluştu: $e');
      _setLoading(false);
      return false;
    }
  }

  // Şifre değiştirme işlemi
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (!_isLoggedIn || _currentUser == null) {
      _setError('Giriş yapılmamış!');
      return false;
    }

    _setLoading(true);
    _clearError();

    try {
      // 2 saniye bekleme (gerçek API çağrısını simüle eder)
      await Future.delayed(const Duration(seconds: 2));

      // Basit validasyon kontrolü
      if (currentPassword.trim().isEmpty || newPassword.trim().isEmpty) {
        _setError('Şifre alanları boş olamaz!');
        _setLoading(false);
        return false;
      }

      if (newPassword.length < 6) {
        _setError('Yeni şifre en az 6 karakter olmalıdır!');
        _setLoading(false);
        return false;
      }

      // Mock şifre kontrolü - gerçek uygulamada API'den kontrol edilecek
      // Şimdilik her zaman başarılı kabul ediyoruz
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Şifre değiştirilirken hata oluştu: $e');
      _setLoading(false);
      return false;
    }
  }

  // Loading durumunu ayarla
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Hata mesajını ayarla
  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  // Hata mesajını temizle
  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
