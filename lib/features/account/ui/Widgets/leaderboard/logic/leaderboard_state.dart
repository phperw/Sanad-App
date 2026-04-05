import 'package:sanad/core/networking/api_error_model.dart';
import '../data/models/leaderboard_response.dart';

sealed class LeaderboardState {}

final class LeaderboardInitial extends LeaderboardState {}

final class LeaderboardLoading extends LeaderboardState {}

final class LeaderboardSuccess extends LeaderboardState {
  final LeaderboardResponse data;
  LeaderboardSuccess(this.data);
}

final class LeaderboardFailure extends LeaderboardState {
  final ApiErrorModel error;
  LeaderboardFailure(this.error);
}
