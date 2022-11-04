import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import '../../not_processed_order/shared/cubit/delete_not_processed_order_cubit.dart';
import '../../not_processed_order/shared/cubit/fetch_not_processed_order_cubit.dart';
import '../../src/shared/app_colors.dart';
import '../../src/widgets/box_loading.dart';
import '../../src/widgets/box_message.dart';
import '../../not_processed_order/core/domain/not_processed_order.dart';
import '../shared/cubit/selected_order_item_cubit.dart';
import '../shared/cubit/store_order_cubit.dart';

class OrdersOverviewPage extends StatefulWidget {
  const OrdersOverviewPage({Key? key}) : super(key: key);

  @override
  State<OrdersOverviewPage> createState() => _OrdersOverviewPageState();
}

class _OrdersOverviewPageState extends State<OrdersOverviewPage> {
  @override
  @override
  void initState() {
    context.read<FetchNotProcessedOrderCubit>().index();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          title: const Text(
            'Tickets ouvert',
            style: TextStyle(
              fontSize: 24,
              fontFamily: 'Poppins-Regular',
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<StoreOrderCubit, StoreOrderState>(
                listener: (context, state) {
              if (state is StoreOrderLoaded) {
                if (state.isNotProcessedOrder) {
                  Fluttertoast.showToast(
                    gravity: ToastGravity.TOP,
                    backgroundColor: kPrimaryColor,
                    msg: 'la commande a été clôturée avec succès',
                  );
                }
              }
            }),
            BlocListener<DeleteNotProcessedOrderCubit,
                    DeleteNotProcessedOrderState>(
                listener: (context, deleteNotProcessedOrderState) {
              if (deleteNotProcessedOrderState
                  is DeleteNotProcessedOrderLoaded) {
                Navigator.pop(context);
                Fluttertoast.showToast(
                  gravity: ToastGravity.TOP,
                  backgroundColor: kPrimaryColor,
                  msg: 'le ticket a été suprimé avec succès',
                );
                context.read<FetchNotProcessedOrderCubit>().index();
              }
            })
          ],
          child: BlocBuilder<FetchNotProcessedOrderCubit,
              FetchNotProcessedOrderState>(
            builder: (context, fetchNotProcessedOrderState) {
              if (fetchNotProcessedOrderState is FetchNotProcessedOrderError) {
                return BoxMessage(
                    message: fetchNotProcessedOrderState.errorMessage);
              }
              if (fetchNotProcessedOrderState is FetchNotProcessedOrderLoaded) {
                List<NotProcessedOrder> notProcessedOrders =
                    fetchNotProcessedOrderState.orders;
                return Container(
                  margin: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                  ),
                  child: (notProcessedOrders.isEmpty)
                      ? const BoxMessage(
                          message: "Vous n'avez pas de ticket sauvegardés",
                        )
                      : ListView.builder(
                          itemCount: notProcessedOrders.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                context
                                    .read<SelectedOrderItemCubit>()
                                    .updateSelectedItemState(
                                      notProcessedOrders[index]
                                          .selectedOrderItem!,
                                      isNotProcessedOrder: true,
                                      notProcessedOrder:
                                          notProcessedOrders[index],
                                    );
                                context.goNamed('main', params: {'tab': '0'});
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                  bottom: 10,
                                  top: 2,
                                ),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
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
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: MediaQuery.of(context).size.width,
                                height: 70,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          '${notProcessedOrders[index].label}',
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontFamily: 'Poppins-Regular',
                                            color: kPrimaryColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          '${DateFormat('dd-MM-yyyy').format(notProcessedOrders[index].createdAt!)} à ${DateFormat('HH:mm').format(notProcessedOrders[index].createdAt!)}',
                                          style: const TextStyle(
                                            fontFamily: 'Poppins-Regular',
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 30,
                                      child: IconButton(
                                        icon: Icon(Ionicons.close_circle),
                                        onPressed: () {
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
                                                                child:
                                                                    IconButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        icon:
                                                                            const Icon(
                                                                          Ionicons
                                                                              .close,
                                                                          size:
                                                                              30,
                                                                        ))),
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 35),
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              child: const Icon(
                                                                Ionicons
                                                                    .trash_outline,
                                                                color: Color(
                                                                  0xFFEC5D5D,
                                                                ),
                                                                size: 60,
                                                              ),
                                                            ),
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10,
                                                                      right:
                                                                          10),
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              child:
                                                                  const Center(
                                                                child: Text(
                                                                  'Êtes-vous sûr de vouloir supprimer ce ticket?',
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
                                                                          DeleteNotProcessedOrderCubit>()
                                                                      .delete(notProcessedOrders[
                                                                          index]);
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: 227,
                                                                  height: 54,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color:
                                                                        kPrimaryColor,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15),
                                                                  ),
                                                                  child:
                                                                      const Center(
                                                                    child: Text(
                                                                      'Confirmer',
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
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                              transitionDuration:
                                                  const Duration(
                                                      milliseconds: 200),
                                              barrierDismissible: true,
                                              barrierLabel: '',
                                              context: context,
                                              pageBuilder: (context, animation1,
                                                  animation2) {
                                                return Container();
                                              });
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                );
              }
              return const BoxLoading();
            },
          ),
        ),
      ),
    );
  }
}
