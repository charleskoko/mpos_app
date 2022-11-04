import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mpos_app/core/shared/dio_extension.dart';
import '../../../core/Environment/environement.dart';
import '../../../core/infrastructures/network_exception.dart';
import '../../../core/domain/remote_response.dart';
import '../domain/order.dart';

class OrderRemoteService {
  final Dio _dio;
  OrderRemoteService(this._dio);

  Future<RemoteResponse> indexOrder({String? selectedDate}) async {
    Uri orderIndexUri = Environment.getUri(
        unencodedPath: 'api/v1/orders',
        queryParameters: {'date': selectedDate});
    try {
      final response = await _dio.getUri(orderIndexUri);
      if (response.statusCode == 200) {
        final List<dynamic> orderJson = response.data['data'][0];
        List<OrderProduct> invoiceList =
            orderJson.map((json) => OrderProduct.fromJson(json)).toList();
        return ConnectionResponse<List<OrderProduct>>(invoiceList);
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

  Future<RemoteResponse> storeNewOrder(Map<String, dynamic> request) async {
    final storeProductUri = Environment.getUri(unencodedPath: '/api/v1/orders');
    print(jsonEncode(request));
    return ConnectionResponse<bool>(true);
    // try {
    //   final response =
    //       await _dio.postUri(storeProductUri, data: jsonEncode(request));
    //   if (response.statusCode == 201) {
    //     OrderProduct newOrder = OrderProduct.fromJson(response.data['data'][0]);

    //     return ConnectionResponse<OrderProduct>(newOrder);
    //   }
    //   throw RestApiException(response.statusCode, response.statusMessage);
    // } on DioError catch (error) {
    //   if (error.isNoConnectionError) {
    //     return NoConnection();
    //   }
    //   if (error.response?.statusCode != null) {
    //     if (error.response?.statusCode == 404) {
    //       throw RestApiException(404, 'Veuillez réessayer s\'il vous plait');
    //     }
    //     throw RestApiException(
    //         error.response?.statusCode, error.response?.data['message']);
    //   }
    //   rethrow;
    // }
  }
}
