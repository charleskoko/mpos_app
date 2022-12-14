import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpos_app/orders/shared/cubit/fetch_done_orders_cubit.dart';
import 'package:mpos_app/orders/shared/cubit/order_details_cubit.dart';
import 'package:mpos_app/products/shared/cubit/show_product/show_product_cubit.dart';
import '../../authentication/infrastructures/authentication_cubit.dart';
import '../../authentication/infrastructures/authentication_repository.dart';
import '../../authentication/infrastructures/generate_reset_password_code_cubit.dart';
import '../../authentication/infrastructures/reset_password_cubit.dart';
import '../../custom_calendar/infrastructures/calendar_cubit.dart';
import '../../custom_calendar/infrastructures/calendar_repository_impl.dart';
import '../../dashboard/shared/cubit/dashboard_cubit.dart';
import '../../invoices/core/infrastructure/invoice_repository.dart';
import '../../invoices/shared/fetch_invoice_cubit.dart';
import '../../not_processed_order/shared/cubit/show_not_processed_order_cubit.dart';
import '../../orders/core/infrastructure/order_repository.dart';
import '../../not_processed_order/shared/cubit/delete_not_processed_order_cubit.dart';
import '../../not_processed_order/shared/cubit/fetch_not_processed_order_cubit.dart';
import '../../orders/shared/cubit/selected_order_item_cubit.dart';
import '../../not_processed_order/shared/cubit/store_not_processed_order_cubit.dart';
import '../../orders/shared/cubit/store_order_cubit.dart';
import '../../not_processed_order/shared/cubit/update_not_processed_order_cubit.dart';
import '../../products/core/infrastructure/product_repository.dart';
import '../../products/shared/cubit/delete_product/delete_product_cubit.dart';
import '../../products/shared/cubit/fetch_product/fetch_products_cubit.dart';
import '../../products/shared/cubit/store_product/store_product_cubit.dart';
import '../../products/shared/cubit/update_product/update_product_cubit.dart';
import '../../receipt/send_receipt_by_email/infrastructure/send_receipt_by_email_repository_impl.dart';
import '../../receipt/send_receipt_by_email/infrastructure/send_receipt_cubit.dart';
import '../../refund/core/infrastructure/refund_repository.dart';
import '../../refund/shared/cubit/refund_store_cubit.dart';

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
      // BlocProvider<SaleDetailsCubit>(
      //   create: (context) => SaleDetailsCubit(),
      // ),
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
      BlocProvider<ShowNotProcessedOrderCubit>(
        create: (context) => ShowNotProcessedOrderCubit(),
      ),
      BlocProvider<ShowProductCubit>(
        create: (context) => ShowProductCubit(),
      ),
      BlocProvider<GenerateResetPasswordCodeCubit>(
        create: (context) => GenerateResetPasswordCodeCubit(
            context.read<AuthenticationRepository>()),
      ),
      BlocProvider<ResetPasswordCubit>(
        create: (context) =>
            ResetPasswordCubit(context.read<AuthenticationRepository>()),
      ),
      BlocProvider<SendReceiptCubit>(
        create: (context) =>
            SendReceiptCubit(context.read<SendReceiptByEmailRepositoryImpl>()),
      ),
      BlocProvider<RefundStoreCubit>(
        create: (context) => RefundStoreCubit(context.read<RefundRepository>()),
      ),
    ];
  }
}
