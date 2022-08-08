import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

import '../../core/shared/time_formater.dart';
import '../../invoices/core/domain/invoice.dart';
import '../../orders/core/domain/order.dart';
import '../../orders/core/domain/order_line_item.dart';
import '../../src/shared/app_colors.dart';
import '../../src/widgets/box_text.dart';
import '../shared/sale_details_cubit.dart';

class SaleDetails extends StatefulWidget {
  SaleDetails({Key? key}) : super(key: key);

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
          List<OrderLineItem>? orderItems =
              saleDetailsState.invoice?.order?.orderLineItems;
          Invoice? invoice = saleDetailsState.invoice;
          OrderProduct? order = saleDetailsState.invoice?.order;
          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScolled) => [
              SliverAppBar(
                title: BoxText.headingTwo(
                  '#' + '${saleDetailsState.invoice?.number}'.padLeft(10, '0'),
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
                BoxText.caption(
                    TimeFormater().myDateAndTimeFormat(DateTime.now())),
                Expanded(
                  child: ListView.builder(
                    itemCount: orderItems?.length,
                    itemBuilder: (BuildContext context, index) => ListTile(
                      title: BoxText.body(
                        '${orderItems?[index].product?.label}',
                        fontWeight: FontWeight.bold,
                      ),
                      subtitle: BoxText.body(
                        '${orderItems?[index].price} XOF x ${orderItems?[index].amount}',
                        color: Colors.grey.shade600,
                      ),
                      trailing: BoxText.body(
                        '${orderItems?[index].total}',
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 80,
                  color: Colors.grey.shade300,
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Row(
                      children: [
                        BoxText.subheading(
                            'Total: ${order?.getOrderTotalFromListOrderLineItems}'),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(Ionicons.print),
                            label: BoxText.body('Imprimer'),
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: kPrimaryColor,
                            ),
                          ),
                        )
                      ],
                    ),
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
