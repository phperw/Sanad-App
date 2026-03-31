// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';

// part 'home_state.dart';

// class HomeCubit extends Cubit<HomeState> {
//   HomeCubit() : super(HomeInitial());

  
// }
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sanad/core/networking/api_service.dart';
import 'package:sanad/features/home/model/home_model.dart';
import 'home_state.dart';


class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.api) : super(HomeInitial());

  final ApiDioService api ;

  Future<void> getHomeSummary() async {
    emit(HomeLoading());

    final response = await api.getRequest(endpoint: "/home");

    if (response != null) {
      final model = HomeModel.fromJson(response.data);
      emit(HomeSuccess(model));
    } else {
      emit(HomeError("فشل تحميل البيانات"));
    }
  }
}
