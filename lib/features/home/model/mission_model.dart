class MissionModel {
  final String id;
  final String title;
  final String subtitle;
  final String time;
  final String timeRemaining;
  final String distance;
  final bool isActive;
  final double latitude;
  final double longitude;

  MissionModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.timeRemaining,
    required this.distance,
    required this.isActive,
    required this.latitude,
    required this.longitude,
  });
}

// THIS IS THE SOURCE: Both screens use this exact list
final List<MissionModel> dummyMissions = [
  MissionModel(
    id: '1',
    title: 'منطقة أكتوبر السكنية',
    subtitle: 'مهمة ميدانية سريعة',
    time: '10:00 AM',
    timeRemaining: 'متبقي 2س',
    distance: '50 متر',
    isActive: true,
    latitude: 29.9765,
    longitude: 30.9490,
  ),
  MissionModel(
    id: '2',
    title: 'حي المعادي - شارع 9',
    subtitle: 'دعم لوجستي وتوزيع',
    time: '2:30 PM',
    timeRemaining: 'متبقي 5س',
    distance: '15 كم',
    isActive: false,
    latitude: 29.9602,
    longitude: 31.2569,
  ),
];
