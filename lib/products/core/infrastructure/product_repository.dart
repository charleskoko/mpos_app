import 'package:dartz/dartz.dart';
import 'package:mpos_app/products/core/domaine/product.dart';
import 'package:mpos_app/products/core/infrastructure/product_remote_service.dart';

import '../../../core/infrastructures/network_exception.dart';
import '../../../core/infrastructures/remote_response.dart';
import '../domaine/product_error.dart';

class ProductRepository {
  final ProductRemoteService _productRemoteService;
  ProductRepository(this._productRemoteService);

  Future<Either<List<Product>, ProductError>> fetchProductList() async {
    final productListRequestResponse =
        await _productRemoteService.fetchProductList();
    try {
      if (productListRequestResponse is ConnectionResponse) {
        List<Product> productList = productListRequestResponse.response;
        return left(productList);
      } else if (productListRequestResponse is NotAuthorized) {
        return right(ProductError('not authorized'));
      } else {
        return right(ProductError('no connection'));
      }
    } on RestApiException catch (exception) {
      return right(
        ProductError(exception.message ?? 'no error message'),
      );
    }
  }

  Future<Either<Product, ProductError>> storeNewProduct(
      {required String label, required price}) async {
    Product newProduct = Product(label: label, price: price);
    final storeNewProductRequestresponse =
        await _productRemoteService.storeNewProduct(newProduct);
    try {
      if (storeNewProductRequestresponse is ConnectionResponse) {
        Product newStoredProduct = storeNewProductRequestresponse.response;
        return left(newStoredProduct);
      } else if (storeNewProductRequestresponse is NotAuthorized) {
        return right(ProductError('not authorized'));
      } else {
        return right(ProductError('no connection'));
      }
    } on RestApiException catch (exception) {
      return right(
        ProductError(exception.message ?? 'no error message'),
      );
    }
  }

  Future<Either<Product, ProductError>> updateProduct(
      {required String label,
      required double price,
      required String productId}) async {
    Product newProduct = Product(label: label, price: price);
    final updateProductrequestResponse =
        await _productRemoteService.updateProduct(
      request: newProduct,
      productId: productId,
    );
    try {
      if (updateProductrequestResponse is ConnectionResponse) {
        Product newUpdatedProduct = updateProductrequestResponse.response;
        return left(newUpdatedProduct);
      } else if (updateProductrequestResponse is NotAuthorized) {
        return right(ProductError('not authorized'));
      } else {
        return right(ProductError('no connection'));
      }
    } on RestApiException catch (exception) {
      return right(
        ProductError(exception.message ?? 'no error message'),
      );
    }
  }

  Future<Either<bool, ProductError>> deleteProduct({required productId}) async {
    final deleteProductRequestresponse =
        await _productRemoteService.deleteProduct(productId: productId);
    try {
      if (deleteProductRequestresponse is ConnectionResponse) {
        bool productDeleteResult = deleteProductRequestresponse.response;
        return left(productDeleteResult);
      } else if (deleteProductRequestresponse is NotAuthorized) {
        return right(ProductError('not authorized'));
      } else {
        return right(ProductError('no connection'));
      }
    } on RestApiException catch (exception) {
      return right(
        ProductError(exception.message ?? 'no error message'),
      );
    }
  }
}
