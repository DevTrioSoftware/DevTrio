class RoutePoint {
  final String id;
  final double latitude;
  final double longitude;
  final String address;
  final String? description;
  final DateTime? estimatedArrival;

  RoutePoint({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.description,
    this.estimatedArrival,
  });

  factory RoutePoint.fromJson(Map<String, dynamic> json) {
    return RoutePoint(
      id: json['id'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      address: json['address'] ?? '',
      description: json['description'],
      estimatedArrival: json['estimatedArrival'] != null
          ? DateTime.parse(json['estimatedArrival'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      if (description != null) 'description': description,
      if (estimatedArrival != null)
        'estimatedArrival': estimatedArrival!.toIso8601String(),
    };
  }
}

class RouteCard {
  final String id;
  final String title;
  final String description;
  final String startLocation;
  final String endLocation;
  final double distance; // km
  final Duration estimatedDuration;
  final double payment; // TL
  final bool isUrgent;
  final DateTime deadline;
  final String cargoType;
  final String? customerName;
  final String? customerPhone;

  RouteCard({
    required this.id,
    required this.title,
    required this.description,
    required this.startLocation,
    required this.endLocation,
    required this.distance,
    required this.estimatedDuration,
    required this.payment,
    required this.isUrgent,
    required this.deadline,
    required this.cargoType,
    this.customerName,
    this.customerPhone,
  });

  factory RouteCard.fromJson(Map<String, dynamic> json) {
    return RouteCard(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      startLocation: json['startLocation'] ?? '',
      endLocation: json['endLocation'] ?? '',
      distance: (json['distance'] ?? 0.0).toDouble(),
      estimatedDuration: Duration(
        minutes: json['estimatedDurationMinutes'] ?? 0,
      ),
      payment: (json['payment'] ?? 0.0).toDouble(),
      isUrgent: json['isUrgent'] ?? false,
      deadline: DateTime.parse(json['deadline']),
      cargoType: json['cargoType'] ?? '',
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startLocation': startLocation,
      'endLocation': endLocation,
      'distance': distance,
      'estimatedDurationMinutes': estimatedDuration.inMinutes,
      'payment': payment,
      'isUrgent': isUrgent,
      'deadline': deadline.toIso8601String(),
      'cargoType': cargoType,
      if (customerName != null) 'customerName': customerName,
      if (customerPhone != null) 'customerPhone': customerPhone,
    };
  }
}

class DriverRoute {
  final String id;
  final String driverId;
  final List<RoutePoint> points;
  final RouteCard routeCard;
  final String status; // pending, active, completed, cancelled
  final DateTime createdAt;
  final DateTime? startedAt;
  final DateTime? completedAt;

  DriverRoute({
    required this.id,
    required this.driverId,
    required this.points,
    required this.routeCard,
    required this.status,
    required this.createdAt,
    this.startedAt,
    this.completedAt,
  });

  factory DriverRoute.fromJson(Map<String, dynamic> json) {
    return DriverRoute(
      id: json['id'] ?? '',
      driverId: json['driverId'] ?? '',
      points: (json['points'] as List<dynamic>? ?? [])
          .map((point) => RoutePoint.fromJson(point))
          .toList(),
      routeCard: RouteCard.fromJson(json['routeCard']),
      status: json['status'] ?? 'pending',
      createdAt: DateTime.parse(json['createdAt']),
      startedAt: json['startedAt'] != null
          ? DateTime.parse(json['startedAt'])
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driverId': driverId,
      'points': points.map((point) => point.toJson()).toList(),
      'routeCard': routeCard.toJson(),
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      if (startedAt != null) 'startedAt': startedAt!.toIso8601String(),
      if (completedAt != null) 'completedAt': completedAt!.toIso8601String(),
    };
  }
}
