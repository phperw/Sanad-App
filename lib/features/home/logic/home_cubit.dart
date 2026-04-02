import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad/core/networking/api_result.dart';
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
        emit(HomeSuccess(data));
      case Failure(:final error):
        emit(HomeFailure(error));
    }
  }
}
