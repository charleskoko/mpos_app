import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mpos_app/orders/core/domain/order_line_item.dart';

import '../../core/shared/time_formater.dart';
import '../../src/shared/app_colors.dart';
import '../../src/widgets/box_button.dart';
import '../../src/widgets/box_input_field.dart';
import '../shared/cubit/order_details_cubit.dart';

class OrderDetails extends StatefulWidget {
  final double total;
  const OrderDetails({Key? key, required this.total}) : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  List<String> reasonArray = [
    'returned_item',
    'accidental_collection',
    'canceled_order',
    'other'
  ];
  TextEditingController paymentTextFieldController = TextEditingController();
  int selectedReason = 0;
  final formKey = GlobalKey<FormState>();
  bool isrefundFirstPage = true;
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
                height: 50,
                margin: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                ),
                child: TextButton(
                  child: const Text(
                    'Émettre remboursement',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins-light',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (BuildContext context, setState) =>
                              Container(
                            padding: const EdgeInsets.only(
                              top: 39,
                            ),
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10),
                                topLeft: Radius.circular(10),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade300,
                                  blurRadius: 2,
                                  spreadRadius: 2,
                                  offset: const Offset(1, 2), // Shadow position
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 30),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade300),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          if (isrefundFirstPage) {
                                            paymentTextFieldController.text =
                                                '';
                                            Navigator.pop(context);
                                            return;
                                          }
                                          setState(() {
                                            isrefundFirstPage = true;
                                            selectedReason = 0;
                                          });
                                        },
                                        icon: (isrefundFirstPage)
                                            ? Icon(Ionicons.close)
                                            : Icon(Ionicons.arrow_back),
                                      ),
                                      const Expanded(
                                        child: Center(
                                          child: Text(
                                            'Rembourser',
                                            style: TextStyle(
                                              fontFamily: 'Roboto-Regular',
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      (isrefundFirstPage)
                                          ? Container(
                                              color: kPrimaryColor,
                                              child: TextButton(
                                                onPressed: () {
                                                  if (formKey.currentState!
                                                      .validate()) {
                                                    setState(() {
                                                      isrefundFirstPage = false;
                                                    });
                                                  }
                                                },
                                                child: const Text(
                                                  'Suivant',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'Roboto-Regular',
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container(
                                              color: (selectedReason == 0)
                                                  ? Colors.grey.shade300
                                                  : kPrimaryColor,
                                              child: TextButton(
                                                onPressed: () {
                                                  if (selectedReason != 0) {
                                                    Map<String, dynamic> data =
                                                        {
                                                      'order_id':
                                                          orderDetailsState
                                                              .order!.id,
                                                      'amount_refunded':
                                                          double.tryParse(
                                                              paymentTextFieldController
                                                                  .text),
                                                      'reason': reasonArray[
                                                          selectedReason - 1]
                                                    };
                                                    print(data);
                                                  }
                                                },
                                                child: const Text(
                                                  'Remboursement',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'Roboto-Regular',
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            )
                                    ],
                                  ),
                                ),
                                (isrefundFirstPage)
                                    ? Form(
                                        key: formKey,
                                        child: Column(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                left: 21,
                                                right: 21,
                                              ),
                                              child: BoxInputField.number(
                                                autofocus: true,
                                                controller:
                                                    paymentTextFieldController,
                                                validator: (value) {
                                                  if (value.isEmpty) {
                                                    return 'Entrez un montant valide';
                                                  } else {
                                                    double? valueTodouble =
                                                        double.tryParse(value);
                                                    if (valueTodouble == null) {
                                                      return 'Entrez un montant valide';
                                                    }
                                                    if (valueTodouble! >
                                                        orderDetailsState.order!
                                                            .getOrderTotalFromListOrderLineItems) {
                                                      return 'Entrez un montant inferieur au montant de la commande';
                                                    }
                                                    return null;
                                                  }
                                                },
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              margin: const EdgeInsets.only(
                                                  top: 30),
                                              child: Text(
                                                'Le montant remboursable total est de ${orderDetailsState.order!.getOrderTotalFromListOrderLineItems} FCFA.',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto-light',
                                                  fontSize: 13,
                                                  color: Colors.grey.shade400,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              margin: const EdgeInsets.only(
                                                  top: 30),
                                              child: Text(
                                                "Le remboursement d'un montant peut entraîner des écarts dans vos stocks, vos rapport de ventes d'articles et vos soldes de cartes cadeaux.",
                                                style: TextStyle(
                                                  fontFamily: 'Roboto-light',
                                                  fontSize: 13,
                                                  color: Colors.grey.shade400,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    : Container(
                                        child: Column(
                                          children: [
                                            const SizedBox(height: 30),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 21, right: 21),
                                              alignment: Alignment.centerLeft,
                                              child: const Text(
                                                'REMBOURSEMENT À',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto-light',
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 21, right: 21),
                                              alignment: Alignment.centerLeft,
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  top: BorderSide(
                                                      color:
                                                          Colors.grey.shade300),
                                                  bottom: BorderSide(
                                                      color:
                                                          Colors.grey.shade300),
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: const Text(
                                                        'Espèces',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Roboto-bold',
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15),
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Text(
                                                        '${paymentTextFieldController.text} FCFA',
                                                        style: const TextStyle(
                                                          fontFamily:
                                                              'Roboto-bold',
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 30),
                                            Container(
                                              child: Text(
                                                'Veuillez vous assurer que votre processus de remboursement respecte la législation en vigueur.',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto-light',
                                                  fontSize: 13,
                                                  color: Colors.grey.shade400,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 21, left: 21, right: 21),
                                              alignment: Alignment.centerLeft,
                                              child: const Text(
                                                'MOTIF DU REMBOURSEMENT',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto-light',
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 10, left: 21, right: 21),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  top: BorderSide(
                                                      color:
                                                          Colors.grey.shade300),
                                                ),
                                              ),
                                              child: CheckboxListTile(
                                                title: const Text(
                                                  'Articles retournés',
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto-bold',
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                value: (selectedReason == 1),
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    selectedReason = 1;
                                                  });
                                                },
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 21, right: 21),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  top: BorderSide(
                                                      color:
                                                          Colors.grey.shade300),
                                                ),
                                              ),
                                              child: CheckboxListTile(
                                                title: const Text(
                                                  'Prélèvement accidentel',
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto-bold',
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                value: (selectedReason == 2),
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    selectedReason = 2;
                                                  });
                                                },
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 21, right: 21),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  top: BorderSide(
                                                      color:
                                                          Colors.grey.shade300),
                                                ),
                                              ),
                                              child: CheckboxListTile(
                                                title: const Text(
                                                  'Commande annulée',
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto-bold',
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                value: (selectedReason == 3),
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    (selectedReason = 3);
                                                  });
                                                },
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 21, right: 21),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  top: BorderSide(
                                                      color:
                                                          Colors.grey.shade300),
                                                  bottom: BorderSide(
                                                      color:
                                                          Colors.grey.shade300),
                                                ),
                                              ),
                                              child: CheckboxListTile(
                                                title: const Text(
                                                  'Autre',
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto-bold',
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                value: (selectedReason == 4),
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    selectedReason = 4;
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.grey.shade500),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade300,
                ),
                height: 50,
                margin: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                ),
                child: TextButton(
                    child: const Text(
                      'Nouveau reçu',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins-light',
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
                                '${orderLineItem.productLabel}',
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
