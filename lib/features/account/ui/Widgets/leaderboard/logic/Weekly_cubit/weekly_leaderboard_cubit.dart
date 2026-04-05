import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad/core/networking/api_result.dart';

import '../../data/repo/weekly_repo/weekly_leaderboard_repository.dart';
import '../leaderboard_state.dart';

class WeeklyLeaderboardCubit extends Cubit<LeaderboardState> {
  final WeeklyLeaderboardRepository _repository;

  WeeklyLeaderboardCubit(this._repository) : super(LeaderboardInitial());

  Future<void> getWeeklyLeaderboard() async {
    emit(LeaderboardLoading());
    final result = await _repository.getWeeklyLeaderboard();
    switch (result) {
      case Success(:final data):
        emit(LeaderboardSuccess(data));
      case Failure(:final error):
        emit(LeaderboardFailure(error));
    }
  }
}
