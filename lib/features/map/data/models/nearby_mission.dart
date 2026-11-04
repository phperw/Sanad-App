class NearbyMission {
  final int id;
  final String? title;
  final String? description;
  final double? latitude;
  final double? longitude;
  final String? locationName;
  final String? date;
  final String? startTime;
  final String? endTime;
  final double? distanceMeters;
  final int? attendanceRadiusMeters;
  final int? requiredVolunteers;
  final int? availableSlots;
  final String? userJoinStatus;

  const NearbyMission({
    required this.id,
    this.title,
    this.description,
    this.latitude,
    this.longitude,
    this.locationName,
    this.date,
    this.startTime,
    this.endTime,
    this.distanceMeters,
    this.attendanceRadiusMeters,
    this.requiredVolunteers,
    this.availableSlots,
    this.userJoinStatus,
  });

  factory NearbyMission.fromJson(Map<String, dynamic> json) {
    return NearbyMission(
      id: _asInt(json['id']) ?? 0,
      title: _asString(json['title']),
      description: _asString(json['description']),
      latitude: _asDouble(json['latitude']),
      longitude: _asDouble(json['longitude']),
      locationName: _asString(json['locationName']),
      date: _asString(json['date']),
      startTime: _asString(json['startTime']),
      endTime: _asString(json['endTime']),
      distanceMeters: _asDouble(json['distanceMeters']),
      attendanceRadiusMeters: _asInt(json['attendanceRadiusMeters']),
      requiredVolunteers: _asInt(json['requiredVolunteers']),
      availableSlots: _asInt(json['availableSlots']),
      userJoinStatus: _asString(json['userJoinStatus']),
    );
  }

  bool get hasCoordinates =>
      latitude != null &&
      longitude != null &&
      latitude!.isFinite &&
      longitude!.isFinite &&
      latitude! >= -90 &&
      latitude! <= 90 &&
      longitude! >= -180 &&
      longitude! <= 180;

  bool get isJoinPending => userJoinStatus?.toLowerCase() == 'pending';

  bool get isApproved => userJoinStatus?.toLowerCase() == 'approved';

  bool get canJoin =>
      !isJoinPending && !isApproved && availableSlots != 0;

  NearbyMission withJoinStatus(String? status) => NearbyMission(
    id: id,
    title: title,
    description: description,
    latitude: latitude,
    longitude: longitude,
    locationName: locationName,
    date: date,
    startTime: startTime,
    endTime: endTime,
    distanceMeters: distanceMeters,
    attendanceRadiusMeters: attendanceRadiusMeters,
    requiredVolunteers: requiredVolunteers,
    availableSlots: availableSlots,
    userJoinStatus: status,
  );
}

int? _asInt(Object? value) {
  if (value is num) return value.toInt();
  return value == null ? null : int.tryParse(value.toString());
}

double? _asDouble(Object? value) {
  if (value is num) return value.toDouble();
  return value == null ? null : double.tryParse(value.toString());
}

String? _asString(Object? value) => value?.toString();
