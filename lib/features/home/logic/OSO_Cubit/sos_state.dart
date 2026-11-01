part of 'sos_cubit.dart';

sealed class SosState {}

final class SosInitial extends SosState {}

final class SosSendLoading extends SosState {}

final class SosSendSuccess extends SosState {
  final SosRequestModel request;
  SosSendSuccess(this.request);
}

final class SosSendError extends SosState {
  final String error;
  SosSendError(this.error);
}

final class SosTracking extends SosState {
  final SosRequestModel request;
  SosTracking(this.request);
}

final class SosTrackingEnded extends SosState {
  final SosRequestModel request;
  SosTrackingEnded(this.request);
}

final class SosNoActive extends SosState {}

final class SosCancelLoading extends SosState {}

final class SosCancelSuccess extends SosState {}

final class SosCancelError extends SosState {
  final String error;
  SosCancelError(this.error);
}