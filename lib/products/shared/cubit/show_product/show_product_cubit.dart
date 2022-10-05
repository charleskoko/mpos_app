import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../core/domaine/product.dart';

part 'show_product_state.dart';

class ShowProductCubit extends Cubit<ShowProductState> {
  ShowProductCubit() : super(ShowProductState());

  Future<void> showProduct(Product product) async {
    emit(ShowProductState(product: product));
  }
}
