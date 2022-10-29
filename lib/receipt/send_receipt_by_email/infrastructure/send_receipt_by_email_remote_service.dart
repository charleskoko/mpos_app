import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:mpos_app/core/shared/dio_extension.dart';
import '../../../core/Environment/environement.dart';
import '../../../core/domain/remote_response.dart';
import '../../../core/infrastructures/network_exception.dart';

class SendReceiptByEmailRemoteService {
  final Dio _dio;
  SendReceiptByEmailRemoteService(
    this._dio,
  );
  Future<RemoteResponse> sendReceiptEmail(
      {required Map<String, dynamic> receiptData}) async {
    final resetPasswordUri = Environment.getUri(
        unencodedPath: '/api/v1/receipt-email/${receiptData['order_id']}');
    try {
      final response =
          await _dio.postUri(resetPasswordUri, data: jsonEncode(receiptData));
      if (response.statusCode == 200) {
        return ConnectionResponse<String>('password.reset_sucessfully');
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
}
