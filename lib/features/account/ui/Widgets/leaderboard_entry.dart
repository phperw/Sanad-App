import 'package:flutter/material.dart';

class LeaderboardEntry {
  final String medal;
  final String name;
  final String points;
  final String? imageUrl;
  final bool isCurrentUser;
  final Color pointsColor;

  const LeaderboardEntry({
    required this.medal,
    required this.name,
    required this.points,
    this.imageUrl,
    this.isCurrentUser = false,
    required this.pointsColor,
  });
}
