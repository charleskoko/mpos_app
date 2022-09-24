import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../not_processed_order/shared/cubit/fetch_not_processed_order_cubit.dart';
import '../../not_processed_order/shared/cubit/show_not_processed_order_cubit.dart';
import '../../src/shared/app_colors.dart';
import '../../src/widgets/box_loading.dart';
import '../../src/widgets/box_message.dart';
import '../../not_processed_order/core/domain/not_processed_order.dart';
import '../core/domain/order.dart';
import '../shared/cubit/fetch_done_orders_cubit.dart';
import '../shared/cubit/order_details_cubit.dart';

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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF5F5F5),
        title: const Text(
          'COMMANDES',
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'Poppins-Regular',
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 26,
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
                            message: fetchNotProcessedOrderState.errorMessage);
                      }
                      if (fetchNotProcessedOrderState
                          is FetchNotProcessedOrderLoaded) {
                        List<NotProcessedOrder> notProcessedOrders =
                            fetchNotProcessedOrderState.orders;
                        return Container(
                          margin: const EdgeInsets.only(
                            top: 24,
                            left: 16,
                            right: 16,
                          ),
                          child: (notProcessedOrders.isEmpty)
                              ? const BoxMessage(
                                  message:
                                      "Vous n'avez pas de commande en cours",
                                )
                              : ListView.builder(
                                  itemCount: notProcessedOrders.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        context
                                            .read<ShowNotProcessedOrderCubit>()
                                            .show(notProcessedOrders[index]);
                                        context.goNamed(
                                            'notProcessedOrderDetails');
                                      },
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
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
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 116,
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              top: 20,
                                              left: 10,
                                              child: Text(
                                                '${notProcessedOrders[index].label}',
                                                style: const TextStyle(
                                                  fontFamily: 'Poppins-Regular',
                                                  color: kPrimaryColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 20,
                                              right: 10,
                                              child: Text(
                                                DateFormat('HH:mm').format(
                                                    notProcessedOrders[index]
                                                        .createdAt!),
                                                style: const TextStyle(
                                                  fontFamily: 'Poppins-Regular',
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 65,
                                              left: 10,
                                              child: Text(
                                                "Nombre d'article ${notProcessedOrders[index].selectedOrderItem!.length}",
                                                style: const TextStyle(
                                                  fontFamily: 'Poppins-Regular',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 65,
                                              left: 160,
                                              child: Text(
                                                "XOF ${OrderProduct.getOrderTotalFromMapList(notProcessedOrders[index].selectedOrderItem!)}",
                                                style: const TextStyle(
                                                  fontFamily: 'Poppins-Regular',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 59,
                                              right: 10,
                                              child: Container(
                                                  width: 70,
                                                  height: 28,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    color: kPrimaryColor,
                                                  ),
                                                  child: const Center(
                                                    child: Text(
                                                      'En cours',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Poppins-Regular',
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  )),
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
                                message: "Vous n'avez pas de commande payé",
                              )
                            : Container(
                                margin: const EdgeInsets.only(
                                  top: 24,
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
                                        context.goNamed('orderDetails');
                                      },
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
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
                                                BorderRadius.circular(10)),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 116,
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              top: 20,
                                              left: 10,
                                              child: Text(
                                                '#${orders[index].number}',
                                                style: const TextStyle(
                                                  fontFamily: 'Poppins-Regular',
                                                  color: kPrimaryColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 20,
                                              right: 10,
                                              child: Text(
                                                DateFormat('HH:mm').format(
                                                    orders[index].createdAt!),
                                                style: const TextStyle(
                                                  fontFamily: 'Poppins-Regular',
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 65,
                                              left: 10,
                                              child: Text(
                                                "Nombre d'article ${orders[index].orderLineItems!.length}",
                                                style: const TextStyle(
                                                  fontFamily: 'Poppins-Regular',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 65,
                                              left: 160,
                                              child: Text(
                                                "XOF ${orders[index].getOrderTotalFromListOrderLineItems}",
                                                style: const TextStyle(
                                                  fontFamily: 'Poppins-Regular',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 59,
                                              right: 10,
                                              child: Container(
                                                  width: 68,
                                                  height: 28,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    color:
                                                        const Color(0xFF41D61C),
                                                  ),
                                                  child: const Center(
                                                    child: Text(
                                                      'Payé',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Poppins-Regular',
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  )),
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
                  // Fin de l'écran des commandes payées
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
