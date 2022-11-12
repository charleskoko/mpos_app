import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mpos_app/core/shared/dio_extension.dart';
import 'package:mpos_app/refund/core/domain/refund.dart';

import '../../../core/Environment/environement.dart';
import '../../../core/domain/remote_response.dart';
import '../../../core/infrastructures/network_exception.dart';

class RefundRemoteService {
  final Dio _dio;
  RefundRemoteService(this._dio);

  Future<RemoteResponse> store({required Map<String, dynamic> data}) async {
    Uri storeRefund = Environment.getUri(unencodedPath: 'api/v1/refund');
    try {
      final response = await _dio.postUri(storeRefund, data: jsonEncode(data));
      if (response.statusCode == 201) {
        Refund refund = Refund.fromJson(response.data['data'][0]);
        return ConnectionResponse<Refund>(refund);
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
}
