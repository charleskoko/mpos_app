import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mpos_app/orders/core/domain/not_processed_order.dart';
import 'package:mpos_app/orders/shared/cubit/selected_order_item_cubit.dart';

import '../../src/shared/app_colors.dart';
import '../../src/widgets/box_loading.dart';
import '../../src/widgets/box_message.dart';
import '../../src/widgets/box_text.dart';
import '../shared/cubit/fetch_not_processed_order_cubit.dart';

class NotProcessedOrderPage extends StatefulWidget {
  const NotProcessedOrderPage({Key? key}) : super(key: key);

  @override
  State<NotProcessedOrderPage> createState() => _NotProcessedOrderPageState();
}

class _NotProcessedOrderPageState extends State<NotProcessedOrderPage> {
  @override
  void initState() {
    super.initState();
    context.read<FetchNotProcessedOrderCubit>().index();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          title: BoxText.headingTwo(
            'Sauvegardes'.toUpperCase(),
            color: kThreeColor,
          ),
        ),
        body: BlocBuilder<FetchNotProcessedOrderCubit,
            FetchNotProcessedOrderState>(
          builder: (context, fetchNotProcessedOrderState) {
            if (fetchNotProcessedOrderState is FetchNotProcessedOrderLoaded) {
              return Container(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: ListView.separated(
                    itemCount: fetchNotProcessedOrderState.orders.length,
                    itemBuilder: (BuildContext context, index) => ListTile(
                      title: BoxText.body(
                        fetchNotProcessedOrderState.orders[index].label ?? '',
                        fontWeight: FontWeight.bold,
                      ),
                      trailing: BoxText.body(
                        DateFormat("yyyy-MM-dd").format(
                          fetchNotProcessedOrderState.orders[index].createdAt ??
                              DateTime.now(),
                        ),
                      ),
                      subtitle: BoxText.body(
                        '${determineOrderTotalPrice(fetchNotProcessedOrderState.orders[index])} XOF',
                        color: Colors.grey.shade700,
                      ),
                      onTap: () {
                        context
                            .read<SelectedOrderItemCubit>()
                            .updateSelectedItemState(
                              fetchNotProcessedOrderState
                                      .orders[index].selectedOrderItem ??
                                  [],
                              isNotProcessedOrder: true,
                              notProcessedOrder:
                                  fetchNotProcessedOrderState.orders[index],
                            );
                        context.goNamed('orderVerification');
                      },
                    ),
                    separatorBuilder: (context, index) {
                      return const Divider(
                        color: kPrimaryColor,
                      );
                    },
                  ));
            }
            if (fetchNotProcessedOrderState is FetchNotProcessedOrderError) {
              return BoxMessage(
                message: fetchNotProcessedOrderState.errorMessage,
              );
            }
            return const BoxLoading();
          },
        ));
  }

  String determineOrderTotalPrice(NotProcessedOrder order) {
    double orderTotalPrice = 0;

    order.selectedOrderItem?.forEach((element) {
      double orderLineItemTotalPrice = element.price ?? 0 * element.amount!;
      orderTotalPrice = orderTotalPrice + orderLineItemTotalPrice;
    });

    return '$orderTotalPrice';
  }
}
