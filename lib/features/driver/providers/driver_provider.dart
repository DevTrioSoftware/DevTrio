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
  List<CustomRouteCard> _customRoutes = [];
  List<UserCreatedRoute> _userCreatedRoutes = [];
  Set<String> _selectedCustomRouteIds = {};
  bool _isSelectionMode = false;

  DriverApplication? get currentApplication => _currentApplication;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get applicationSubmitted => _applicationSubmitted;

  // Route getters
  List<RouteCard> get availableRoutes => _availableRoutes;
  List<DriverRoute> get activeRoutes => _activeRoutes;
  DriverRoute? get currentRoute => _currentRoute;
  List<CustomRouteCard> get customRoutes => _customRoutes;
  List<UserCreatedRoute> get userCreatedRoutes => _userCreatedRoutes;
  Set<String> get selectedCustomRouteIds => _selectedCustomRouteIds;
  bool get isSelectionMode => _isSelectionMode;

  // Driver status
  bool get isApprovedDriver => _currentApplication?.status == 'approved';

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String error) {
    _errorMessage = error;
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

  // Custom route management
  void loadCustomRoutes() {
    // In real app, load from local storage or API
    // For now, start with empty list
    _customRoutes = [];
    notifyListeners();
  }

  void addCustomRoute(CustomRouteCard customRoute) {
    _customRoutes.add(customRoute);
    notifyListeners();
  }

  void deleteCustomRoute(String routeId) {
    _customRoutes.removeWhere((route) => route.id == routeId);
    notifyListeners();
  }

  void updateCustomRoute(CustomRouteCard updatedRoute) {
    final index = _customRoutes.indexWhere(
      (route) => route.id == updatedRoute.id,
    );
    if (index != -1) {
      _customRoutes[index] = updatedRoute;
      notifyListeners();
    }
  }

  // Selection Management
  void toggleSelectionMode() {
    _isSelectionMode = !_isSelectionMode;
    if (!_isSelectionMode) {
      _selectedCustomRouteIds.clear();
    }
    notifyListeners();
  }

  void toggleCustomRouteSelection(String routeId) {
    if (_selectedCustomRouteIds.contains(routeId)) {
      _selectedCustomRouteIds.remove(routeId);
    } else {
      _selectedCustomRouteIds.add(routeId);
    }
    notifyListeners();
  }

  void clearSelection() {
    _selectedCustomRouteIds.clear();
    _isSelectionMode = false;
    notifyListeners();
  }

  // User Created Route Management
  void loadUserCreatedRoutes() async {
    try {
      setLoading(true);
      // Simulated data for testing
      _userCreatedRoutes = [
        // Mock data will be replaced with real API calls
      ];
      notifyListeners();
    } catch (e) {
      setError('Kullanıcı rotaları yüklenirken hata oluştu: $e');
    } finally {
      setLoading(false);
    }
  }

  void createRouteFromSelectedCards(
    String title,
    String description,
    String? color,
  ) {
    if (_selectedCustomRouteIds.isEmpty) {
      setError('Lütfen en az 2 nokta seçin');
      return;
    }

    if (_selectedCustomRouteIds.length < 2) {
      setError('Rota oluşturmak için en az 2 nokta seçmelisiniz');
      return;
    }

    // Get selected cards in order
    final selectedCards = _selectedCustomRouteIds
        .map((id) => _customRoutes.firstWhere((card) => card.id == id))
        .toList();

    // Calculate distance and duration (simplified)
    double totalDistance = _calculateTotalDistance(selectedCards);
    int estimatedDuration = _calculateEstimatedDuration(totalDistance);

    final newRoute = UserCreatedRoute(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      routePoints: selectedCards,
      createdAt: DateTime.now(),
      color: color,
      totalDistance: totalDistance,
      estimatedDuration: estimatedDuration,
    );

    _userCreatedRoutes.add(newRoute);
    clearSelection();
    notifyListeners();
  }

  void deleteUserCreatedRoute(String routeId) {
    _userCreatedRoutes.removeWhere((route) => route.id == routeId);
    notifyListeners();
  }

  double _calculateTotalDistance(List<CustomRouteCard> points) {
    double totalDistance = 0.0;
    for (int i = 0; i < points.length - 1; i++) {
      final point1 = points[i];
      final point2 = points[i + 1];
      totalDistance += _calculateDistance(
        point1.latitude,
        point1.longitude,
        point2.latitude,
        point2.longitude,
      );
    }
    return totalDistance;
  }

  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    // Haversine formula (simplified)
    const double earthRadius = 6371; // km
    double dLat = (lat2 - lat1) * (3.14159 / 180);
    double dLon = (lon2 - lon1) * (3.14159 / 180);
    double a =
        (dLat / 2).abs() * (dLat / 2).abs() +
        (lat1 * 3.14159 / 180).abs() *
            (lat2 * 3.14159 / 180).abs() *
            (dLon / 2).abs() *
            (dLon / 2).abs();
    double c = 2 * (a.abs()).abs();
    return earthRadius * c;
  }

  int _calculateEstimatedDuration(double distanceKm) {
    // Assume 50 km/h average speed
    return (distanceKm * 60 / 50).round();
  }
}
