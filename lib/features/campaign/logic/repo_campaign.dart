
import 'package:dio/dio.dart';
import 'package:sanad/features/campaign/model/campaign_mode.dart';


class CampaignsRepo {
  final Dio _dio;

  CampaignsRepo(this._dio);

  Future<List<Campaign>> getCampaigns() async {  // ← List<Campaign> مش List<CampaignModel>
    final response = await _dio.get(
      '/campaigns',
      queryParameters: {'page': 1, 'limit': 20},
    );
    final model = CampaignModel.fromJson(response.data);
    return model.campaigns; // ← ترجع الـ list مباشرة
  }
}