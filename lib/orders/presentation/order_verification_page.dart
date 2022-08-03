import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mpos_app/src/widgets/box_text.dart';
import '../../src/shared/app_colors.dart';
import '../core/domain/order.dart';
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
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScolled) => [
          SliverAppBar(
            title: BoxText.headingTwo(
              'Commande'.toUpperCase(),
              color: kThreeColor,
            ),
            iconTheme: const IconThemeData(
              color: kPrimaryColor, //change your color here
            ),
            backgroundColor: Colors.grey.shade100,
            elevation: 0,
          )
        ],
        body: BlocBuilder<SelectedOrderItemCubit, SelectedOrderItemState>(
          builder: (context, selectedOrderItemState) {
            List<Map<String, dynamic>> orderItems =
                selectedOrderItemState.selectedOrderItem ?? [];
            return Column(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: ListView.builder(
                      itemCount:
                          selectedOrderItemState.selectedOrderItem?.length,
                      itemBuilder: (BuildContext context, index) => Card(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(top: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          height: 120,
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: BoxText.headingThree(
                                    '${orderItems[index]['product'].label ?? ''}'),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: BoxText.subheading(
                                        'XOF ${orderItems[index]['product'].price ?? ''}'),
                                  ),
                                  Expanded(
                                    child: Container(),
                                  ),
                                  Container(
                                    width: 150,
                                    height: 50,
                                    margin: const EdgeInsets.only(right: 10),
                                    child: Stack(children: [
                                      Positioned(
                                        right: 5,
                                        child: Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                              color: Colors.red.shade300,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          padding: const EdgeInsets.all(5),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                orderItems[index]['amount'] =
                                                    orderItems[index]
                                                            ['amount'] +
                                                        1;
                                              });
                                            },
                                            child: const Icon(
                                              Ionicons.add_outline,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Container(
                                          height: 50,
                                          width: 20,
                                          padding: const EdgeInsets.all(5),
                                          child: Center(
                                            child: BoxText.subheading(
                                                '${orderItems[index]['amount']}'),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 5,
                                        child: InkWell(
                                          onTap: () {
                                            if (orderItems[index]['amount'] >
                                                1) {
                                              setState(() {
                                                orderItems[index]['amount'] =
                                                    orderItems[index]
                                                            ['amount'] -
                                                        1;
                                              });
                                            }
                                          },
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color:
                                                        Colors.grey.shade500)),
                                            padding: const EdgeInsets.all(5),
                                            child: const Icon(
                                              Ionicons.remove_outline,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.all(10),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const BoxText.headingThree('Total'),
                            BoxText.headingThree(
                                'XOF ${OrderProduct.getOrderTotal(orderItems)}')
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                print(
                                    'Cloture de la commande et impression du réçu');
                              },
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade400),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    height: 80,
                                    child: Center(
                                      child: Icon(
                                        Ionicons.receipt_outline,
                                        size: 40,
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Center(
                                    child: BoxText.body('Cloturer et réçu'),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                print('Cloture de la  commande');
                              },
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: kSecondaryColor,
                                    ),
                                    height: 80,
                                    child: const Center(
                                      child: Icon(
                                        Ionicons.cash,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Center(
                                    child: BoxText.body('Cloturer'),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
