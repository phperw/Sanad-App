import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:sanad/core/networking/api_service.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final ApiDioService api;

  RegisterCubit(this.api) : super(RegisterInitial());

  Future<void> register({
    required String fullName,
    required String nationalId,
    required String email,
    required String phone,
    required String dateOfBirth,
    required String password,
    required String confirmPassword,
  }) async {
    emit(RegisterLoading());

    try {
      final response = await api.post(
        endpoint: "/auth/register",
        data: {
          "fullName": fullName,
          "nationalId": nationalId,
          "email": email,
          "phone": phone,
          "dateOfBirth": dateOfBirth,
          "password": password,
          "confirmPassword": confirmPassword,
        },
      );

      emit(RegisterSuccess(response.data));
    } catch (e) {
      emit(RegisterError(e.toString()));
    }
  }
}