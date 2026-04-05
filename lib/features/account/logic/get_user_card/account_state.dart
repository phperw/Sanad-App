import 'package:sanad/core/networking/api_error_model.dart';
import '../../data/models/get_user_card/profile_response.dart';

sealed class AccountStateCard {}

final class AccountInitial extends AccountStateCard {}

final class AccountLoadingCard extends AccountStateCard {}

final class AccountSuccessCard extends AccountStateCard {
  final ProfileResponse data;
  AccountSuccessCard(this.data);
}

final class AccountFailureCard extends AccountStateCard {
  final ApiErrorModel error;
  AccountFailureCard(this.error);
}
