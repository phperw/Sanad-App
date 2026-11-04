Map<String, dynamic> missionJsonMap(Object? value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return value.map((key, value) => MapEntry('$key', value));
  return const {};
}

int missionJsonInt(Object? value, [int fallback = 0]) =>
    value is num ? value.toInt() : int.tryParse('$value') ?? fallback;

double missionJsonDouble(Object? value, [double fallback = 0]) =>
    value is num ? value.toDouble() : double.tryParse('$value') ?? fallback;

bool missionJsonBool(Object? value) => value == true;

String missionJsonString(Object? value, [String fallback = '']) =>
    value == null ? fallback : value.toString();

class MissionDetails {
  final int id;
  final String title;
  final String description;
  final String typeLabel;
  final String? coverImage;
  final String status;
  final String date;
  final String? startTime;
  final String? endTime;
  final int durationHours;
  final MissionLocation location;
  final MissionCampaign campaign;
  final int volunteersCount;
  final int attendanceRadiusMeters;
  final MissionReward reward;
  final List<MissionStep> steps;
  final int completedSteps;
  final int totalSteps;
  final String assignmentStatus;
  final bool isAssigned;
  final bool canCheckIn;
  final bool canSubmitReport;
  final bool hasSubmittedReport;

  const MissionDetails({
    required this.id,
    required this.title,
    required this.description,
    required this.typeLabel,
    required this.coverImage,
    required this.status,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.durationHours,
    required this.location,
    required this.campaign,
    required this.volunteersCount,
    required this.attendanceRadiusMeters,
    required this.reward,
    required this.steps,
    required this.completedSteps,
    required this.totalSteps,
    required this.assignmentStatus,
    required this.isAssigned,
    required this.canCheckIn,
    required this.canSubmitReport,
    required this.hasSubmittedReport,
  });

  factory MissionDetails.fromJson(Map<String, dynamic> json) {
    final location = missionJsonMap(json['location']);
    final campaign = missionJsonMap(json['campaign']);
    final attendance = missionJsonMap(json['attendance']);
    final reward = missionJsonMap(json['reward']);
    final progress = missionJsonMap(json['progress']);
    final assignment = missionJsonMap(json['myAssignment']);
    final permissions = missionJsonMap(json['permissions']);
    final rawSteps = json['steps'];
    final badge = missionJsonMap(reward['badge']);
    final points = missionJsonMap(reward['points']);

    return MissionDetails(
      id: missionJsonInt(json['id']),
      title: missionJsonString(json['title']),
      description: missionJsonString(json['description']),
      typeLabel: missionJsonString(json['typeLabel'], 'مهمة تطوعية'),
      coverImage: json['coverImage']?.toString(),
      status: missionJsonString(json['status']),
      date: missionJsonString(json['date']),
      startTime: json['startTime']?.toString(),
      endTime: json['endTime']?.toString(),
      durationHours: missionJsonInt(json['durationHours']),
      location: MissionLocation(
        name: missionJsonString(location['name']),
        city: missionJsonString(location['city']),
        area: missionJsonString(location['area']),
        latitude: missionJsonDouble(location['latitude']),
        longitude: missionJsonDouble(location['longitude']),
      ),
      campaign: MissionCampaign(title: missionJsonString(campaign['title'])),
      volunteersCount: missionJsonInt(json['volunteersCount']),
      attendanceRadiusMeters: missionJsonInt(attendance['radiusMeters']),
      reward: MissionReward(
        hours: missionJsonInt(reward['hours']),
        attendancePoints: missionJsonInt(points['attendance']),
        reportPoints: missionJsonInt(points['report']),
        totalPoints: missionJsonInt(points['total']),
        badgeName: badge['name']?.toString(),
      ),
      steps: rawSteps is List
          ? rawSteps
                .map((step) => MissionStep.fromJson(missionJsonMap(step)))
                .toList()
          : const [],
      completedSteps: missionJsonInt(progress['completedSteps']),
      totalSteps: missionJsonInt(progress['totalSteps']),
      assignmentStatus: missionJsonString(assignment['status']),
      isAssigned: missionJsonBool(permissions['isAssigned']),
      canCheckIn: missionJsonBool(permissions['canCheckIn']),
      canSubmitReport: missionJsonBool(permissions['canSubmitReport']),
      hasSubmittedReport: missionJsonBool(permissions['hasSubmittedReport']),
    );
  }
}

class MissionLocation {
  final String name;
  final String city;
  final String area;
  final double latitude;
  final double longitude;

  const MissionLocation({
    required this.name,
    required this.city,
    required this.area,
    required this.latitude,
    required this.longitude,
  });
}

class MissionCampaign {
  final String title;

  const MissionCampaign({required this.title});
}

class MissionReward {
  final int hours;
  final int attendancePoints;
  final int reportPoints;
  final int totalPoints;
  final String? badgeName;

  const MissionReward({
    required this.hours,
    required this.attendancePoints,
    required this.reportPoints,
    required this.totalPoints,
    required this.badgeName,
  });
}

class MissionStep {
  final String title;
  final bool completed;
  final bool isCurrent;

  const MissionStep({
    required this.title,
    required this.completed,
    required this.isCurrent,
  });

  factory MissionStep.fromJson(Map<String, dynamic> json) => MissionStep(
    title: missionJsonString(json['title']),
    completed: missionJsonBool(json['completed']),
    isCurrent: missionJsonBool(json['isCurrent']),
  );
}
