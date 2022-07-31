import 'package:flutter_bloc/flutter_bloc.dart';

import '../../authentication/infrastructures/authentication_cubit.dart';
import '../../authentication/infrastructures/authentication_repository.dart';
import '../../orders/shared/cubit/selected_order_item_cubit.dart';
import '../../products/core/infrastructure/product_repository.dart';
import '../../products/shared/cubit/delete_product/delete_product_cubit.dart';
import '../../products/shared/cubit/fetch_product/fetch_products_cubit.dart';
import '../../products/shared/cubit/store_product/store_product_cubit.dart';
import '../../products/shared/cubit/update_product/update_product_cubit.dart';

class BlocsProvider {
  static List init() {
    return [
      BlocProvider<AuthenticationCubit>(
        create: (context) => AuthenticationCubit(
          context.read<AuthenticationRepository>(),
        ),
      ),
      BlocProvider<FetchProductsCubit>(
        create: (context) => FetchProductsCubit(
          context.read<ProductRepository>(),
        ),
      ),
      BlocProvider<StoreProductCubit>(
        create: (context) => StoreProductCubit(
          context.read<ProductRepository>(),
        ),
      ),
      BlocProvider<UpdateProductCubit>(
        create: (context) => UpdateProductCubit(
          context.read<ProductRepository>(),
        ),
      ),
      BlocProvider<DeleteProductCubit>(
        create: (context) => DeleteProductCubit(
          context.read<ProductRepository>(),
        ),
      ),
      BlocProvider<SelectedOrderItemCubit>(
        create: (context) => SelectedOrderItemCubit(),
      ),
    ];
  }
}
