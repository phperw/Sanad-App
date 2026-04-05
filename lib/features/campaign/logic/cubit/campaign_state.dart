import 'package:sanad/features/campaign/model/campaign_mode.dart';

abstract class CampaignsState {}

class CampaignsInitial extends CampaignsState {}

class CampaignsLoading extends CampaignsState {}

class CampaignsSuccess extends CampaignsState {
  final List<Campaign> campaigns;
  CampaignsSuccess(this.campaigns);
}

class CampaignsError extends CampaignsState {
  final String message;
  CampaignsError(this.message);
}