import 'package:flutter/material.dart';
import 'package:sanad/features/account/data/models/volunteer_title.dart';

class LeaderboardEntry {
  final String medal;
  final String name;
  final String points;
  final String? imageUrl;
  final bool isCurrentUser;
  final Color pointsColor;
  final VolunteerTitle? volunteerTitle;

  const LeaderboardEntry({
    required this.medal,
    required this.name,
    required this.points,
    this.imageUrl,
    this.isCurrentUser = false,
    required this.pointsColor,
    this.volunteerTitle,
  });
}
