import 'package:dio/dio.dart';
import 'package:mpos_app/core/shared/dio_extension.dart';
import '../../core/Environment/environement.dart';
import '../../core/domain/user.dart';
import '../../core/infrastructures/network_exception.dart';
import '../../core/domain/remote_response.dart';
import '../domain/credential.dart';

class AuthenticationRemoteService {
  final Dio _dio;
  AuthenticationRemoteService(
    this._dio,
  );

  Future<RemoteResponse> login({required Credential credential}) async {
    final loginUri = Environment.getUri(unencodedPath: '/api/v1/login');
    try {
      final response = await _dio.postUri(loginUri, data: credential.toJson());
      if (response.statusCode == 201) {
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
        if (error.response?.statusCode == 404) {
          throw RestApiException(404, 'Veuillez réessayer s\'il vous plait');
        }
        throw RestApiException(
            error.response?.statusCode, error.response?.data['message']);
      }
      rethrow;
    }
  }

  Future<RemoteResponse> register({required Credential credential}) async {
    final registrationUri =
        Environment.getUri(unencodedPath: '/api/v1/register');
    try {
      final response =
          await _dio.postUri(registrationUri, data: credential.toJson());
      if (response.statusCode == 201) {
        print(response);
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
          error.response?.statusCode,
          error.response?.data['message'],
        );
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
