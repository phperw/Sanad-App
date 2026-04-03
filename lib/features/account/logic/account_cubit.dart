import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad/core/networking/api_result.dart';
import '../data/repo/account_repository.dart';
import 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  final AccountRepository _repository;

  AccountCubit(this._repository) : super(AccountInitial());

  Future<void> getProfile() async {
    emit(AccountLoading());
    final result = await _repository.getProfile();
    switch (result) {
      case Success(:final data):
        emit(AccountSuccess(data));
      case Failure(:final error):
        emit(AccountFailure(error));
    }
  }
}
