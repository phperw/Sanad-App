import 'api_error_model.dart';

sealed class ApiResult<T> {}

final class Success<T> extends ApiResult<T> {
  final T data;
  Success(this.data);
}

final class Failure<T> extends ApiResult<T> {
  final ApiErrorModel error;
  Failure(this.error);
}
