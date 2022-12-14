import 'package:dio/dio.dart';
import 'package:mpos_app/core/shared/dio_extension.dart';
import '../../../core/Environment/environement.dart';
import '../../../core/infrastructures/network_exception.dart';
import '../../../core/domain/remote_response.dart';
import '../domain/invoice.dart';

class InvoiceRemoteService {
  final Dio _dio;
  InvoiceRemoteService(this._dio);
  Future<RemoteResponse> fetchInvoiceList() async {
    final fetchProductListUri =
        Environment.getUri(unencodedPath: '/api/v1/invoices');
    try {
      final response = await _dio.getUri(fetchProductListUri);
      if (response.statusCode == 200) {
        final List<dynamic> invoiceListJson = response.data['data'][0];
        List<Invoice> invoiceList =
            invoiceListJson.map((json) => Invoice.fromJson(json)).toList();
        return ConnectionResponse<List<Invoice>>(invoiceList);
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
