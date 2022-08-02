import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpos_app/src/widgets/box_text.dart';

import '../../products/core/domaine/product.dart';
import '../../src/shared/app_colors.dart';
import '../shared/cubit/selected_order_item_cubit.dart';

class OrderVerificationPage extends StatefulWidget {
  OrderVerificationPage({Key? key}) : super(key: key);

  @override
  State<OrderVerificationPage> createState() => _OrderVerificationPageState();
}

class _OrderVerificationPageState extends State<OrderVerificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: kPrimaryColor, //change your color here
        ),
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        title: BoxText.headingTwo(
          ''.toUpperCase(),
          color: kThreeColor,
        ),
      ),
      body: BlocBuilder<SelectedOrderItemCubit, SelectedOrderItemState>(
        builder: (context, selectedOrderItemState) {
          List<Map<String, dynamic>> orderItems =
              selectedOrderItemState.selectedOrderItem ?? [];
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            child: ListView.builder(
              itemCount: selectedOrderItemState.selectedOrderItem?.length,
              itemBuilder: (BuildContext context, index) => Card(
                  child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(top: 5),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                height: 100,
                child: BoxText.subheading(
                    '${orderItems[index]['product'].label ?? ''}, ${orderItems[index]['amount']}'),
              )),
            ),
          );
        },
      ),
    );
  }
}