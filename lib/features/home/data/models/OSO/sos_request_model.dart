class SosRequestModel {
  final int id;
  final double latitude;
  final double longitude;
  final String status;
  final String statusLabel;
  final bool isActive;
  final DateTime? createdAt;

  const SosRequestModel({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.statusLabel,
    required this.isActive,
    this.createdAt,
  });

  bool get isOpen => status == 'OPEN';

  bool get isResponded => status == 'RESPONDED';

  factory SosRequestModel.fromJson(Map<String, dynamic> json) {
    return SosRequestModel(
      id: (json['id'] as num).toInt(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      status: json['status'] as String? ?? 'OPEN',
      statusLabel: json['statusLabel'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '')
          ?.toLocal(),
    );
  }
}