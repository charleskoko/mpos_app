import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

import '../../core/shared/time_formater.dart';
import '../../src/shared/app_colors.dart';
import '../../src/widgets/box_loading.dart';
import '../../src/widgets/box_message.dart';
import '../core/domain/order.dart';
import '../shared/cubit/fetch_done_orders_cubit.dart';
import '../shared/cubit/order_details_cubit.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  @override
  void initState() {
    context.read<FetchDoneOrdersCubit>().fetchDoneOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(color: kPrimaryColor),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Transactions',
          style: TextStyle(
            fontSize: 22,
            fontFamily: 'Poppins-Regular',
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<FetchDoneOrdersCubit, FetchDoneOrdersState>(
          builder: (context, fetchDoneOrdersState) {
            if (fetchDoneOrdersState is FetchDoneOrdersError) {
              return BoxMessage(message: fetchDoneOrdersState.errorMessage);
            }
            if (fetchDoneOrdersState is FetchDoneOrdersLoaded) {
              List<OrderProduct> orders = fetchDoneOrdersState.fresh.entity;
              orders.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
              return (fetchDoneOrdersState.fresh.entity.isEmpty)
                  ? const BoxMessage(
                      message: "Vous n'avez aucune ventes enregistrées",
                    )
                  : Container(
                      margin: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                      ),
                      child: GroupedListView<dynamic, dynamic>(
                          elements: orders,
                          groupBy: (element) => DateFormat('yyyy MM dd')
                              .format(element.createdAt!),
                          groupSeparatorBuilder: (value) => Container(
                                alignment: Alignment.centerLeft,
                                height: 50,
                                margin: const EdgeInsets.only(top: 5),
                                child: Text(
                                  TimeFormater()
                                      .formatTransactionDate(value.toString()),
                                  style: const TextStyle(
                                    color: kPrimaryColor,
                                    fontFamily: 'Poppins-bold',
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                          itemBuilder: (BuildContext context, element) =>
                              GestureDetector(
                                onTap: () {
                                  context
                                      .read<OrderDetailsCubit>()
                                      .orderDetails(element);
                                  context.pushNamed(
                                    'orderDetails',
                                    params: {
                                      'tab': '2',
                                      'total': element
                                          .getOrderTotalFromListOrderLineItems
                                          .toString()
                                    },
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 10),
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
                                      borderRadius: BorderRadius.circular(10)),
                                  width: MediaQuery.of(context).size.width,
                                  height: 90,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 20,
                                        left: 10,
                                        child: Text(
                                          '#${element.number}',
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
                                          '${DateFormat('dd-MM-yyyy').format(element.createdAt!)} à ${DateFormat('HH:mm').format(element.createdAt!)}',
                                          style: const TextStyle(
                                            fontFamily: 'Poppins-Regular',
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 50,
                                        left: 10,
                                        child: Text(
                                          "Nombre d'article ${element.orderLineItems!.length}",
                                          style: const TextStyle(
                                            fontFamily: 'Poppins-Regular',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 50,
                                        right: 10,
                                        child: Text(
                                          "${element.getOrderTotalFromListOrderLineItems} FCFA",
                                          style: const TextStyle(
                                            fontFamily: 'Poppins-Regular',
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )));
            }
            return const BoxLoading();
          },
        ),
        // Fin de l'écran des commandes payées
      ),
    );
  }
}
