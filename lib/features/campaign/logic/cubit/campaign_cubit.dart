// lib/features/map/cubit/campaigns_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sanad/features/campaign/logic/cubit/campaign_state.dart';
import 'package:sanad/features/campaign/logic/repo_campaign.dart';
import 'package:sanad/features/campaign/model/campaign_mode.dart';


class CampaignsCubit extends Cubit<CampaignsState> {
  final CampaignsRepo _repo;

  CampaignsCubit(this._repo) : super(CampaignsInitial());

  Position? currentPosition;

  Future<void> loadCampaigns() async {
    emit(CampaignsLoading());
    try {
      // جيب الموقع والـ campaigns مع بعض
      await _getCurrentLocation();
      final campaigns = await _repo.getCampaigns();
      emit(CampaignsSuccess(campaigns));
    } catch (e) {
      emit(CampaignsError('فشل تحميل الحملات'));
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }
      if (permission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
        return;
      }

      currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      currentPosition = null;
    }
  }

  // احسب المسافة بين المستخدم والـ campaign
// احسب المسافة بين المستخدم والـ campaign
String getDistance(Campaign campaign) {  // ← Campaign مش CampaignModel
  if (currentPosition == null) return 'غير معروف';

  final meters = Geolocator.distanceBetween(
    currentPosition!.latitude,
    currentPosition!.longitude,
    campaign.location?.latitude ?? 0,   // ← من location مباشرة
    campaign.location?.longitude ?? 0,  // ← وضفنا ?? 0 لأن الـ model nullable
  );

  if (meters < 1000) return 'على بعد ${meters.toInt()} متر';
  return 'على بعد ${(meters / 1000).toStringAsFixed(1)} كم';
}

// هل المستخدم داخل النطاق؟
bool isWithinRange(Campaign campaign) {  // ← Campaign مش CampaignModel
  if (currentPosition == null) return false;

  final meters = Geolocator.distanceBetween(
    currentPosition!.latitude,
    currentPosition!.longitude,
    campaign.location?.latitude ?? 0,
    campaign.location?.longitude ?? 0,
  );

  return meters <= (campaign.attendance?.radiusMeters ?? 0);
}
}