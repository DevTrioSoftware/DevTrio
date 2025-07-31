import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../core/models/driver_model.dart';
import '../../../core/models/auth_models.dart';

class AdminProvider extends ChangeNotifier {
  List<DriverApplication> _driverApplications = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Dashboard statistics
  int _totalUsers = 0;
  int _totalDrivers = 0;
  int _totalShipments = 0;

  List<DriverApplication> get driverApplications => _driverApplications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get totalUsers => _totalUsers;
  int get totalDrivers => _totalDrivers;
  int get totalShipments => _totalShipments;

  // Filtered applications
  List<DriverApplication> get pendingApplications =>
      _driverApplications.where((app) => app.status == 'pending').toList();

  List<DriverApplication> get approvedApplications =>
      _driverApplications.where((app) => app.status == 'approved').toList();

  List<DriverApplication> get rejectedApplications =>
      _driverApplications.where((app) => app.status == 'rejected').toList();

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Mock data ile başvuruları yükle
  Future<void> loadDriverApplications() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // API çağrısı simülasyonu
      await Future.delayed(const Duration(seconds: 1));

      // Mock data
      _driverApplications = [
        DriverApplication(
          id: '1001',
          tcKimlikNo: '12345678901',
          ehliyetNo: 'A123456',
          status: 'pending',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        DriverApplication(
          id: '1002',
          tcKimlikNo: '09876543210',
          ehliyetNo: 'B789012',
          status: 'pending',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        DriverApplication(
          id: '1003',
          tcKimlikNo: '11111111111',
          ehliyetNo: 'C345678',
          status: 'approved',
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
          updatedAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
        DriverApplication(
          id: '1004',
          tcKimlikNo: '22222222222',
          ehliyetNo: 'D901234',
          status: 'rejected',
          createdAt: DateTime.now().subtract(const Duration(days: 7)),
          updatedAt: DateTime.now().subtract(const Duration(days: 4)),
        ),
        DriverApplication(
          id: '1005',
          tcKimlikNo: '33333333333',
          ehliyetNo: 'E567890',
          status: 'pending',
          createdAt: DateTime.now().subtract(const Duration(hours: 6)),
        ),
      ];

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Başvurular yüklenirken hata oluştu: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Dashboard istatistiklerini yükle
  Future<void> loadDashboardStats() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      _totalUsers = 1250;
      _totalDrivers = 89;
      _totalShipments = 3420;

      notifyListeners();
    } catch (e) {
      _errorMessage = 'İstatistikler yüklenirken hata oluştu: ${e.toString()}';
      notifyListeners();
    }
  }

  // Başvuruyu onayla
  Future<bool> approveApplication(String applicationId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      final index = _driverApplications.indexWhere(
        (app) => app.id == applicationId,
      );
      if (index != -1) {
        _driverApplications[index] = DriverApplication(
          id: _driverApplications[index].id,
          tcKimlikNo: _driverApplications[index].tcKimlikNo,
          ehliyetNo: _driverApplications[index].ehliyetNo,
          status: 'approved',
          createdAt: _driverApplications[index].createdAt,
          updatedAt: DateTime.now(),
        );

        _isLoading = false;
        notifyListeners();
        return true;
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Başvuru onaylanırken hata oluştu: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Başvuruyu reddet
  Future<bool> rejectApplication(String applicationId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      final index = _driverApplications.indexWhere(
        (app) => app.id == applicationId,
      );
      if (index != -1) {
        _driverApplications[index] = DriverApplication(
          id: _driverApplications[index].id,
          tcKimlikNo: _driverApplications[index].tcKimlikNo,
          ehliyetNo: _driverApplications[index].ehliyetNo,
          status: 'rejected',
          createdAt: _driverApplications[index].createdAt,
          updatedAt: DateTime.now(),
        );

        _isLoading = false;
        notifyListeners();
        return true;
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Başvuru reddedilirken hata oluştu: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
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

  // Başvuru durumu string'ini getir
  String getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Beklemede';
      case 'approved':
        return 'Onaylandı';
      case 'rejected':
        return 'Reddedildi';
      default:
        return 'Bilinmeyen';
    }
  }

  // Başvuru ikonunu getir
  IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.schedule;
      case 'approved':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  // Son aktiviteleri getir
  List<String> getRecentActivities() {
    return [
      'Yeni şoför başvurusu alındı',
      'Kullanıcı kaydı tamamlandı',
      'Gönderi teslimat edildi',
      'Şoför başvurusu onaylandı',
      'Yeni rota eklendi',
    ];
  }
}
