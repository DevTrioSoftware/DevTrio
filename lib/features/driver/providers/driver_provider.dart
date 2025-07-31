import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../core/models/driver_model.dart';
import '../../../core/models/auth_models.dart';

class DriverProvider extends ChangeNotifier {
  DriverApplication? _currentApplication;
  bool _isLoading = false;
  String? _errorMessage;
  bool _applicationSubmitted = false;

  DriverApplication? get currentApplication => _currentApplication;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get applicationSubmitted => _applicationSubmitted;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void resetApplication() {
    _applicationSubmitted = false;
    _currentApplication = null;
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> submitDriverApplication({
    required String tcKimlikNo,
    required String ehliyetNo,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // API çağrısı simülasyonu
      await Future.delayed(const Duration(seconds: 2));

      // Başarılı başvuru için mock data
      _currentApplication = DriverApplication(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        tcKimlikNo: tcKimlikNo,
        ehliyetNo: ehliyetNo,
        status: 'pending',
        createdAt: DateTime.now(),
      );

      _applicationSubmitted = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Başvuru gönderilirken bir hata oluştu: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // TC kimlik no validasyonu
  String? validateTcKimlikNo(String? value) {
    if (value == null || value.isEmpty) {
      return 'TC Kimlik No gereklidir';
    }

    if (value.length != 11) {
      return 'TC Kimlik No 11 haneli olmalıdır';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'TC Kimlik No sadece rakam içermelidir';
    }

    return null;
  }

  // Ehliyet no validasyonu
  String? validateEhliyetNo(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ehliyet No gereklidir';
    }

    if (value.length < 6) {
      return 'Ehliyet No en az 6 karakter olmalıdır';
    }

    return null;
  }

  // Başvuru durumunu getir
  Future<DriverApplication?> getApplicationStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      // API çağrısı simülasyonu
      await Future.delayed(const Duration(seconds: 1));

      // Eğer bir başvuru varsa döndür
      _isLoading = false;
      notifyListeners();
      return _currentApplication;
    } catch (e) {
      _errorMessage = 'Başvuru durumu alınırken hata oluştu: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  // Başvuru durumu string'ini getir
  String getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'İncelemede';
      case 'approved':
        return 'Onaylandı';
      case 'rejected':
        return 'Reddedildi';
      default:
        return 'Bilinmeyen';
    }
  }

  // Başvuru durumu rengini getir
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFF6AD55); // warning color
      case 'approved':
        return const Color(0xFF48BB78); // success color
      case 'rejected':
        return const Color(0xFFE53E3E); // error color
      default:
        return const Color(0xFF718096); // secondary color
    }
  }

  // Mock data ile farklı durumları simüle et
  void simulateStatusChange() {
    if (_currentApplication != null) {
      final statuses = ['pending', 'approved', 'rejected'];
      final random = DateTime.now().millisecond % 3;
      _currentApplication = DriverApplication(
        id: _currentApplication!.id,
        tcKimlikNo: _currentApplication!.tcKimlikNo,
        ehliyetNo: _currentApplication!.ehliyetNo,
        status: statuses[random],
        createdAt: _currentApplication!.createdAt,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }
}
