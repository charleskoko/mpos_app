import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

import '../../orders/core/domain/selected_order_item.dart';
import '../../src/shared/app_colors.dart';
import '../shared/cubit/show_not_processed_order_cubit.dart';

class ShowNotProcessedOrderPage extends StatefulWidget {
  const ShowNotProcessedOrderPage({Key? key}) : super(key: key);

  @override
  State<ShowNotProcessedOrderPage> createState() =>
      _ShowNotProcessedOrderPageState();
}

class _ShowNotProcessedOrderPageState extends State<ShowNotProcessedOrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: BlocBuilder<ShowNotProcessedOrderCubit,
                  ShowNotProcessedOrderState>(
              builder: (context, showNotProcessedOrderState) {
            return Text(
              showNotProcessedOrderState.notProcessedOrder!.label!
                  .toUpperCase(),
              style: const TextStyle(
                fontSize: 24,
                fontFamily: 'Poppins-Regular',
                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
            );
          }),
          leadingWidth: 80,
          leading: Container(
            margin: const EdgeInsets.only(left: 21),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: Color(0xFFEAEAEA)),
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
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: TextButton(
                  onPressed: () {},
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: const Center(
                      child: Text(
                        '+ Ajouter plus',
                        style: TextStyle(
                          fontFamily: 'Poppins-pop',
                          color: kPrimaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: BlocBuilder<ShowNotProcessedOrderCubit,
                    ShowNotProcessedOrderState>(
                  builder: (context, showNotProcessedOrderState) {
                    return ListView.builder(
                      itemCount: showNotProcessedOrderState
                          .notProcessedOrder!.selectedOrderItem!.length,
                      itemBuilder: (context, index) {
                        List<SelectedOrderItem>? selectedOrderItem =
                            showNotProcessedOrderState
                                .notProcessedOrder!.selectedOrderItem;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 2,
                                spreadRadius: 2,
                                offset: const Offset(1, 2), // Shadow position
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(
                                  margin: const EdgeInsets.only(left: 16),
                                  child: Text(
                                    selectedOrderItem![index].product!.label!,
                                    style: const TextStyle(
                                      fontFamily: 'Poppins-bold',
                                      color: kPrimaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(right: 20),
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    '${selectedOrderItem[index].amount}',
                                    style: const TextStyle(
                                      fontFamily: 'Poppins-regular',
                                      color: kPrimaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: GestureDetector(
          onTap: () {
            //context.goNamed('orderVerification');
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
                    child: const Text(
                      'Cloturer',
                      style: TextStyle(
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
        ));
  }
}
