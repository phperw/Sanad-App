import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad/core/networking/api_result.dart';
import '../../../core/di/dependency_injection.dart';
import '../../chats_and_community/data/api_service/chat_bot_service.dart';
import '../data/repo/home_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _repository;

  HomeCubit(this._repository) : super(HomeInitial());

  Future<void> getHomeData() async {
    emit(HomeLoading());
    final result = await _repository.getHomeData();

    switch (result) {
      case Success(:final data):
        getIt<ChatbotService>().initChat(
          volunteerName: data.summary.volunteer.fullName,
          points: data.summary.stats.points,
          totalHours: data.summary.stats.totalHours,
          todayTasks: data.summary.todayTasks.map((t) => t.title).toList(),
        );
        emit(HomeSuccess(data));
      case Failure(:final error):
        emit(HomeFailure(error));
    }
  }
}
