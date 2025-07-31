class DriverApplicationRequest {
  final String tcKimlikNo;
  final String ehliyetNo;

  DriverApplicationRequest({required this.tcKimlikNo, required this.ehliyetNo});

  Map<String, dynamic> toJson() {
    return {'tcKimlikNo': tcKimlikNo, 'ehliyetNo': ehliyetNo};
  }

  factory DriverApplicationRequest.fromJson(Map<String, dynamic> json) {
    return DriverApplicationRequest(
      tcKimlikNo: json['tcKimlikNo'] ?? '',
      ehliyetNo: json['ehliyetNo'] ?? '',
    );
  }
}

class DriverApplication {
  final String id;
  final String tcKimlikNo;
  final String ehliyetNo;
  final String status; // pending, approved, rejected
  final DateTime createdAt;
  final DateTime? updatedAt;

  DriverApplication({
    required this.id,
    required this.tcKimlikNo,
    required this.ehliyetNo,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  factory DriverApplication.fromJson(Map<String, dynamic> json) {
    return DriverApplication(
      id: json['id'] ?? '',
      tcKimlikNo: json['tcKimlikNo'] ?? '',
      ehliyetNo: json['ehliyetNo'] ?? '',
      status: json['status'] ?? 'pending',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tcKimlikNo': tcKimlikNo,
      'ehliyetNo': ehliyetNo,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }
}
