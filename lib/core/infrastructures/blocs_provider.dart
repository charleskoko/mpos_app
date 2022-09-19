import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpos_app/orders/shared/cubit/fetch_done_orders_cubit.dart';
import 'package:mpos_app/orders/shared/cubit/order_details_cubit.dart';

import '../../authentication/infrastructures/authentication_cubit.dart';
import '../../authentication/infrastructures/authentication_repository.dart';
import '../../custom_calendar/infrastructures/calendar_cubit.dart';
import '../../custom_calendar/infrastructures/calendar_repository_impl.dart';
import '../../dashboard/shared/cubit/dashboard_cubit.dart';
import '../../invoices/core/infrastructure/invoice_repository.dart';
import '../../invoices/shared/fetch_invoice_cubit.dart';
import '../../orders/core/infrastructure/order_repository.dart';
import '../../orders/shared/cubit/delete_not_processed_order_cubit.dart';
import '../../orders/shared/cubit/fetch_not_processed_order_cubit.dart';
import '../../orders/shared/cubit/selected_order_item_cubit.dart';
import '../../orders/shared/cubit/store_not_processed_order_cubit.dart';
import '../../orders/shared/cubit/store_order_cubit.dart';
import '../../orders/shared/cubit/update_not_processed_order_cubit.dart';
import '../../products/core/infrastructure/product_repository.dart';
import '../../products/shared/cubit/delete_product/delete_product_cubit.dart';
import '../../products/shared/cubit/fetch_product/fetch_products_cubit.dart';
import '../../products/shared/cubit/store_product/store_product_cubit.dart';
import '../../products/shared/cubit/update_product/update_product_cubit.dart';
import '../../sales/shared/sale_details_cubit.dart';

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
      BlocProvider<StoreOrderCubit>(
        create: (context) => StoreOrderCubit(
          context.read<OrderRepository>(),
        ),
      ),
      BlocProvider<FetchInvoiceCubit>(
        create: (context) => FetchInvoiceCubit(
          context.read<InvoiceRepository>(),
        ),
      ),
      BlocProvider<DashboardCubit>(
        create: (context) => DashboardCubit(
          context.read<OrderRepository>(),
        ),
      ),
      BlocProvider<SaleDetailsCubit>(
        create: (context) => SaleDetailsCubit(),
      ),
      BlocProvider<StoreNotProcessedOrderCubit>(
        create: (context) => StoreNotProcessedOrderCubit(
          context.read<OrderRepository>(),
        ),
      ),
      BlocProvider<FetchNotProcessedOrderCubit>(
        create: (context) => FetchNotProcessedOrderCubit(
          context.read<OrderRepository>(),
        ),
      ),
      BlocProvider<UpdateNotProcessedOrderCubit>(
        create: (context) => UpdateNotProcessedOrderCubit(
          context.read<OrderRepository>(),
        ),
      ),
      BlocProvider<DeleteNotProcessedOrderCubit>(
        create: (context) => DeleteNotProcessedOrderCubit(
          context.read<OrderRepository>(),
        ),
      ),
      BlocProvider<CalendarCubit>(
        create: (context) => CalendarCubit(
          context.read<CalendarRepositoryImpl>(),
        ),
      ),
      BlocProvider<FetchDoneOrdersCubit>(
        create: (context) => FetchDoneOrdersCubit(
          context.read<OrderRepository>(),
        ),
      ),
      BlocProvider<OrderDetailsCubit>(
        create: (context) => OrderDetailsCubit(),
      ),
    ];
  }
}
