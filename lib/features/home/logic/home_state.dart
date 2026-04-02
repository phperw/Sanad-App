import 'package:sanad/core/networking/api_error_model.dart';
import '../data/models/home_response.dart';

sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeSuccess extends HomeState {
  final HomeResponse data;
  HomeSuccess(this.data);
}

final class HomeFailure extends HomeState {
  final ApiErrorModel error;
  HomeFailure(this.error);
}
