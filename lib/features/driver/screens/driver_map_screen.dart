import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/route_model.dart';
import '../providers/driver_provider.dart';
import '../widgets/route_card_widget.dart';
import '../widgets/custom_route_card_dialog.dart';
import '../widgets/create_route_dialog.dart';

class DriverMapScreen extends StatefulWidget {
  const DriverMapScreen({super.key});

  @override
  State<DriverMapScreen> createState() => _DriverMapScreenState();
}

class _DriverMapScreenState extends State<DriverMapScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  // Tab management
  int _currentTabIndex =
      0; // 0: Available Routes, 1: Custom Routes, 2: User Created Routes

  // Istanbul coordinates as default
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(41.0082, 28.9784),
    zoom: 10.0,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRoutes();
    });
  }

  void _loadRoutes() {
    final driverProvider = Provider.of<DriverProvider>(context, listen: false);
    driverProvider.loadAvailableRoutes();
    driverProvider.loadCustomRoutes(); // Load user's custom routes
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _updateMarkers();
    _updatePolylines();
    _loadCustomRoutes();
  }

  void _updateMarkers() {
    final driverProvider = Provider.of<DriverProvider>(context, listen: false);
    Set<Marker> markers = {};

    // Add markers for available routes
    for (int i = 0; i < driverProvider.availableRoutes.length; i++) {
      final route = driverProvider.availableRoutes[i];

      // Start location marker
      markers.add(
        Marker(
          markerId: MarkerId('route_start_${route.id}'),
          position: _getLocationCoordinates(route.startLocation),
          infoWindow: InfoWindow(
            title: route.title,
            snippet: 'Başlangıç: ${route.startLocation}',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            route.isUrgent ? BitmapDescriptor.hueRed : BitmapDescriptor.hueBlue,
          ),
        ),
      );

      // End location marker
      markers.add(
        Marker(
          markerId: MarkerId('route_end_${route.id}'),
          position: _getLocationCoordinates(route.endLocation),
          infoWindow: InfoWindow(
            title: route.title,
            snippet: 'Varış: ${route.endLocation}',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            route.isUrgent
                ? BitmapDescriptor.hueOrange
                : BitmapDescriptor.hueGreen,
          ),
        ),
      );
    }

    // Add markers for custom routes
    for (final customRoute in driverProvider.customRoutes) {
      final isSelected = driverProvider.selectedCustomRouteIds.contains(
        customRoute.id,
      );

      markers.add(
        Marker(
          markerId: MarkerId('custom_${customRoute.id}'),
          position: LatLng(customRoute.latitude, customRoute.longitude),
          infoWindow: InfoWindow(
            title: customRoute.title,
            snippet: customRoute.description,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            isSelected
                ? BitmapDescriptor.hueYellow
                : _getHueFromColor(customRoute.color ?? 'purple'),
          ),
          onTap: () => driverProvider.isSelectionMode
              ? driverProvider.toggleCustomRouteSelection(customRoute.id)
              : _showCustomRouteDetails(customRoute),
        ),
      );
    }

    setState(() {
      _markers = markers;
    });
  }

  void _updatePolylines() {
    final driverProvider = Provider.of<DriverProvider>(context, listen: false);
    Set<Polyline> polylines = {};

    // Add polylines for user created routes
    for (final userRoute in driverProvider.userCreatedRoutes) {
      if (userRoute.routePoints.length >= 2) {
        List<LatLng> points = userRoute.routePoints
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();

        Color routeColor = _getColorFromString(userRoute.color ?? 'red');

        polylines.add(
          Polyline(
            polylineId: PolylineId('user_route_${userRoute.id}'),
            points: points,
            color: routeColor,
            width: 4,
            patterns: [PatternItem.dash(20), PatternItem.gap(10)],
          ),
        );
      }
    }

    setState(() {
      _polylines = polylines;
    });
  }

  Color _getColorFromString(String colorName) {
    switch (colorName) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'purple':
        return Colors.purple;
      case 'orange':
        return Colors.orange;
      case 'pink':
        return Colors.pink;
      case 'teal':
        return Colors.teal;
      case 'amber':
        return Colors.amber;
      default:
        return Colors.red;
    }
  }

  double _getHueFromColor(String colorName) {
    switch (colorName) {
      case 'red':
        return BitmapDescriptor.hueRed;
      case 'blue':
        return BitmapDescriptor.hueBlue;
      case 'green':
        return BitmapDescriptor.hueGreen;
      case 'purple':
        return BitmapDescriptor.hueViolet;
      case 'orange':
        return BitmapDescriptor.hueOrange;
      case 'pink':
        return BitmapDescriptor.hueRose;
      case 'teal':
        return BitmapDescriptor.hueCyan;
      case 'amber':
        return BitmapDescriptor.hueYellow;
      default:
        return BitmapDescriptor.hueViolet;
    }
  }

  void _loadCustomRoutes() {
    final driverProvider = Provider.of<DriverProvider>(context, listen: false);
    driverProvider.loadCustomRoutes();
    driverProvider.loadUserCreatedRoutes();
  }

  void _onMapTap(LatLng position) {
    final driverProvider = Provider.of<DriverProvider>(context, listen: false);

    if (!driverProvider.isSelectionMode) {
      _showCreateRouteDialog(position);
    }
  }

  void _showCreateRouteDialog(LatLng position) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomRouteCardDialog(
          position: position,
          onSave: (customRoute) {
            final driverProvider = Provider.of<DriverProvider>(
              context,
              listen: false,
            );
            driverProvider.addCustomRoute(customRoute);
            _updateMarkers();
            _updatePolylines();

            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${customRoute.title} başarıyla oluşturuldu!'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          },
        );
      },
    );
  }

  void _showCreateUserRouteDialog() {
    final driverProvider = Provider.of<DriverProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreateRouteDialog(
          selectedCount: driverProvider.selectedCustomRouteIds.length,
          onSave: (title, description, color) {
            driverProvider.createRouteFromSelectedCards(
              title,
              description,
              color,
            );
            _updateMarkers();
            _updatePolylines();

            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$title rotası başarıyla oluşturuldu!'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          },
        );
      },
    );
  }

  void _showCustomRouteDetails(CustomRouteCard customRoute) {
    showBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  customRoute.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(customRoute.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 15),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${customRoute.latitude.toStringAsFixed(4)}, ${customRoute.longitude.toStringAsFixed(4)}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              'Oluşturulma: ${customRoute.createdAt.day}/${customRoute.createdAt.month}/${customRoute.createdAt.year}',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _focusOnLocation(
                        LatLng(customRoute.latitude, customRoute.longitude),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Konuma Git'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      final driverProvider = Provider.of<DriverProvider>(
                        context,
                        listen: false,
                      );
                      driverProvider.deleteCustomRoute(customRoute.id);
                      Navigator.pop(context);
                      _updateMarkers();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                    child: const Text('Sil'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  LatLng _getLocationCoordinates(String location) {
    // Mock coordinates for demo purposes
    // In real app, you would use geocoding service
    switch (location.toLowerCase()) {
      case 'istanbul anadolu yakası':
        return const LatLng(40.9769, 29.1441);
      case 'ankara kızılay':
        return const LatLng(39.9334, 32.8597);
      case 'istanbul bakırköy':
        return const LatLng(40.9774, 28.8566);
      case 'izmir konak':
        return const LatLng(38.4189, 27.1287);
      case 'istanbul kadıköy':
        return const LatLng(40.9833, 29.0333);
      case 'bursa osmangazi':
        return const LatLng(40.1824, 29.0674);
      default:
        return const LatLng(41.0082, 28.9784); // Default Istanbul
    }
  }

  void _focusOnLocation(LatLng location) {
    if (_mapController != null) {
      _mapController!.animateCamera(CameraUpdate.newLatLngZoom(location, 15.0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Şoför Rota Haritası',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadRoutes,
          ),
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Harita üzerine tıklayarak kendi rotanızı oluşturabilirsiniz!',
                  ),
                  backgroundColor: Colors.blue,
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<DriverProvider>(
        builder: (context, driverProvider, child) {
          if (!driverProvider.isApprovedDriver) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.warning_amber, size: 64, color: Colors.orange),
                  SizedBox(height: 16),
                  Text(
                    'Bu sayfaya erişim için şoförlük başvurunuzun\nonaylanması gerekmektedir.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return Stack(
            children: [
              // Google Maps
              GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: _initialPosition,
                markers: _markers,
                polylines: _polylines,
                onTap: _onMapTap, // Enable tap to create custom routes
                mapType: MapType.normal,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: true,
                compassEnabled: true,
              ),

              // Top info banner
              Positioned(
                top: 10,
                left: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info, color: Colors.blue, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          driverProvider.isSelectionMode
                              ? '${driverProvider.selectedCustomRouteIds.length} nokta seçildi - Rota oluşturmak için en az 2 nokta seçin'
                              : 'Harita üzerine tıklayarak özel rota oluşturun',
                          style: TextStyle(
                            color: driverProvider.isSelectionMode
                                ? Colors.orange[700]
                                : Colors.grey[700],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Selection Mode Controls
              if (driverProvider.customRoutes.isNotEmpty)
                Positioned(
                  top: 80,
                  right: 16,
                  child: Column(
                    children: [
                      // Selection mode toggle button
                      FloatingActionButton(
                        heroTag: "selection_toggle",
                        mini: true,
                        backgroundColor: driverProvider.isSelectionMode
                            ? Colors.orange
                            : Colors.blue,
                        onPressed: () {
                          driverProvider.toggleSelectionMode();
                          _updateMarkers();
                        },
                        child: Icon(
                          driverProvider.isSelectionMode
                              ? Icons.close
                              : Icons.select_all,
                          color: Colors.white,
                        ),
                      ),

                      if (driverProvider.isSelectionMode)
                        const SizedBox(height: 8),

                      // Create route button (only show if 2+ items selected)
                      if (driverProvider.isSelectionMode &&
                          driverProvider.selectedCustomRouteIds.length >= 2)
                        FloatingActionButton(
                          heroTag: "create_route",
                          mini: true,
                          backgroundColor: Colors.green,
                          onPressed: () => _showCreateUserRouteDialog(),
                          child: const Icon(Icons.route, color: Colors.white),
                        ),
                    ],
                  ),
                ),

              // Bottom sheet with route cards
              DraggableScrollableSheet(
                initialChildSize: 0.3,
                minChildSize: 0.1,
                maxChildSize: 0.8,
                builder: (context, scrollController) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Drag handle
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),

                        // Header with tabs
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildTabButton('Müsait Rotalar', 0),
                              _buildTabButton('Özel Rotalarım', 1),
                              _buildTabButton('Oluşturulan Rotalar', 2),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Route cards list
                        Expanded(
                          child: driverProvider.isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : _buildTabContent(
                                  driverProvider,
                                  scrollController,
                                ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTabContent(
    DriverProvider driverProvider,
    ScrollController scrollController,
  ) {
    switch (_currentTabIndex) {
      case 0: // Available Routes
        return driverProvider.availableRoutes.isEmpty
            ? _buildEmptyState(
                'Müsait rota bulunmamaktadır',
                'Yeni rotalar için bekleyin',
              )
            : ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: driverProvider.availableRoutes.length,
                itemBuilder: (context, index) {
                  final routeCard = driverProvider.availableRoutes[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: RouteCardWidget(
                      routeCard: routeCard,
                      onAccept: () => _acceptRoute(routeCard),
                      onTap: () => _focusOnRoute(routeCard),
                    ),
                  );
                },
              );

      case 1: // Custom Routes
        return driverProvider.customRoutes.isEmpty
            ? _buildEmptyState(
                'Özel rota bulunmamaktadır',
                'Harita üzerine tıklayarak yeni rota oluşturun',
              )
            : ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: driverProvider.customRoutes.length,
                itemBuilder: (context, index) {
                  final customRoute = driverProvider.customRoutes[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildCustomRouteCard(customRoute),
                  );
                },
              );

      case 2: // User Created Routes
        return driverProvider.userCreatedRoutes.isEmpty
            ? _buildEmptyState(
                'Oluşturulan rota bulunmamaktadır',
                'Özel rotalarınızı birleştirerek yeni rota oluşturun',
              )
            : ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: driverProvider.userCreatedRoutes.length,
                itemBuilder: (context, index) {
                  final userRoute = driverProvider.userCreatedRoutes[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildUserRouteCard(userRoute),
                  );
                },
              );

      default:
        return _buildEmptyState('Bir hata oluştu', 'Lütfen tekrar deneyin');
    }
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.route_outlined, size: 48, color: Colors.grey),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 16)),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, int tabIndex) {
    final isActive = _currentTabIndex == tabIndex;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentTabIndex = tabIndex;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildCustomRouteCard(CustomRouteCard customRoute) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showCustomRouteDetails(customRoute),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getColorFromString(
                        customRoute.color ?? 'purple',
                      ).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.location_on,
                      color: _getColorFromString(customRoute.color ?? 'purple'),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customRoute.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          customRoute.description,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Koordinat: ${customRoute.latitude.toStringAsFixed(4)}, ${customRoute.longitude.toStringAsFixed(4)}',
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _acceptRoute(RouteCard routeCard) async {
    final driverProvider = Provider.of<DriverProvider>(context, listen: false);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rotayı Kabul Et'),
        content: Text(
          '${routeCard.title} rotasını kabul etmek istediğinize emin misiniz?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Kabul Et'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await driverProvider.acceptRoute(routeCard);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Rota başarıyla kabul edildi!'),
            backgroundColor: Colors.green,
          ),
        );
        _updateMarkers();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              driverProvider.errorMessage ?? 'Rota kabul edilirken hata oluştu',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _focusOnRoute(RouteCard routeCard) {
    if (_mapController != null) {
      final startCoords = _getLocationCoordinates(routeCard.startLocation);
      final endCoords = _getLocationCoordinates(routeCard.endLocation);

      // Calculate bounds to show both points
      final bounds = LatLngBounds(
        southwest: LatLng(
          startCoords.latitude < endCoords.latitude
              ? startCoords.latitude
              : endCoords.latitude,
          startCoords.longitude < endCoords.longitude
              ? startCoords.longitude
              : endCoords.longitude,
        ),
        northeast: LatLng(
          startCoords.latitude > endCoords.latitude
              ? startCoords.latitude
              : endCoords.latitude,
          startCoords.longitude > endCoords.longitude
              ? startCoords.longitude
              : endCoords.longitude,
        ),
      );

      _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
    }
  }

  Widget _buildUserRouteCard(UserCreatedRoute userRoute) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getColorFromString(
                      userRoute.color ?? 'red',
                    ).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.route,
                    color: _getColorFromString(userRoute.color ?? 'red'),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userRoute.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        userRoute.description,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
                // Delete button
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _deleteUserRoute(userRoute),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Route stats
            Row(
              children: [
                _buildStatChip(
                  Icons.location_on,
                  '${userRoute.routePoints.length} Nokta',
                  Colors.blue,
                ),
                const SizedBox(width: 8),
                _buildStatChip(
                  Icons.route,
                  '${userRoute.totalDistance.toStringAsFixed(1)} km',
                  Colors.green,
                ),
                const SizedBox(width: 8),
                _buildStatChip(
                  Icons.access_time,
                  '~${userRoute.estimatedDuration} dk',
                  Colors.orange,
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _focusOnUserRoute(userRoute),
                    icon: const Icon(Icons.visibility),
                    label: const Text('Haritada Göster'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _deleteUserRoute(UserCreatedRoute userRoute) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rotayı Sil'),
        content: Text(
          '${userRoute.title} rotasını silmek istediğinize emin misiniz?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sil'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final driverProvider = Provider.of<DriverProvider>(
        context,
        listen: false,
      );
      driverProvider.deleteUserCreatedRoute(userRoute.id);
      _updatePolylines();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${userRoute.title} rotası silindi'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _focusOnUserRoute(UserCreatedRoute userRoute) {
    if (_mapController != null && userRoute.routePoints.isNotEmpty) {
      final points = userRoute.routePoints
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();

      if (points.length == 1) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(points.first, 15.0),
        );
      } else {
        final bounds = _calculateBounds(points);
        _mapController!.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, 100),
        );
      }
    }
  }

  LatLngBounds _calculateBounds(List<LatLng> points) {
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final point in points) {
      minLat = point.latitude < minLat ? point.latitude : minLat;
      maxLat = point.latitude > maxLat ? point.latitude : maxLat;
      minLng = point.longitude < minLng ? point.longitude : minLng;
      maxLng = point.longitude > maxLng ? point.longitude : maxLng;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }
}
