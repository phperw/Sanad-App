import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad/core/networking/api_result.dart';
import '../data/admin_repository.dart';

sealed class AdminAuthState {
  const AdminAuthState();
}

final class AdminAuthInitial extends AdminAuthState {
  const AdminAuthInitial();
}

final class AdminAuthLoading extends AdminAuthState {
  const AdminAuthLoading();
}

final class AdminAuthSuccess extends AdminAuthState {
  const AdminAuthSuccess(this.session);
  final AdminSession session;
}

final class AdminAuthFailure extends AdminAuthState {
  const AdminAuthFailure(this.message);
  final String message;
}

class AdminAuthCubit extends Cubit<AdminAuthState> {
  AdminAuthCubit(this._repository) : super(const AdminAuthInitial());

  final AdminRepository _repository;

  Future<void> login({required String email, required String password}) async {
    emit(const AdminAuthLoading());
    final result = await _repository.login(email: email, password: password);
    if (isClosed) return;
    switch (result) {
      case Success(:final data):
        emit(AdminAuthSuccess(data));
      case Failure(:final error):
        emit(AdminAuthFailure(error.message));
    }
  }
}
