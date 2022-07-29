import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mpos_app/core/shared/dio_extension.dart';
import '../../../core/Environment/environement.dart';
import '../../../core/infrastructures/network_exception.dart';
import '../../../core/infrastructures/remote_response.dart';
import '../domaine/product.dart';

class ProductRemoteService {
  final Dio _dio;
  ProductRemoteService(this._dio);
  Future<RemoteResponse> fetchProductList() async {
    final fetchProductListUri =
        Environment.getUri(unencodedPath: '/api/v1/products');
    try {
      final response = await _dio.getUri(fetchProductListUri);
      if (response.statusCode == 200) {
        final List<dynamic> productListJson = response.data['data'][0];
        List<Product> productList =
            productListJson.map((json) => Product.fromJson(json)).toList();
        return ConnectionResponse<List<Product>>(productList);
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

  Future<RemoteResponse> storeNewProduct(Product product) async {
    final storeProductUri =
        Environment.getUri(unencodedPath: '/api/v1/products');
    try {
      final response =
          await _dio.postUri(storeProductUri, data: jsonEncode(product));
      if (response.statusCode == 201) {
        Product newProduct = Product.fromJson(response.data['data'][0]);

        return ConnectionResponse<Product>(newProduct);
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

  Future<RemoteResponse> updateProduct(
      {required Product request, required String productId}) async {
    final storeProductUri =
        Environment.getUri(unencodedPath: '/api/v1/products/$productId');
    try {
      final response =
          await _dio.patchUri(storeProductUri, data: jsonEncode(request));
      if (response.statusCode == 200) {
        Product newProduct = Product.fromJson(response.data['data'][0]);

        return ConnectionResponse<Product>(newProduct);
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

  Future<RemoteResponse> deleteProduct({required String productId}) async {
    final storeProductUri =
        Environment.getUri(unencodedPath: '/api/v1/products/$productId');
    try {
      final response = await _dio.deleteUri(storeProductUri);
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
