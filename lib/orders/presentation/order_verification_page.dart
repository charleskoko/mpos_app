import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import '../../core/presentation/snack_bar.dart';
import '../../core/shared/error_message.dart';
import '../../core/shared/mixin_validation.dart';
import '../../not_processed_order/shared/cubit/delete_not_processed_order_cubit.dart';
import '../../src/shared/app_colors.dart';
import '../../src/widgets/box_input_field.dart';
import '../core/domain/selected_order_item.dart';
import '../../not_processed_order/shared/cubit/fetch_not_processed_order_cubit.dart';
import '../shared/cubit/selected_order_item_cubit.dart';
import '../../not_processed_order/shared/cubit/store_not_processed_order_cubit.dart';
import '../shared/cubit/store_order_cubit.dart';
import '../../not_processed_order/shared/cubit/update_not_processed_order_cubit.dart';

class OrderVerificationPage extends StatefulWidget {
  const OrderVerificationPage({Key? key}) : super(key: key);

  @override
  State<OrderVerificationPage> createState() => _OrderVerificationPageState();
}

class _OrderVerificationPageState extends State<OrderVerificationPage>
    with ValidationMixin {
  TextEditingController inputTextController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'CAISSE',
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'Poppins-Regular',
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        leadingWidth: 80,
        leading: Container(
          margin: const EdgeInsets.only(
            left: 21,
            top: 10,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: const Color(0xFFEAEAEA)),
          ),
          height: 41,
          child: Center(
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Ionicons.chevron_back,
                color: kPrimaryColor,
              ),
            ),
          ),
        ),
        actions: [
          BlocListener<SelectedOrderItemCubit, SelectedOrderItemState>(
            listener: (context, selectedOrderItemState) {
              if (selectedOrderItemState.isOrderCanceled) {
                Navigator.pop(context);
                Fluttertoast.showToast(
                  gravity: ToastGravity.TOP,
                  backgroundColor: kPrimaryColor,
                  msg: 'La commande encours a été annulée avec succès',
                );
              }
              if (!selectedOrderItemState.isOrderCanceled) {
                Navigator.pop(context);
                Fluttertoast.showToast(
                  gravity: ToastGravity.TOP,
                  backgroundColor: kPrimaryColor,
                  msg: "l'action a été éffectué avec succès",
                );
                if (selectedOrderItemState.selectedOrderItem!.isEmpty) {
                  context.goNamed('main', params: {'tab': '2'});
                }
              }
            },
            child: IconButton(
              icon: const Icon(
                Ionicons.trash_outline,
                color: Colors.red,
                size: 30,
              ),
              onPressed: () {
                context.read<SelectedOrderItemCubit>().cancelCurrentSelection();
              },
            ),
          ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<UpdateNotProcessedOrderCubit,
              UpdateNotProcessedOrderState>(
            listener: (context, updateNotProcessedOrderState) {
              if (updateNotProcessedOrderState
                  is UpdateNotProcessedOrderLoaded) {
                context.read<FetchNotProcessedOrderCubit>().index();
                context.read<SelectedOrderItemCubit>().cancelCurrentSelection();
                context.goNamed('main', params: {'tab': '1'});
                // buidSnackbar(
                //     context: context,
                //     backgroundColor: Colors.green.shade100,
                //     text: 'La commande a été modifée avec succès');
              }
            },
          ),
          BlocListener<StoreNotProcessedOrderCubit,
              StoreNotProcessedOrderState>(
            listener: (context, storeNotProcessedOrderStateate) {
              if (storeNotProcessedOrderStateate
                  is StoreNotProcessedOrderLoaded) {
                // retouner a la page des commande en cours
                context.goNamed('main', params: {'tab': '1'});
                context.read<SelectedOrderItemCubit>().cancelCurrentSelection();
              }
            },
          ),
          BlocListener<StoreOrderCubit, StoreOrderState>(
            listener: (context, storeOrderState) {
              if (storeOrderState is StoreOrderLoaded) {
                Navigator.pop(context);
                context.read<SelectedOrderItemCubit>().cancelCurrentSelection();
                showGeneralDialog(
                    barrierColor: Colors.black.withOpacity(0.5),
                    transitionBuilder: (context, a1, a2, widget) {
                      return Transform.scale(
                        scale: a1.value,
                        child: Opacity(
                          opacity: a1.value,
                          child: AlertDialog(
                            contentPadding: EdgeInsets.zero,
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            content: SizedBox(
                                width: 325,
                                height: 313,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 100,
                                      width: 100,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: kPrimaryColor),
                                      child: const Center(
                                        child: Icon(
                                          Ionicons.checkmark,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                          ),
                        ),
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 200),
                    barrierDismissible: true,
                    barrierLabel: '',
                    context: context,
                    pageBuilder: (context, animation1, animation2) {
                      return Container();
                    });
              }
            },
          ),
        ],
        child: BlocListener<StoreOrderCubit, StoreOrderState>(
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
                              Container(
                                margin: const EdgeInsets.only(
                                  left: 21,
                                  right: 21,
                                  top: 15,
                                ),
                                width: MediaQuery.of(context).size.width,
                                height: 110,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade300,
                                      blurRadius: 2,
                                      spreadRadius: 2,
                                      offset:
                                          const Offset(1, 2), // Shadow position
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                left: 20, top: 20),
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              '${orderItems[index].product?.label!}',
                                              style: const TextStyle(
                                                fontFamily: 'Poppins-Light',
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                right: 10, top: 20),
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              'XOF ${orderItems[index].amount! * orderItems[index].price!}',
                                              style: const TextStyle(
                                                fontFamily: 'Poppins-bold',
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              orderItems[index].amount =
                                                  orderItems[index].amount! + 1;
                                            });
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                              left: 20,
                                              top: 20,
                                            ),
                                            width: 40,
                                            height: 40,
                                            decoration: const BoxDecoration(
                                              color: kPrimaryColor,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Center(
                                              child: Text(
                                                '+',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Poppins-bold',
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                            top: 20,
                                          ),
                                          width: 65,
                                          height: 30,
                                          child: Center(
                                            child: Text(
                                              ' ${orderItems[index].amount!}',
                                              style: const TextStyle(
                                                fontFamily: 'Poppins-bold',
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            if (orderItems[index].amount! > 1) {
                                              setState(() {
                                                orderItems[index].amount =
                                                    orderItems[index].amount! -
                                                        1;
                                              });
                                            }
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                              top: 20,
                                            ),
                                            width: 40,
                                            height: 40,
                                            decoration: const BoxDecoration(
                                              color: kPrimaryColor,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Center(
                                              child: Text(
                                                '-',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Poppins-bold',
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              showGeneralDialog(
                                                  barrierColor: Colors.black
                                                      .withOpacity(0.5),
                                                  transitionBuilder: (context,
                                                      a1, a2, widget) {
                                                    return Transform.scale(
                                                      scale: a1.value,
                                                      child: Opacity(
                                                        opacity: a1.value,
                                                        child: AlertDialog(
                                                          contentPadding:
                                                              EdgeInsets.zero,
                                                          shape: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.0)),
                                                          content: Container(
                                                            width: 325,
                                                            height: 313,
                                                            child: Stack(
                                                              children: [
                                                                Positioned(
                                                                    top: 5,
                                                                    left: 5,
                                                                    child: IconButton(
                                                                        onPressed: () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        icon: const Icon(
                                                                          Ionicons
                                                                              .close,
                                                                          size:
                                                                              30,
                                                                        ))),
                                                                Container(
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      top: 35),
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  child:
                                                                      const Icon(
                                                                    Ionicons
                                                                        .trash_outline,
                                                                    color:
                                                                        Color(
                                                                      0xFFEC5D5D,
                                                                    ),
                                                                    size: 60,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  child:
                                                                      const Center(
                                                                    child: Text(
                                                                      'Êtes-vous sûr de vouloir supprimer cet article de la caisse ?',
                                                                      style:
                                                                          TextStyle(
                                                                        color:
                                                                            kPrimaryColor,
                                                                        fontFamily:
                                                                            'Poppins-bold',
                                                                        fontSize:
                                                                            18,
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  bottom: 33,
                                                                  left: 49,
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      context
                                                                          .read<
                                                                              SelectedOrderItemCubit>()
                                                                          .removeItemFromList(
                                                                            itemToDelete:
                                                                                orderItems[index],
                                                                            selectedItemList:
                                                                                orderItems,
                                                                            isNotProcessedOrder:
                                                                                selectedOrderItemState.isNotProcessedOrder,
                                                                            notProcessedOrder:
                                                                                selectedOrderItemState.notProcessedOrder,
                                                                          );
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          227,
                                                                      height:
                                                                          54,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color:
                                                                            kPrimaryColor,
                                                                        borderRadius:
                                                                            BorderRadius.circular(15),
                                                                      ),
                                                                      child:
                                                                          const Center(
                                                                        child:
                                                                            Text(
                                                                          'Confirmer',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontFamily:
                                                                                'Poppins-bold',
                                                                            fontSize:
                                                                                18,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  transitionDuration: Duration(
                                                      milliseconds: 200),
                                                  barrierDismissible: true,
                                                  barrierLabel: '',
                                                  context: context,
                                                  pageBuilder: (context,
                                                      animation1, animation2) {
                                                    return Container();
                                                  });
                                            },
                                            child: Container(
                                              alignment: Alignment.centerRight,
                                              margin: const EdgeInsets.only(
                                                top: 20,
                                                right: 20,
                                              ),
                                              child: const Icon(
                                                Ionicons.close_circle_outline,
                                                color: Color(0xFFB8B8B8),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )),
                    ),
                  ],
                );
              }
              return Container();
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          BlocBuilder<SelectedOrderItemCubit, SelectedOrderItemState>(
        builder: (context, selectedOrderItemState) {
          double sum = 0;
          if (selectedOrderItemState.selectedOrderItem?.isNotEmpty ?? false) {
            selectedOrderItemState.selectedOrderItem!.forEach((element) {
              sum = sum + (element.price! * element.amount!);
            });
            return GestureDetector(
              onTap: () {
                showGeneralDialog(
                    barrierColor: Colors.black.withOpacity(0.5),
                    transitionBuilder: (context, a1, a2, widget) {
                      return Transform.scale(
                        scale: a1.value,
                        child: Opacity(
                          opacity: a1.value,
                          child: AlertDialog(
                            contentPadding: EdgeInsets.zero,
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            content: SizedBox(
                              width: 325,
                              height: 313,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (!selectedOrderItemState
                                      .isNotProcessedOrder)
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                        showGeneralDialog(
                                            barrierColor:
                                                Colors.black.withOpacity(0.5),
                                            transitionBuilder:
                                                (context, a1, a2, widget) {
                                              return Transform.scale(
                                                scale: a1.value,
                                                child: Opacity(
                                                  opacity: a1.value,
                                                  child: AlertDialog(
                                                    title: const Center(
                                                      child: Text(
                                                        'Entrez un nom',
                                                        style: TextStyle(
                                                          color: kPrimaryColor,
                                                          fontFamily:
                                                              'Poppins-bold',
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                    shape: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                    ),
                                                    content: SizedBox(
                                                      width: 325,
                                                      height: 200,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Form(
                                                            key: formKey,
                                                            child: Container(
                                                              margin: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      32),
                                                              child:
                                                                  BoxInputField
                                                                      .text(
                                                                controller:
                                                                    inputTextController,
                                                                hintText:
                                                                    'Nommez la Cmd',
                                                                validator:
                                                                    (text) {
                                                                  if (text
                                                                      .isEmpty) {
                                                                    return 'Veuillez entrer un nom valide';
                                                                  }
                                                                  return null;
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 17),
                                                          GestureDetector(
                                                            onTap: () {
                                                              if (formKey
                                                                  .currentState!
                                                                  .validate()) {
                                                                context
                                                                    .read<
                                                                        StoreNotProcessedOrderCubit>()
                                                                    .store(
                                                                      label: inputTextController
                                                                          .text,
                                                                      orderItems:
                                                                          selectedOrderItemState
                                                                              .selectedOrderItem!,
                                                                    );
                                                              }
                                                            },
                                                            child: Container(
                                                              width: 262,
                                                              height: 54,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    kPrimaryColor,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                              ),
                                                              child:
                                                                  const Center(
                                                                child: Text(
                                                                  'sauvegarder',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontFamily:
                                                                        'Poppins-bold',
                                                                    fontSize:
                                                                        18,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            transitionDuration: const Duration(
                                                milliseconds: 200),
                                            barrierDismissible: true,
                                            barrierLabel: '',
                                            context: context,
                                            pageBuilder: (context, animation1,
                                                animation2) {
                                              return Container();
                                            });
                                      },
                                      child: Container(
                                        width: 262,
                                        height: 54,
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: kPrimaryColor),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'Sauvegarder en cours',
                                            style: TextStyle(
                                              color: kPrimaryColor,
                                              fontFamily: 'Poppins-bold',
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (selectedOrderItemState
                                      .isNotProcessedOrder)
                                    GestureDetector(
                                      onTap: () {
                                        context
                                            .read<
                                                UpdateNotProcessedOrderCubit>()
                                            .updateNotProcessedOrder(
                                                selectedOrderItemState
                                                    .notProcessedOrder!);
                                      },
                                      child: Container(
                                        width: 262,
                                        height: 54,
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: kPrimaryColor),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'Actualiser la commande',
                                            style: TextStyle(
                                              color: kPrimaryColor,
                                              fontFamily: 'Poppins-bold',
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  const SizedBox(height: 22),
                                  GestureDetector(
                                    onTap: () {
                                      context.read<StoreOrderCubit>().store(
                                            selectedOrderItemState
                                                .selectedOrderItem!,
                                            isNotProcessedOrder:
                                                selectedOrderItemState
                                                    .isNotProcessedOrder,
                                            notProcessedOrder:
                                                selectedOrderItemState
                                                    .notProcessedOrder,
                                          );
                                      if (selectedOrderItemState
                                          .isNotProcessedOrder) {
                                        context
                                            .read<
                                                DeleteNotProcessedOrderCubit>()
                                            .delete(selectedOrderItemState
                                                .notProcessedOrder!);
                                        context
                                            .read<FetchNotProcessedOrderCubit>()
                                            .index(
                                              id: selectedOrderItemState
                                                  .notProcessedOrder!.id!,
                                            );
                                        return;
                                      }
                                      return;
                                    },
                                    child: Container(
                                      width: 262,
                                      height: 54,
                                      decoration: BoxDecoration(
                                        color: kPrimaryColor,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Encaisser',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Poppins-bold',
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    transitionDuration: Duration(milliseconds: 200),
                    barrierDismissible: true,
                    barrierLabel: '',
                    context: context,
                    pageBuilder: (context, animation1, animation2) {
                      return Container();
                    });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                height: 60,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color(0xFF262262),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          'XOF $sum',
                          style: const TextStyle(
                            fontFamily: 'Poppins-Bold',
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(right: 20),
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const [
                            Center(
                              child: Text(
                                'Continuer',
                                style: TextStyle(
                                  fontFamily: 'Poppins-Light',
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            Center(
                              child: Icon(
                                Ionicons.chevron_forward_outline,
                                size: 25,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
