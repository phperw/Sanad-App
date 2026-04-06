// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sos_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SosSendRequestBody _$SosSendRequestBodyFromJson(Map<String, dynamic> json) =>
    SosSendRequestBody(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$SosSendRequestBodyToJson(SosSendRequestBody instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
