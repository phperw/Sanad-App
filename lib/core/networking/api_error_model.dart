import 'package:json_annotation/json_annotation.dart';
part 'api_error_model.g.dart';

@JsonSerializable()
class ApiErrorModel {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? errors;

  const ApiErrorModel({required this.message, this.statusCode, this.errors});

  factory ApiErrorModel.fromJson(Map<String, dynamic> json) {
    final message = (json['message'] ?? json['error'] ?? 'حدث خطأ غير متوقع')
        .toString();
    return ApiErrorModel(
      message: message,
      statusCode: json['statusCode'] as int?,
      errors: json['errors'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() => _$ApiErrorModelToJson(this);
}
