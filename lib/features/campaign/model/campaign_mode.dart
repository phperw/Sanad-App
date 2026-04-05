class CampaignModel {
    CampaignModel({
        required this.success,
        required this.message,
        required this.pagination,
        required this.campaigns,
    });

    final bool? success;
    final String? message;
    final Pagination? pagination;
    final List<Campaign> campaigns;

    factory CampaignModel.fromJson(Map<String, dynamic> json){ 
        return CampaignModel(
            success: json["success"],
            message: json["message"],
            pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
            campaigns: json["campaigns"] == null ? [] : List<Campaign>.from(json["campaigns"]!.map((x) => Campaign.fromJson(x))),
        );
    }

}

class Campaign {
    Campaign({
        required this.id,
        required this.title,
        required this.description,
        required this.coverImage,
        required this.startDate,
        required this.endDate,
        required this.status,
        required this.location,
        required this.createdBy,
        required this.attendance,
        required this.stats,
        required this.nextTask,
    });

    final int? id;
    final String? title;
    final String? description;
    final String? coverImage;
    final DateTime? startDate;
    final DateTime? endDate;
    final String? status;
    final Location? location;
    final CreatedBy? createdBy;
    final Attendance? attendance;
    final Stats? stats;
    final dynamic nextTask;

    factory Campaign.fromJson(Map<String, dynamic> json){ 
        return Campaign(
            id: json["id"],
            title: json["title"],
            description: json["description"],
            coverImage: json["coverImage"],
            startDate: DateTime.tryParse(json["startDate"] ?? ""),
            endDate: DateTime.tryParse(json["endDate"] ?? ""),
            status: json["status"],
            location: json["location"] == null ? null : Location.fromJson(json["location"]),
            createdBy: json["createdBy"] == null ? null : CreatedBy.fromJson(json["createdBy"]),
            attendance: json["attendance"] == null ? null : Attendance.fromJson(json["attendance"]),
            stats: json["stats"] == null ? null : Stats.fromJson(json["stats"]),
            nextTask: json["nextTask"],
        );
    }

}

class Attendance {
    Attendance({
        required this.radiusMeters,
        required this.pointsOnCheckIn,
        required this.pointsOnReport,
        required this.distanceMeters,
        required this.isWithinRange,
    });

    final int? radiusMeters;
    final int? pointsOnCheckIn;
    final int? pointsOnReport;
    final dynamic distanceMeters;
    final dynamic isWithinRange;

    factory Attendance.fromJson(Map<String, dynamic> json){ 
        return Attendance(
            radiusMeters: json["radiusMeters"],
            pointsOnCheckIn: json["pointsOnCheckIn"],
            pointsOnReport: json["pointsOnReport"],
            distanceMeters: json["distanceMeters"],
            isWithinRange: json["isWithinRange"],
        );
    }

}

class CreatedBy {
    CreatedBy({
        required this.id,
        required this.fullName,
        required this.nationalId,
        required this.email,
        required this.phone,
        required this.avatarUrl,
        required this.status,
    });

    final int? id;
    final String? fullName;
    final String? nationalId;
    final String? email;
    final String? phone;
    final String? avatarUrl;
    final String? status;

    factory CreatedBy.fromJson(Map<String, dynamic> json){ 
        return CreatedBy(
            id: json["id"],
            fullName: json["fullName"],
            nationalId: json["nationalId"],
            email: json["email"],
            phone: json["phone"],
            avatarUrl: json["avatarUrl"],
            status: json["status"],
        );
    }

}

class Location {
    Location({
        required this.id,
        required this.name,
        required this.latitude,
        required this.longitude,
        required this.city,
        required this.area,
    });

    final int? id;
    final String? name;
    final double? latitude;
    final double? longitude;
    final String? city;
    final String? area;

    factory Location.fromJson(Map<String, dynamic> json){ 
        return Location(
            id: json["id"],
            name: json["name"],
            latitude: json["latitude"],
            longitude: json["longitude"],
            city: json["city"],
            area: json["area"],
        );
    }

}

class Stats {
    Stats({
        required this.tasks,
        required this.reports,
        required this.ratings,
        required this.registeredVolunteers,
    });

    final int? tasks;
    final int? reports;
    final int? ratings;
    final int? registeredVolunteers;

    factory Stats.fromJson(Map<String, dynamic> json){ 
        return Stats(
            tasks: json["tasks"],
            reports: json["reports"],
            ratings: json["ratings"],
            registeredVolunteers: json["registeredVolunteers"],
        );
    }

}

class Pagination {
    Pagination({
        required this.page,
        required this.limit,
        required this.total,
        required this.pages,
    });

    final int? page;
    final int? limit;
    final int? total;
    final int? pages;

    factory Pagination.fromJson(Map<String, dynamic> json){ 
        return Pagination(
            page: json["page"],
            limit: json["limit"],
            total: json["total"],
            pages: json["pages"],
        );
    }

}
