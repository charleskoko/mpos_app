import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../../core/domain/fresh.dart';
import '../../../../core/infrastructures/network_exception.dart';
import '../../../core/domaine/product.dart';
import '../../../core/infrastructure/product_repository.dart';
part 'fetch_products_state.dart';

class FetchProductsCubit extends Cubit<FetchProductsState> {
  final ProductRepository _productRepository;
  FetchProductsCubit(this._productRepository) : super(FetchProductsInitial());

  Future<void> fetchProductList() async {
    emit(FetchProductsLoading());
    try {
      final fetchProductRequest = await _productRepository.fetchProductList();
      fetchProductRequest.fold(
        (fresh) {
          emit(FetchProductsLoaded(fresh));
        },
        (errorMessage) => emit(
          FetchProductsError(errorMessage.message),
        ),
      );
    } on RestApiException catch (exception) {
      emit(
        FetchProductsError(exception.message),
      );
    }
  }

  Future<void> filterProductsList(
      {required String text, required List<Product> products}) async {
    if (text.isEmpty) {
      fetchProductList();
    }
    emit(FetchProductsLoading());
    products = products
        .where(
          (product) => product.label!.toLowerCase().contains(
                text.toLowerCase(),
              ),
        )
        .toList();
    Fresh<List<Product>> productList = Fresh.yes(products);
    emit(FetchProductsLoaded(productList));
  }
}
