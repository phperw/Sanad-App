

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:sanad/core/helper/storage.dart';
import 'package:sanad/core/networking/api_service.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final ApiDioService apiService;
  final StorageHelper storageHelper = StorageHelper(); // 👈 ضيفي ده

  LoginCubit(this.apiService) : super(LoginInitial());

  Future<void> login({
    required String nationalId,
    required String password,
  }) async {
    emit(LoginLoading());

    try {
      Response response = await apiService.post(
        endpoint: '/auth/login',
        data: {
          "nationalId": nationalId,
          "password": password,
        },
      );

      if (response.statusCode == 200) {
        // 👇 هنا أهم سطر
        final token = response.data['accessToken']; // أو accessToken حسب الـ API

        await storageHelper.saveToken(token);

        print("SAVED TOKEN: $token"); // للتأكد

        emit(LoginSuccess());
      } else {
        emit(LoginError(message: response.data['message'] ?? 'حدث خطأ'));
      }
    } catch (e) {
      emit(LoginError(message: e.toString()));
    }
  }
}
// class LoginCubit extends Cubit<LoginState> {
//   final ApiDioService apiService;

//   LoginCubit( this.apiService) : super(LoginInitial());

//   Future<void> login({
//     required String nationalId,
//     required String password,
//   }) async {
//     emit(LoginLoading());

//     try {
//       Response response = await apiService.post(
//         endpoint: '/auth/login',
//         data: {
//           "nationalId": nationalId,
//           "password": password,
//         },
//       );

//       if (response.statusCode == 200) {
       
//         emit(LoginSuccess());
//       } else {
//         emit(LoginError(message: response.data['message'] ?? 'حدث خطأ'));
//       }
//     } catch (e) {
//       emit(LoginError(message: e.toString()));
//     }
//   }
// }