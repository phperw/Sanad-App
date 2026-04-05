import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad/core/networking/api_result.dart';
import 'package:sanad/features/account/data/repo/get_users_card/account_repository.dart';
import 'account_state.dart';

class AccountCubitCard extends Cubit<AccountStateCard> {
  final AccountRepository _repository;

  AccountCubitCard(this._repository) : super(AccountInitial());

  Future<void> getProfile() async {
    emit(AccountLoadingCard());
    final result = await _repository.getProfile();

    switch (result) {
      case Success(:final data):
        emit(AccountSuccessCard(data));
      case Failure(:final error):
        emit(AccountFailureCard(error));
    }
  }
}
