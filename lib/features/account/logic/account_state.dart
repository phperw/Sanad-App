import 'package:sanad/core/networking/api_error_model.dart';
import '../data/models/profile_response.dart';

sealed class AccountState {}

final class AccountInitial extends AccountState {}

final class AccountLoading extends AccountState {}

final class AccountSuccess extends AccountState {
  final ProfileResponse data;
  AccountSuccess(this.data);
}

final class AccountFailure extends AccountState {
  final ApiErrorModel error;
  AccountFailure(this.error);
}
