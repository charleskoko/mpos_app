import 'package:dartz/dartz.dart';
import 'package:mpos_app/core/domain/fresh.dart';
import 'package:mpos_app/products/core/domaine/product.dart';
import 'package:mpos_app/products/core/infrastructure/product_local_service.dart';
import 'package:mpos_app/products/core/infrastructure/product_remote_service.dart';

import '../../../core/infrastructures/network_exception.dart';
import '../../../core/domain/remote_response.dart';
import '../domaine/product_error.dart';

class ProductRepository {
  final ProductRemoteService _productRemoteService;
  final ProductLocalService _productLocalService;
  ProductRepository(this._productRemoteService, this._productLocalService);

  Future<Either<Fresh<List<Product>>, ProductError>> fetchProductList() async {
    try {
      final productListRequestResponse =
          await _productRemoteService.fetchProductList();
      if (productListRequestResponse is ConnectionResponse) {
        List<Product> productList = productListRequestResponse.response;
        await _productLocalService.upsertProducts(productList);
        return left(Fresh.yes(productList));
      }
      if (productListRequestResponse is NotAuthorized) {
        return right(ProductError('not authorized'));
      }
      if (productListRequestResponse is NoConnection) {
        final productList = await _productLocalService.getProducts();
        return left(Fresh.no(productList));
      }
      return right(ProductError('unknown error'));
    } on RestApiException catch (exception) {
      return right(
        ProductError(exception.message ?? 'no error message'),
      );
    }
  }

  Future<Either<Product, ProductError>> storeNewProduct(
      {required String label, required price}) async {
    Product newProduct = Product(label: label, price: price);

    try {
      final storeNewProductRequestresponse =
          await _productRemoteService.storeNewProduct(newProduct);
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

    try {
      final updateProductrequestResponse =
          await _productRemoteService.updateProduct(
        request: newProduct,
        productId: productId,
      );
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
    try {
      final deleteProductRequestresponse =
          await _productRemoteService.deleteProduct(productId: productId);
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
