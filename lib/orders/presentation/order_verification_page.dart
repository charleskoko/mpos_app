import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mpos_app/src/widgets/box_text.dart';
import '../../src/shared/app_colors.dart';
import '../core/domain/order.dart';
import '../shared/cubit/selected_order_item_cubit.dart';
import '../shared/cubit/store_order_cubit.dart';

class OrderVerificationPage extends StatefulWidget {
  OrderVerificationPage({Key? key}) : super(key: key);

  @override
  State<OrderVerificationPage> createState() => _OrderVerificationPageState();
}

class _OrderVerificationPageState extends State<OrderVerificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScolled) => [
          SliverAppBar(
            title: BoxText.headingTwo(
              'Commande'.toUpperCase(),
              color: kThreeColor,
            ),
            iconTheme: const IconThemeData(
              color: kPrimaryColor, //change your color here
            ),
            actions: [
              IconButton(
                icon: Icon(Ionicons.trash_outline),
                onPressed: () {
                  Navigator.pop(context);
                  context
                      .read<SelectedOrderItemCubit>()
                      .cancelCurrentSelection();
                },
              )
            ],
            backgroundColor: Colors.grey.shade100,
            elevation: 0,
          )
        ],
        body: BlocBuilder<SelectedOrderItemCubit, SelectedOrderItemState>(
          builder: (context, selectedOrderItemState) {
            List<Map<String, dynamic>> orderItems =
                selectedOrderItemState.selectedOrderItem ?? [];
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount:
                          selectedOrderItemState.selectedOrderItem?.length,
                      itemBuilder: (BuildContext context, index) => Dismissible(
                            key: Key(orderItems[index]['product'].id),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              context
                                  .read<SelectedOrderItemCubit>()
                                  .removeItemFromList(
                                    itemToDelete: orderItems[index],
                                    selectedItemList: orderItems,
                                  );
                            },
                            child: ListTile(
                              title: BoxText.body(
                                '${orderItems[index]['product'].label ?? ''}',
                                fontWeight: FontWeight.bold,
                              ),
                              subtitle: BoxText.body(
                                '${orderItems[index]['product'].price ?? ''} XOF x ${orderItems[index]['amount']}',
                                color: Colors.grey.shade600,
                              ),
                              trailing: BoxText.body(
                                '${orderItems[index]['product'].price * orderItems[index]['amount']} XOF',
                                color: Colors.grey.shade600,
                              ),
                            ),
                          )),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const BoxText.headingThree('Total'),
                            BoxText.headingThree(
                                'XOF ${OrderProduct.getOrderTotal(orderItems)}')
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                context
                                    .read<StoreOrderCubit>()
                                    .store(orderItems);
                                context.goNamed('saveOrderStatus');
                              },
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: kSecondaryColor,
                                    ),
                                    height: 80,
                                    child: const Center(
                                      child: Icon(
                                        Ionicons.cash,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Center(
                                    child: BoxText.body('Payer'),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
