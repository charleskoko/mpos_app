import 'package:dio/dio.dart';

import '../../authentication/infrastructures/authentication_local_service.dart';

class AuthenticationInterceptor extends Interceptor {
  final AuthenticationLocalService _authenticationLocalService;

  AuthenticationInterceptor(this._authenticationLocalService);
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final String? bearerToken =
        await _authenticationLocalService.readBearerToken();
    final modifiedOptions = options
      ..headers.addAll({'Authorization': 'Bearer $bearerToken'});

    handler.next(modifiedOptions);
  }
}
