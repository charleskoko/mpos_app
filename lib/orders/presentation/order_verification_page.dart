import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mpos_app/src/widgets/box_button.dart';
import 'package:mpos_app/src/widgets/box_input_field.dart';
import 'package:mpos_app/src/widgets/box_text.dart';
import '../../core/presentation/snack_bar.dart';
import '../../core/shared/error_message.dart';
import '../../src/shared/app_colors.dart';
import '../../src/widgets/box_order_item.dart';
import '../core/domain/order.dart';
import '../core/domain/selected_order_item.dart';
import '../shared/cubit/fetch_not_processed_order_cubit.dart';
import '../shared/cubit/selected_order_item_cubit.dart';
import '../shared/cubit/store_not_processed_order_cubit.dart';
import '../shared/cubit/store_order_cubit.dart';
import '../shared/cubit/update_not_processed_order_cubit.dart';

class OrderVerificationPage extends StatefulWidget {
  const OrderVerificationPage({Key? key}) : super(key: key);

  @override
  State<OrderVerificationPage> createState() => _OrderVerificationPageState();
}

class _OrderVerificationPageState extends State<OrderVerificationPage> {
  TextEditingController inputTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: MultiBlocListener(
        listeners: [
          BlocListener<UpdateNotProcessedOrderCubit,
              UpdateNotProcessedOrderState>(
            listener: (context, updateNotProcessedOrderState) {
              if (updateNotProcessedOrderState
                  is UpdateNotProcessedOrderLoaded) {
                context.read<FetchNotProcessedOrderCubit>().index();
                context.read<SelectedOrderItemCubit>().cancelCurrentSelection();
                buidSnackbar(
                    context: context,
                    backgroundColor: Colors.green.shade100,
                    text: 'La commande a été modifée avec succès');
              }
            },
          ),
          BlocListener<StoreNotProcessedOrderCubit,
              StoreNotProcessedOrderState>(
            listener: (context, storeNotProcessedOrderStateate) {
              if (storeNotProcessedOrderStateate
                  is StoreNotProcessedOrderLoaded) {
                context.goNamed('main');
                context.read<SelectedOrderItemCubit>().cancelCurrentSelection();
                buidSnackbar(
                    context: context,
                    backgroundColor: Colors.green.shade100,
                    text: 'La commande a été sauvegardée avec succès');
              }
            },
          ),
          BlocListener<StoreOrderCubit, StoreOrderState>(
            listener: (context, storeOrderState) {
              if (storeOrderState is StoreOrderLoaded) {
                context.goNamed('saveOrderStatus');
                context.read<SelectedOrderItemCubit>().cancelCurrentSelection();
              }
            },
          ),
        ],
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScolled) => [
            SliverAppBar(
              title: BoxText.headingTwo(
                'Commande'.toUpperCase(),
                color: kThreeColor,
              ),
              centerTitle: true,
              iconTheme: const IconThemeData(
                color: kPrimaryColor, //change your color here
              ),
              actions: [
                BlocListener<SelectedOrderItemCubit, SelectedOrderItemState>(
                  listener: (context, selectedOrderItemState) {
                    if (selectedOrderItemState.isOrderCanceled) {
                      Navigator.pop(context);
                      buidSnackbar(
                        context: context,
                        backgroundColor: Colors.green,
                        text: 'La commande encours a été annulée avec succès',
                      );
                    }
                    if (!selectedOrderItemState.isOrderCanceled) {
                      Navigator.pop(context);
                    }
                  },
                  child: IconButton(
                    icon: const Icon(Ionicons.trash_outline),
                    onPressed: () {
                      context
                          .read<SelectedOrderItemCubit>()
                          .cancelCurrentSelection();
                    },
                  ),
                ),
              ],
              backgroundColor: Colors.grey.shade100,
              elevation: 0,
            )
          ],
          body: BlocListener<StoreOrderCubit, StoreOrderState>(
            listener: (context, storeOrderState) {
              if (storeOrderState is StoreOrderError) {
                buidSnackbar(
                  context: context,
                  backgroundColor: Colors.red,
                  text: ErrorMessage.errorMessages[storeOrderState.message] ??
                      'Une erreur a eu lieu. Veuillez réessayer',
                );
              }
            },
            child: BlocBuilder<SelectedOrderItemCubit, SelectedOrderItemState>(
              builder: (context, selectedOrderItemState) {
                List<SelectedOrderItem> orderItems =
                    selectedOrderItemState.selectedOrderItem ?? [];
                if (orderItems.isNotEmpty) {
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount:
                              selectedOrderItemState.selectedOrderItem?.length,
                          itemBuilder: (BuildContext context, index) =>
                              Dismissible(
                            key: Key(orderItems[index].product?.id ?? ''),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              context
                                  .read<SelectedOrderItemCubit>()
                                  .removeItemFromList(
                                    itemToDelete: orderItems[index],
                                    selectedItemList: orderItems,
                                  );
                            },
                            child: BoxOrderItem(
                                selectedOrderItem: orderItems[index],
                                onAdd: () {
                                  setState(() {
                                    orderItems[index].amount =
                                        orderItems[index].amount! + 1;
                                  });
                                },
                                onRemove: () {
                                  setState(() {
                                    if (orderItems[index].amount! > 1) {
                                      orderItems[index].amount =
                                          orderItems[index].amount! - 1;
                                    }
                                  });
                                }),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        color: Colors.white,
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const BoxText.headingThree('Total'),
                                  BoxText.headingThree(
                                      'FCFA ${OrderProduct.getOrderTotalFromMapList(orderItems)}')
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(children: [
                              Expanded(
                                child: BoxButton.changedColor(
                                  onTap: () {
                                    if (selectedOrderItemState
                                        .isNotProcessedOrder) {
                                      selectedOrderItemState.notProcessedOrder
                                          ?.selectedOrderItem = orderItems;
                                      context
                                          .read<UpdateNotProcessedOrderCubit>()
                                          .updateNotProcessedOrder(
                                            selectedOrderItemState
                                                .notProcessedOrder!,
                                          );
                                    }
                                    if (!selectedOrderItemState
                                        .isNotProcessedOrder) {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                            title: BoxText.headingTwo(
                                              'Intitulé',
                                              color: kPrimaryColor,
                                            ),
                                            content: BoxInputField.text(
                                              controller: inputTextController,
                                              onChanged: (value) {
                                                return null;
                                              },
                                              hintText: 'Table 1',
                                            ),
                                            actions: [
                                              TextButton(
                                                child: BoxText.body(
                                                  'Annuler',
                                                  color: Colors.grey.shade500,
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              TextButton(
                                                child:
                                                    BoxText.body('Enregistrer'),
                                                onPressed: () {
                                                  context
                                                      .read<
                                                          StoreNotProcessedOrderCubit>()
                                                      .store(
                                                        label:
                                                            inputTextController
                                                                .text,
                                                        orderItems: orderItems,
                                                      );
                                                },
                                              )
                                            ]),
                                      );
                                    }
                                  },
                                  title: (selectedOrderItemState
                                          .isNotProcessedOrder)
                                      ? 'Actualiser'
                                      : 'Sauvegarder',
                                  primaryColor: kSecondaryColor,
                                  darkColor: kSecondaryDarkColor,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: BlocBuilder<StoreOrderCubit,
                                    StoreOrderState>(
                                  builder: (context, storeOrderState) {
                                    return BoxButton.normal(
                                      title: 'Encaisser',
                                      isBusy:
                                          (storeOrderState is StoreOrderLoading)
                                              ? true
                                              : false,
                                      onTap: () {
                                        context.read<StoreOrderCubit>().store(
                                              orderItems,
                                              isNotProcessedOrder:
                                                  selectedOrderItemState
                                                      .isNotProcessedOrder,
                                              notProcessedOrder:
                                                  selectedOrderItemState
                                                      .notProcessedOrder,
                                            );
                                      },
                                    );
                                  },
                                ),
                              )
                            ])
                          ],
                        ),
                      )
                    ],
                  );
                }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }
}
