import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../core/infrastructure/product_repository.dart';
part 'delete_product_state.dart';

class DeleteProductCubit extends Cubit<DeleteProductState> {
  final ProductRepository _productRepository;
  DeleteProductCubit(this._productRepository) : super(DeleteProductInitial());

  Future<void> deleteProduct(String productId) async {
    emit(DeleteProductLoading());
    final deleteProductOrFaillure = await _productRepository.deleteProduct(
      productId: productId,
    );
    deleteProductOrFaillure.fold(
      (isDeleted) => emit(DeleteProductDeleted()),
      (deleteError) => emit(DeleteProductError(deleteError.message)),
    );
  }
}
