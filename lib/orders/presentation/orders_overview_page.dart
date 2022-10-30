import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import '../../not_processed_order/shared/cubit/delete_not_processed_order_cubit.dart';
import '../../not_processed_order/shared/cubit/fetch_not_processed_order_cubit.dart';
import '../../not_processed_order/shared/cubit/show_not_processed_order_cubit.dart';
import '../../src/shared/app_colors.dart';
import '../../src/widgets/box_loading.dart';
import '../../src/widgets/box_message.dart';
import '../../not_processed_order/core/domain/not_processed_order.dart';
import '../core/domain/order.dart';
import '../shared/cubit/fetch_done_orders_cubit.dart';
import '../shared/cubit/order_details_cubit.dart';
import '../shared/cubit/selected_order_item_cubit.dart';
import '../shared/cubit/store_order_cubit.dart';

class OrdersOverviewPage extends StatefulWidget {
  const OrdersOverviewPage({Key? key}) : super(key: key);

  @override
  State<OrdersOverviewPage> createState() => _OrdersOverviewPageState();
}

class _OrdersOverviewPageState extends State<OrdersOverviewPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  void initState() {
    context.read<FetchDoneOrdersCubit>().fetchDoneOrders();
    context.read<FetchNotProcessedOrderCubit>().index();
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: const Color(0xFFF5F5F5),
          title: const Text(
            'Transactions',
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
                  msg: 'la commande a été suprimée avec succès',
                );
                context.read<FetchNotProcessedOrderCubit>().index();
              }
            })
          ],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 26,
                    vertical: 10,
                  ),
                  padding: const EdgeInsets.all(
                    3,
                  ),
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(
                      25.0,
                    ),
                    border: Border.all(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    // give the indicator a decoration (color and border radius)
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        25.0,
                      ),
                      color: const Color(0xFFFFD051),
                    ),
                    labelColor: kPrimaryColor,
                    labelStyle: const TextStyle(
                      fontFamily: 'Poppins-Regular',
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    unselectedLabelColor: Colors.grey.shade500,
                    tabs: const [
                      Tab(
                        text: 'En cours',
                      ),
                      Tab(
                        text: 'Payé',
                      ),
                    ],
                  ),
                ),
                // tab bar view here
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      BlocBuilder<FetchNotProcessedOrderCubit,
                          FetchNotProcessedOrderState>(
                        builder: (context, fetchNotProcessedOrderState) {
                          if (fetchNotProcessedOrderState
                              is FetchNotProcessedOrderError) {
                            return BoxMessage(
                                message:
                                    fetchNotProcessedOrderState.errorMessage);
                          }
                          if (fetchNotProcessedOrderState
                              is FetchNotProcessedOrderLoaded) {
                            List<NotProcessedOrder> notProcessedOrders =
                                fetchNotProcessedOrderState.orders;
                            return Container(
                              margin: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                              ),
                              child: (notProcessedOrders.isEmpty)
                                  ? const BoxMessage(
                                      message:
                                          "Vous n'avez pas ticket sauvegardés",
                                    )
                                  : ListView.builder(
                                      itemCount: notProcessedOrders.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
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
                                            context.goNamed('main',
                                                params: {'tab': '2'});
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 10),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.shade300,
                                                  blurRadius: 2,
                                                  spreadRadius: 2,
                                                  offset: const Offset(
                                                      1, 2), // Shadow position
                                                ),
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 90,
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  top: 20,
                                                  left: 10,
                                                  child: Text(
                                                    '${notProcessedOrders[index].label}',
                                                    style: const TextStyle(
                                                      fontFamily:
                                                          'Poppins-Regular',
                                                      color: kPrimaryColor,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 20,
                                                  right: 10,
                                                  child: Text(
                                                    '${DateFormat('dd-mm-yyyy').format(notProcessedOrders[index].createdAt!)} à ${DateFormat('HH:mm').format(notProcessedOrders[index].createdAt!)}',
                                                    style: const TextStyle(
                                                      fontFamily:
                                                          'Poppins-Regular',
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 65,
                                                  left: 10,
                                                  child: Text(
                                                    "${notProcessedOrders[index].selectedOrderItem!.length} article(s) ",
                                                    style: const TextStyle(
                                                      fontFamily:
                                                          'Poppins-Regular',
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 59,
                                                  right: 10,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      showGeneralDialog(
                                                          barrierColor: Colors
                                                              .black
                                                              .withOpacity(0.5),
                                                          transitionBuilder:
                                                              (context, a1, a2,
                                                                  widget) {
                                                            return Transform
                                                                .scale(
                                                              scale: a1.value,
                                                              child: Opacity(
                                                                opacity:
                                                                    a1.value,
                                                                child:
                                                                    AlertDialog(
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  shape: OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15.0)),
                                                                  content:
                                                                      Container(
                                                                    width: 325,
                                                                    height: 313,
                                                                    child:
                                                                        Stack(
                                                                      children: [
                                                                        Positioned(
                                                                            top:
                                                                                5,
                                                                            left:
                                                                                5,
                                                                            child: IconButton(
                                                                                onPressed: () {
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                icon: const Icon(
                                                                                  Ionicons.close,
                                                                                  size: 30,
                                                                                ))),
                                                                        Container(
                                                                          margin:
                                                                              const EdgeInsets.only(top: 35),
                                                                          width: MediaQuery.of(context)
                                                                              .size
                                                                              .width,
                                                                          child:
                                                                              const Icon(
                                                                            Ionicons.trash_outline,
                                                                            color:
                                                                                Color(
                                                                              0xFFEC5D5D,
                                                                            ),
                                                                            size:
                                                                                60,
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          margin: const EdgeInsets.only(
                                                                              left: 10,
                                                                              right: 10),
                                                                          width: MediaQuery.of(context)
                                                                              .size
                                                                              .width,
                                                                          child:
                                                                              const Center(
                                                                            child:
                                                                                Text(
                                                                              'Êtes-vous sûr de vouloir supprimer ce ticket?',
                                                                              style: TextStyle(
                                                                                color: kPrimaryColor,
                                                                                fontFamily: 'Poppins-bold',
                                                                                fontSize: 18,
                                                                              ),
                                                                              textAlign: TextAlign.center,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Positioned(
                                                                          bottom:
                                                                              33,
                                                                          left:
                                                                              49,
                                                                          child:
                                                                              GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              context.read<DeleteNotProcessedOrderCubit>().delete(notProcessedOrders[index]);
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              width: 227,
                                                                              height: 54,
                                                                              decoration: BoxDecoration(
                                                                                color: kPrimaryColor,
                                                                                borderRadius: BorderRadius.circular(15),
                                                                              ),
                                                                              child: const Center(
                                                                                child: Text(
                                                                                  'Confirmer',
                                                                                  style: TextStyle(
                                                                                    color: Colors.white,
                                                                                    fontFamily: 'Poppins-bold',
                                                                                    fontSize: 18,
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
                                                              Duration(
                                                                  milliseconds:
                                                                      200),
                                                          barrierDismissible:
                                                              true,
                                                          barrierLabel: '',
                                                          context: context,
                                                          pageBuilder: (context,
                                                              animation1,
                                                              animation2) {
                                                            return Container();
                                                          });
                                                    },
                                                    child: const SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                      child: Center(
                                                        child: Icon(Ionicons
                                                            .close_circle_outline),
                                                      ),
                                                    ),
                                                  ),
                                                ),
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
                      // Début de l'écran des commandes payées
                      BlocBuilder<FetchDoneOrdersCubit, FetchDoneOrdersState>(
                        builder: (context, fetchDoneOrdersState) {
                          if (fetchDoneOrdersState is FetchDoneOrdersError) {
                            return BoxMessage(
                                message: fetchDoneOrdersState.errorMessage);
                          }
                          if (fetchDoneOrdersState is FetchDoneOrdersLoaded) {
                            List<OrderProduct> orders =
                                fetchDoneOrdersState.fresh.entity;
                            orders.sort(
                                (a, b) => b.createdAt!.compareTo(a.createdAt!));
                            return (fetchDoneOrdersState.fresh.entity.isEmpty)
                                ? const BoxMessage(
                                    message:
                                        "Vous n'avez pas de ventes enregistrées",
                                  )
                                : Container(
                                    margin: const EdgeInsets.only(
                                      left: 16,
                                      right: 16,
                                    ),
                                    child: ListView.builder(
                                      itemCount: orders.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: () {
                                            context
                                                .read<OrderDetailsCubit>()
                                                .orderDetails(orders[index]);
                                            context.goNamed(
                                              'orderDetails',
                                              params: {
                                                'tab': '1',
                                                'total': orders[index]
                                                    .getOrderTotalFromListOrderLineItems
                                                    .toString()
                                              },
                                            );
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 10),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey.shade300,
                                                    blurRadius: 2,
                                                    spreadRadius: 2,
                                                    offset: const Offset(1,
                                                        2), // Shadow position
                                                  ),
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 90,
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  top: 20,
                                                  left: 10,
                                                  child: Text(
                                                    '#${orders[index].number}',
                                                    style: const TextStyle(
                                                      fontFamily:
                                                          'Poppins-Regular',
                                                      color: kPrimaryColor,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 20,
                                                  right: 10,
                                                  child: Text(
                                                    '${DateFormat('dd-mm-yyyy').format(orders[index].createdAt!)} à ${DateFormat('HH:mm').format(orders[index].createdAt!)}',
                                                    style: const TextStyle(
                                                      fontFamily:
                                                          'Poppins-Regular',
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 50,
                                                  left: 10,
                                                  child: Text(
                                                    "Nombre d'article ${orders[index].orderLineItems!.length}",
                                                    style: const TextStyle(
                                                      fontFamily:
                                                          'Poppins-Regular',
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 50,
                                                  right: 10,
                                                  child: Text(
                                                    "${orders[index].getOrderTotalFromListOrderLineItems} FCFA",
                                                    style: const TextStyle(
                                                      fontFamily:
                                                          'Poppins-Regular',
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
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
                      // Fin de l'écran des commandes payées
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
