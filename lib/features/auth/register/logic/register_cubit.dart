import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad/core/networking/api_result.dart';
import '../../../../core/helper/shared_pref_helper.dart';
import '../../../../core/helper/shared_pref_keys.dart';
import '../data/model/register_request.dart';
import '../data/repo/register_repository.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterRepository _repository;

  RegisterCubit(this._repository) : super(RegisterInitial());

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

    final result = await _repository.register(
      RegisterRequest(
        fullName: fullName,
        nationalId: nationalId,
        email: email,
        phone: phone,
        dateOfBirth: dateOfBirth,
        password: password,
        confirmPassword: confirmPassword,
      ),
    );

    switch (result) {
      case Success(:final data):
        await SharedPrefHelper.setData(
          key: SharedPrefKeys.accessToken,
          value: data.accessToken,
        );
        await SharedPrefHelper.setData(
          key: SharedPrefKeys.refreshToken,
          value: data.refreshToken,
        );
        await SharedPrefHelper.setData(
          key: SharedPrefKeys.userId,
          value: data.user.id,
        );
        emit(RegisterSuccess(data));
      case Failure(:final error):
        emit(RegisterFailure(error));
    }
  }
}
