import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mpos_app/core/shared/dio_extension.dart';
import '../../../core/Environment/environement.dart';
import '../../../core/infrastructures/network_exception.dart';
import '../../../core/infrastructures/remote_response.dart';
import '../domain/order.dart';

class OrderRemoteService {
  final Dio _dio;
  OrderRemoteService(this._dio);

  Future<RemoteResponse> storeNewOrder(Map<String, dynamic> request) async {
    final storeProductUri = Environment.getUri(unencodedPath: '/api/v1/orders');
    try {
      final response =
          await _dio.postUri(storeProductUri, data: jsonEncode(request));
      if (response.statusCode == 201) {
        OrderProduct newOrder = OrderProduct.fromJson(response.data['data'][0]);

        return ConnectionResponse<OrderProduct>(newOrder);
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
