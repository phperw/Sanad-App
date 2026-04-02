import 'package:sanad/core/networking/api_error_model.dart';
import 'package:sanad/features/auth/login/data/models/login_response.dart';

sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {
  final LoginResponse data;
  LoginSuccess(this.data);
}

final class LoginFailure extends LoginState {
  final ApiErrorModel error;
  LoginFailure(this.error);
}
