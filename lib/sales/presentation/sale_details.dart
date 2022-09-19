import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/shared/time_formater.dart';
import '../../orders/core/domain/order.dart';
import '../../orders/core/domain/order_line_item.dart';
import '../../src/shared/app_colors.dart';
import '../../src/widgets/box_text.dart';
import '../shared/sale_details_cubit.dart';

class SaleDetails extends StatefulWidget {
  const SaleDetails({Key? key}) : super(key: key);

  @override
  State<SaleDetails> createState() => _SaleDetailsState();
}

class _SaleDetailsState extends State<SaleDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: BlocBuilder<SaleDetailsCubit, SaleDetailsState>(
        builder: (context, saleDetailsState) {
          // List<OrderLineItem>? orderItems =
          //     saleDetailsState.invoice?.order?.orderLineItems;
          // OrderProduct? order = saleDetailsState.invoice?.order;
          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScolled) => [
              SliverAppBar(
                centerTitle: true,
                title: BoxText.headingTwo(
                  '#' + '122'.padLeft(10, '0'),
                  color: kThreeColor,
                ),
                iconTheme: const IconThemeData(
                  color: kPrimaryColor, //change your color here
                ),
                backgroundColor: Colors.grey.shade100,
                elevation: 0,
              )
            ],
            body: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 16),
                      alignment: Alignment.centerLeft,
                      child: BoxText.caption(
                        TimeFormater().dashboardDate(
                            saleDetailsState.invoice?.createdAt ??
                                DateTime.now()),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      alignment: Alignment.centerRight,
                      child: BoxText.caption(
                        'N°CMD: number}',
                      ),
                    )
                  ],
                ),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true, // and set this
                    itemCount: 2,
                    itemBuilder: (BuildContext context, index) {
                      // String? label = orderItems?[index].product?.label;
                      // double? amount = orderItems?[index].amount;
                      // double? price = orderItems?[index].price;
                      return Container(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: BoxText.body(
                                  'label',
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: BoxText.body(
                                  '122',
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              width: 50,
                              child: BoxText.body(
                                '2',
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: BoxText.body(
                          'SOMME (FCFA)',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        child: BoxText.body(
                          'getOrderTotalFromListOrderLineItems',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: BoxText.body(
                          'PAIEMENT EN ESPÈCES ',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      BoxText.body(
                        'getOrderTotalFromListOrderLineItems',
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 80,
                  color: Colors.grey.shade300,
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: BoxText.subheading(
                        'getOrderTotalFromListOrderLineItems'),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
