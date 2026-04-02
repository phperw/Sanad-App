import 'package:sanad/core/networking/api_error_model.dart';
import '../data/model/register_response.dart';

sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class RegisterLoading extends RegisterState {}

final class RegisterSuccess extends RegisterState {
  final RegisterResponse data;
  RegisterSuccess(this.data);
}

final class RegisterFailure extends RegisterState {
  final ApiErrorModel error;
  RegisterFailure(this.error);
}
