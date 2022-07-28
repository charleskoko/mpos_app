import 'package:dio/dio.dart';
import 'package:mpos_app/authentication/infrastructures/authentication_local_service.dart';
import 'package:mpos_app/core/shared/dio_extension.dart';
import '../../core/Environment/environement.dart';
import '../../core/domain/user.dart';
import '../../core/infrastructures/network_exception.dart';
import '../../core/infrastructures/remote_response.dart';
import '../domain/credential.dart';

class AuthenticationRemoteService {
  final Dio _dio;
  final AuthenticationLocalService _authenticationLocalService;
  AuthenticationRemoteService(
    this._dio,
    this._authenticationLocalService,
  );

  Future<RemoteResponse> login({required Credential credential}) async {
    final loginUri = Environment.getUri(unencodedPath: '/api/v1/login');
    try {
      final response = await _dio.postUri(loginUri, data: credential.toJson());
      if (response.statusCode == 201) {
        print(response.data['data']['token']);
        final User user = User.fromJson(response.data['data']['user']);
        final String? bearerToken = response.data['data']['token'];
        Map<String, dynamic> responseData = {
          'user': user,
          'token': bearerToken
        };

        return ConnectionResponse<Map<String, dynamic>>(responseData);
      }
      throw RestApiException(response.statusCode, response.statusMessage);
    } on DioError catch (error) {
      if (error.isNoConnectionError) {
        return NoConnection();
      }
      if (error.response?.statusCode != null) {
        throw RestApiException(
            error.response?.statusCode, error.response?.data['message']);
      }
      rethrow;
    }
  }

  Future<RemoteResponse> register({required Credential credential}) async {
    final registrationUri =
        Environment.getUri(unencodedPath: '/api/v1/registration');
    try {
      final response =
          await _dio.postUri(registrationUri, data: credential.toJson());
      if (response.statusCode == 201) {
        final User user = User.fromJson(response.data['user']);
        final String? bearerToken = response.data['token'];
        Map<String, dynamic> responseData = {
          'user': user,
          'token': bearerToken
        };

        return ConnectionResponse<Map<String, dynamic>>(responseData);
      }
      throw RestApiException(response.statusCode, response.statusMessage);
    } on DioError catch (error) {
      if (error.isNoConnectionError) {
        return NoConnection();
      }
      if (error.response?.statusCode != null) {
        throw RestApiException(
            error.response?.statusCode, error.response?.data['message']);
      }
      rethrow;
    }
  }

  Future<RemoteResponse> logout() async {
    final logoutUri = Environment.getUri(unencodedPath: '/api/v1/logout');
    try {
      final response = await _dio.postUri(logoutUri);
      if (response.statusCode == 204) {
        return ConnectionResponse<bool>(true);
      }
      throw RestApiException(response.statusCode, response.statusMessage);
    } on DioError catch (error) {
      if (error.isNoConnectionError) {
        return NoConnection();
      }
      if (error.response?.statusCode != null) {
        throw RestApiException(
            error.response?.statusCode, error.response?.data['message']);
      }
      rethrow;
    }
  }
}
