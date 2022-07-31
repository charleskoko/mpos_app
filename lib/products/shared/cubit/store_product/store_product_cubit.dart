import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mpos_app/products/core/domaine/product.dart';
import '../../../core/infrastructure/product_repository.dart';
part 'store_product_state.dart';

class StoreProductCubit extends Cubit<StoreProductState> {
  final ProductRepository _productRepository;
  StoreProductCubit(this._productRepository) : super(StoreProductInitial());

  Future<void> storeProduct(Product product) async {
    emit(StoreProductLoading());
    final storeProductOrFailure = await _productRepository.storeNewProduct(
      label: product.label ?? '',
      price: product.price,
    );

    storeProductOrFailure.fold(
      (product) => emit(StoreProductStored(product)),
      (productError) => emit(StoreProductError(productError.message)),
    );
  }
}
