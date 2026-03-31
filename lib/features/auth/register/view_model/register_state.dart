part of 'register_cubit.dart';

abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final dynamic data;
  RegisterSuccess(this.data);
}

class RegisterError extends RegisterState {
  final String message;
  RegisterError(this.message);
}