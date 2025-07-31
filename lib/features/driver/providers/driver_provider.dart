import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../core/models/driver_model.dart';
import '../../../core/models/route_model.dart';

class DriverProvider extends ChangeNotifier {
  DriverApplication? _currentApplication;
  bool _isLoading = false;
  String? _errorMessage;
  bool _applicationSubmitted = false;

  // Route management
  List<RouteCard> _availableRoutes = [];
  List<DriverRoute> _activeRoutes = [];
  DriverRoute? _currentRoute;

  DriverApplication? get currentApplication => _currentApplication;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get applicationSubmitted => _applicationSubmitted;

  // Route getters
  List<RouteCard> get availableRoutes => _availableRoutes;
  List<DriverRoute> get activeRoutes => _activeRoutes;
  DriverRoute? get currentRoute => _currentRoute;

  // Driver status
  bool get isApprovedDriver => _currentApplication?.status == 'approved';

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
      // Başarılı başvuru için mock data (test için onaylanmış durumda)
      _currentApplication = DriverApplication(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        tcKimlikNo: tcKimlikNo,
        ehliyetNo: ehliyetNo,
        status: 'approved', // Test için onaylanmış durumda
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

  // Load available routes for approved drivers
  Future<void> loadAvailableRoutes() async {
    if (!isApprovedDriver) return;

    _isLoading = true;
    notifyListeners();

    try {
      // API call simulation
      await Future.delayed(const Duration(seconds: 1));

      // Mock route cards data
      _availableRoutes = [
        RouteCard(
          id: '1',
          title: 'İstanbul - Ankara Express',
          description: 'Acil elektronik kargo taşıması',
          startLocation: 'İstanbul Anadolu Yakası',
          endLocation: 'Ankara Kızılay',
          distance: 450.0,
          estimatedDuration: const Duration(hours: 5),
          payment: 1500.0,
          isUrgent: true,
          deadline: DateTime.now().add(const Duration(hours: 8)),
          cargoType: 'Elektronik',
          customerName: 'Tech Solutions Ltd.',
          customerPhone: '+90 555 123 4567',
        ),
        RouteCard(
          id: '2',
          title: 'İstanbul - İzmir Standart',
          description: 'Gıda ürünleri taşıması',
          startLocation: 'İstanbul Bakırköy',
          endLocation: 'İzmir Konak',
          distance: 565.0,
          estimatedDuration: const Duration(hours: 6, minutes: 30),
          payment: 1200.0,
          isUrgent: false,
          deadline: DateTime.now().add(const Duration(days: 1)),
          cargoType: 'Gıda',
          customerName: 'Fresh Foods A.Ş.',
          customerPhone: '+90 555 987 6543',
        ),
        RouteCard(
          id: '3',
          title: 'İstanbul - Bursa Hızlı',
          description: 'Medikal malzeme taşıması',
          startLocation: 'İstanbul Kadıköy',
          endLocation: 'Bursa Osmangazi',
          distance: 155.0,
          estimatedDuration: const Duration(hours: 2, minutes: 30),
          payment: 800.0,
          isUrgent: true,
          deadline: DateTime.now().add(const Duration(hours: 4)),
          cargoType: 'Medikal',
          customerName: 'Health Care Inc.',
          customerPhone: '+90 555 456 7890',
        ),
      ];

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Rotalar yüklenirken hata oluştu: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Accept a route card and create a route
  Future<bool> acceptRoute(RouteCard routeCard) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      // Create route points (mock data)
      List<RoutePoint> routePoints = [
        RoutePoint(
          id: '1',
          latitude: 40.9769, // İstanbul start point
          longitude: 29.1441,
          address: routeCard.startLocation,
          description: 'Başlangıç noktası',
        ),
        RoutePoint(
          id: '2',
          latitude: 39.9334, // Ankara end point
          longitude: 32.8597,
          address: routeCard.endLocation,
          description: 'Varış noktası',
          estimatedArrival: DateTime.now().add(routeCard.estimatedDuration),
        ),
      ];

      // Create new route
      final newRoute = DriverRoute(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        driverId: _currentApplication!.id,
        points: routePoints,
        routeCard: routeCard,
        status: 'active',
        createdAt: DateTime.now(),
        startedAt: DateTime.now(),
      );

      _activeRoutes.add(newRoute);
      _currentRoute = newRoute;

      // Remove from available routes
      _availableRoutes.removeWhere((route) => route.id == routeCard.id);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Rota kabul edilirken hata oluştu: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Complete current route
  Future<bool> completeRoute(String routeId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      final routeIndex = _activeRoutes.indexWhere(
        (route) => route.id == routeId,
      );
      if (routeIndex != -1) {
        _activeRoutes[routeIndex] = DriverRoute(
          id: _activeRoutes[routeIndex].id,
          driverId: _activeRoutes[routeIndex].driverId,
          points: _activeRoutes[routeIndex].points,
          routeCard: _activeRoutes[routeIndex].routeCard,
          status: 'completed',
          createdAt: _activeRoutes[routeIndex].createdAt,
          startedAt: _activeRoutes[routeIndex].startedAt,
          completedAt: DateTime.now(),
        );

        if (_currentRoute?.id == routeId) {
          _currentRoute = null;
        }
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Rota tamamlanırken hata oluştu: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Cancel route
  Future<bool> cancelRoute(String routeId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      final routeIndex = _activeRoutes.indexWhere(
        (route) => route.id == routeId,
      );
      if (routeIndex != -1) {
        final cancelledRoute = _activeRoutes[routeIndex];
        _activeRoutes.removeAt(routeIndex);

        // Add back to available routes
        _availableRoutes.add(cancelledRoute.routeCard);

        if (_currentRoute?.id == routeId) {
          _currentRoute = null;
        }
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Rota iptal edilirken hata oluştu: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
