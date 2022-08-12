import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../../core/infrastructures/network_exception.dart';
import '../../../core/domaine/product.dart';
import '../../../core/infrastructure/product_repository.dart';
part 'delete_product_state.dart';

class DeleteProductCubit extends Cubit<DeleteProductState> {
  final ProductRepository _productRepository;
  DeleteProductCubit(this._productRepository) : super(DeleteProductInitial());

  Future<void> deleteProduct(Product product) async {
    emit(DeleteProductLoading());
    try {
      final deleteProductOrFaillure = await _productRepository.deleteProduct(
        product: product,
      );
      deleteProductOrFaillure.fold(
        (isDeleted) => emit(DeleteProductDeleted()),
        (deleteError) => emit(DeleteProductError(deleteError.message)),
      );
    } on RestApiException catch (exception) {
      emit(
        DeleteProductError(exception.message),
      );
    }
  }
}
