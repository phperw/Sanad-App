import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad/core/networking/api_result.dart';
import 'package:sanad/features/auth/login/data/models/login_request.dart';
import '../../../../core/helper/shared_pref_helper.dart';
import '../../../../core/helper/shared_pref_keys.dart';
import '../data/repo/login_repository.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepository _repository;

  LoginCubit(this._repository) : super(LoginInitial());

  Future<void> login({
    required String nationalId,
    required String password,
  }) async {
    emit(LoginLoading());

    final result = await _repository.login(
      LoginRequest(nationalId: nationalId, password: password),
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
        emit(LoginSuccess(data));
      case Failure(:final error):
        emit(LoginFailure(error));
    }
  }
}
