import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad/core/networking/api_result.dart';
import '../../data/repo/monthly_repo/monthly_leaderboard_repository.dart';
import '../leaderboard_state.dart';

class MonthlyLeaderboardCubit extends Cubit<LeaderboardState> {
  final MonthlyLeaderboardRepository _repository;

  MonthlyLeaderboardCubit(this._repository) : super(LeaderboardInitial());

  Future<void> getMonthlyLeaderboard() async {
    emit(LeaderboardLoading());
    final result = await _repository.getMonthlyLeaderboard();
    switch (result) {
      case Success(:final data):
        emit(LeaderboardSuccess(data));
      case Failure(:final error):
        emit(LeaderboardFailure(error));
    }
  }
}
