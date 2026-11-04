class VolunteerTitle {
  final int id;
  final String name;
  final int level;
  final String? description;
  final String? icon;

  const VolunteerTitle({
    required this.id,
    required this.name,
    required this.level,
    this.description,
    this.icon,
  });

  factory VolunteerTitle.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final level = json['level'];
    final name = json['name'];
    return VolunteerTitle(
      id: id is num ? id.toInt() : 0,
      name: name is String ? name : '',
      level: level is num ? level.toInt() : 0,
      description: json['description'] is String
          ? json['description'] as String
          : null,
      icon: json['icon'] is String ? json['icon'] as String : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'level': level,
    'description': description,
    'icon': icon,
  };
}

VolunteerTitle? volunteerTitleFromJson(Object? json) {
  if (json is! Map<String, dynamic>) return null;
  final name = json['name'];
  final level = json['level'];
  if (name is! String || name.trim().isEmpty || level is! num) return null;
  return VolunteerTitle.fromJson(json);
}

Object? volunteerTitleToJson(VolunteerTitle? title) => title?.toJson();
