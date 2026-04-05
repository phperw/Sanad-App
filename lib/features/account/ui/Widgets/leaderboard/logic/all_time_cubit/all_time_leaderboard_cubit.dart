import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad/core/networking/api_result.dart';

import '../../data/repo/all_time_repo/all_time_leaderboard_repository.dart';
import '../leaderboard_state.dart';

class AllTimeLeaderboardCubit extends Cubit<LeaderboardState> {
  final AllTimeLeaderboardRepository _repository;

  AllTimeLeaderboardCubit(this._repository) : super(LeaderboardInitial());

  Future<void> getAllTimeLeaderboard() async {
    emit(LeaderboardLoading());
    final result = await _repository.getAllTimeLeaderboard();
    switch (result) {
      case Success(:final data):
        emit(LeaderboardSuccess(data));
      case Failure(:final error):
        emit(LeaderboardFailure(error));
    }
  }
}
