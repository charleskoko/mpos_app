import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mpos_app/orders/core/domain/order_line_item.dart';

import '../../core/shared/time_formater.dart';
import '../../src/shared/app_colors.dart';
import '../shared/cubit/order_details_cubit.dart';

class OrderDetails extends StatefulWidget {
  final double total;
  const OrderDetails({Key? key, required this.total}) : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'Vente de ${widget.total} FCFA',
            style: const TextStyle(
              fontSize: 22,
              fontFamily: 'Poppins-Regular',
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: const BackButton(color: kPrimaryColor)),
      body: BlocBuilder<OrderDetailsCubit, OrderDetailsState>(
        builder: (context, orderDetailsState) {
          List<OrderLineItem>? orderItems =
              orderDetailsState.order!.orderLineItems;
          return ListView(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.grey.shade500),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade300,
                ),
                height: 60,
                margin: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                ),
                child: TextButton(
                    child: const Text(
                      'Nouveau reçu',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins-Regular',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {
                      context.pushNamed('receiptOptions', params: {
                        'tab': '1',
                        'orderId': orderDetailsState.order!.id!,
                        'sum':
                            '${orderDetailsState.order!.getOrderTotalFromListOrderLineItems}',
                        'cash':
                            '${orderDetailsState.order!.getOrderTotalFromListOrderLineItems}',
                        'origin': 'transactionPage'
                      });
                    }),
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 29,
                  left: 21,
                ),
                child: const Text(
                  'Articles',
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins-Regular',
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 16, right: 16, top: 10),
                child: Wrap(
                  children: [
                    for (OrderLineItem orderLineItem in orderItems!)
                      Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 17,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 2,
                              spreadRadius: 2,
                              offset: const Offset(1, 2), // Shadow position
                            ),
                          ],
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: 78,
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${orderLineItem.product?.label}',
                                style: const TextStyle(
                                  fontFamily: 'Poppins-Regular',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '(${orderLineItem.amount}) x ${orderLineItem.price} FCFA',
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      '${orderLineItem.amount * orderLineItem.price} FCFA',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 2,
                      spreadRadius: 2,
                      offset: const Offset(1, 2), // Shadow position
                    ),
                  ],
                ),
                margin: const EdgeInsets.only(
                  top: 24,
                  left: 16,
                  right: 16,
                ),
                width: MediaQuery.of(context).size.width,
                height: 125,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 17,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                'Total des articles',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Poppins-Regular',
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '${orderDetailsState.order!.getOrderTotalFromListOrderLineItems} FCFA',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Poppins-Regular',
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 11),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                'Impôts et taxes',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Poppins-Regular',
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: const Text(
                                '00 FCFA',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Poppins-Regular',
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                'Total à payer',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Poppins-Regular',
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '${orderDetailsState.order!.getOrderTotalFromListOrderLineItems} FCFA',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Poppins-Regular',
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(top: 23, left: 23, right: 23),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Détails de la commande',
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Poppins-Regular',
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Divider(color: Color(0xFFDBDBDB), thickness: 0.5),
                      const SizedBox(height: 24),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'NUMÉR0 DE COMMANDE:',
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Poppins-Regular',
                            // ignore: unnecessary_const
                            color: const Color(0xff59677cbf),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${orderDetailsState.order?.number}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontFamily: 'Poppins-Regular',
                            // ignore: unnecessary_const
                            color: Color(0xFF59677C),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'PAIEMENT:',
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Poppins-Regular',
                            // ignore: unnecessary_const
                            color: const Color(0xff59677cbf),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Payé : En espèces',
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Poppins-Regular',
                            // ignore: unnecessary_const
                            color: Color(0xFF59677C),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'DATE:',
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Poppins-Regular',
                            // ignore: unnecessary_const
                            color: const Color(0xff59677cbf),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          ' ${TimeFormater().formatDateForOrderDetails(orderDetailsState.order!.createdAt)}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontFamily: 'Poppins-Regular',
                            // ignore: unnecessary_const
                            color: Color(0xFF59677C),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'NUMÉRO DE FACTURE:',
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Poppins-Regular',
                            // ignore: unnecessary_const
                            color: const Color(0xff59677cbf),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${orderDetailsState.order?.invoice?.number}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontFamily: 'Poppins-Regular',
                            // ignore: unnecessary_const
                            color: Color(0xFF59677C),
                          ),
                        ),
                      ),
                    ],
                  ))
            ],
          );
        },
      ),
    );
  }
}
