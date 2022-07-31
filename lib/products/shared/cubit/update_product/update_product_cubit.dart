import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../core/domaine/product.dart';
import '../../../core/infrastructure/product_repository.dart';

part 'update_product_state.dart';

class UpdateProductCubit extends Cubit<UpdateProductState> {
  final ProductRepository _productRepository;
  UpdateProductCubit(this._productRepository) : super(UpdateProductInitial());

  Future<void> updateProduct({
    required String label,
    required String productId,
    required double price,
  }) async {
    emit(UpdateProductLoading());
    final updatProductOrFailure = await _productRepository.updateProduct(
      label: label,
      price: price,
      productId: productId,
    );
    updatProductOrFailure.fold(
      (product) => emit(UpdateProductUpdated(product)),
      (errorMessage) => emit(
        UpdateProductError(errorMessage.message ?? ''),
      ),
    );
  }
}
