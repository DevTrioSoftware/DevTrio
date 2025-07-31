class CargoModel {
  final String? id;
  final String? userId;
  final double weight;
  final String cargoType;
  final String originAddress;
  final String destinationAddress;
  final CargoStatus status;
  final DateTime? deliveryDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CargoModel({
    this.id,
    this.userId,
    required this.weight,
    required this.cargoType,
    required this.originAddress,
    required this.destinationAddress,
    required this.status,
    this.deliveryDate,
    this.createdAt,
    this.updatedAt,
  });

  factory CargoModel.fromJson(Map<String, dynamic> json) {
    return CargoModel(
      id: json['id'],
      userId: json['user_id'],
      weight: json['weight']?.toDouble() ?? 0.0,
      cargoType: json['cargo_type'] ?? '',
      originAddress: json['origin_address'] ?? '',
      destinationAddress: json['destination_address'] ?? '',
      status: CargoStatus.fromString(json['status'] ?? 'PENDING'),
      deliveryDate: json['delivery_date'] != null
          ? DateTime.parse(json['delivery_date'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'weight': weight,
      'cargo_type': cargoType,
      'origin_address': originAddress,
      'destination_address': destinationAddress,
      'status': status.toString(),
      'delivery_date': deliveryDate?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

enum CargoStatus {
  pending('PENDING'),
  approved('APPROVED'),
  inTransit('IN_TRANSIT'),
  delivered('DELIVERED');

  const CargoStatus(this.value);
  final String value;

  static CargoStatus fromString(String value) {
    return CargoStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => CargoStatus.pending,
    );
  }

  @override
  String toString() => value;
}
