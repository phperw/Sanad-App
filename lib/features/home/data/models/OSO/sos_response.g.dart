// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sos_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SosResponse _$SosResponseFromJson(Map<String, dynamic> json) => SosResponse(
  success: json['success'] as bool,
  message: json['message'] as String?,
  sosId: json['sos_id'] as String?,
);

Map<String, dynamic> _$SosResponseToJson(SosResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'sos_id': instance.sosId,
    };
