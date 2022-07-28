import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../core/domaine/product.dart';
import '../../core/infrastructure/product_repository.dart';
part 'fetch_products_state.dart';

class FetchProductsCubit extends Cubit<FetchProductsState> {
  final ProductRepository _productRepository;
  FetchProductsCubit(this._productRepository) : super(FetchProductsInitial());

  Future<void> fetchProductList() async {
    final fetchProductRequest = await _productRepository.fetchProductList();
    fetchProductRequest.fold(
      (products) => emit(FetchProductsLoaded(products)),
      (errorMessage) => emit(
        FetchProductsError(errorMessage.message),
      ),
    );
  }
}
