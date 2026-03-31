import 'package:sanad/features/home/model/home_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final HomeModel homeModel;

  HomeSuccess(this.homeModel);
}

class HomeError extends HomeState {
  final String error;

  HomeError(this.error);
}