class HomeModel {
    HomeModel({
        required this.success,
        required this.message,
        required this.summary,
    });

    final bool? success;
    final String? message;
    final Summary? summary;

    factory HomeModel.fromJson(Map<String, dynamic> json){ 
        return HomeModel(
            success: json["success"],
            message: json["message"],
            summary: json["summary"] == null ? null : Summary.fromJson(json["summary"]),
        );
    }

}

class Summary {
    Summary({
        required this.volunteer,
        required this.stats,
        required this.announcements,
        required this.todayTasks,
        required this.upcomingTasks,
    });

    final Volunteer? volunteer;
    final Stats? stats;
    final List<dynamic> announcements;
    final List<dynamic> todayTasks;
    final List<dynamic> upcomingTasks;

    factory Summary.fromJson(Map<String, dynamic> json){ 
        return Summary(
            volunteer: json["volunteer"] == null ? null : Volunteer.fromJson(json["volunteer"]),
            stats: json["stats"] == null ? null : Stats.fromJson(json["stats"]),
            announcements: json["announcements"] == null ? [] : List<dynamic>.from(json["announcements"]!.map((x) => x)),
            todayTasks: json["todayTasks"] == null ? [] : List<dynamic>.from(json["todayTasks"]!.map((x) => x)),
            upcomingTasks: json["upcomingTasks"] == null ? [] : List<dynamic>.from(json["upcomingTasks"]!.map((x) => x)),
        );
    }

}

class Stats {
    Stats({
        required this.totalHours,
        required this.points,
        required this.badges,
        required this.assignedTasks,
        required this.reports,
        required this.todayTasks,
    });

    final int? totalHours;
    final int? points;
    final int? badges;
    final int? assignedTasks;
    final int? reports;
    final int? todayTasks;

    factory Stats.fromJson(Map<String, dynamic> json){ 
        return Stats(
            totalHours: json["totalHours"],
            points: json["points"],
            badges: json["badges"],
            assignedTasks: json["assignedTasks"],
            reports: json["reports"],
            todayTasks: json["todayTasks"],
        );
    }

}

class Volunteer {
    Volunteer({
        required this.id,
        required this.fullName,
        required this.nationalId,
        required this.email,
        required this.phone,
        required this.avatarUrl,
        required this.status,
        required this.totalHours,
        required this.points,
    });

    final int? id;
    final String? fullName;
    final String? nationalId;
    final String? email;
    final String? phone;
    final dynamic avatarUrl;
    final String? status;
    final int? totalHours;
    final int? points;

    factory Volunteer.fromJson(Map<String, dynamic> json){ 
        return Volunteer(
            id: json["id"],
            fullName: json["fullName"],
            nationalId: json["nationalId"],
            email: json["email"],
            phone: json["phone"],
            avatarUrl: json["avatarUrl"],
            status: json["status"],
            totalHours: json["totalHours"],
            points: json["points"],
        );
    }

}

// class HomeModel {
//   final Volunteer volunteer;
//   final Stats stats;

//   HomeModel({
//     required this.volunteer,
//     required this.stats,
//   });

//   factory HomeModel.fromJson(Map<String, dynamic> json) {
//     return HomeModel(
//       volunteer: Volunteer.fromJson(json['summary']['volunteer']),
//       stats: Stats.fromJson(json['summary']['stats']),
//     );
//   }
// }

// class Volunteer {
//   final String fullName;
//   final String email;
//   final int totalHours;
//   final int points;

//   Volunteer({
//     required this.fullName,
//     required this.email,
//     required this.totalHours,
//     required this.points,
//   });

//   factory Volunteer.fromJson(Map<String, dynamic> json) {
//     return Volunteer(
//       fullName: json['fullName'],
//       email: json['email'],
//       totalHours: json['totalHours'],
//       points: json['points'],
//     );
//   }
// }

// class Stats {
//   final int totalHours;
//   final int points;

//   Stats({
//     required this.totalHours,
//     required this.points,
//   });

//   factory Stats.fromJson(Map<String, dynamic> json) {
//     return Stats(
//       totalHours: json['totalHours'],
//       points: json['points'],
//     );
//   }
// }