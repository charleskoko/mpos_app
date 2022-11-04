import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:uuid/uuid.dart';
import '../../core/shared/error_messages.dart';
import '../../orders/shared/cubit/selected_order_item_cubit.dart';
import '../../orders/shared/cubit/store_order_cubit.dart';
import '../../src/shared/app_colors.dart';
import '../../src/widgets/box_loading.dart';
import '../../src/widgets/box_message.dart';
import '../core/domaine/product.dart';
import '../shared/cubit/fetch_product/fetch_products_cubit.dart';

class ProductsOverviewPage extends StatefulWidget {
  const ProductsOverviewPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductsOverviewPage> createState() => _ProductsOverviewPageState();
}

class _ProductsOverviewPageState extends State<ProductsOverviewPage>
    with SingleTickerProviderStateMixin {
  List<Product> selectedProduct = [];
  final formKey = GlobalKey<FormState>();
  late TabController _tabController;
  String customisedAmount = '';

  @override
  void initState() {
    context.read<FetchProductsCubit>().fetchProductList();
    _tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Caisse',
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'Poppins-Regular',
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<FetchProductsCubit, FetchProductsState>(
        builder: (context, fetchProductState) {
          if (fetchProductState is FetchProductsLoading) {
            return const BoxLoading();
          }
          if (fetchProductState is FetchProductsLoaded) {
            List<Product> products = fetchProductState.fresh.entity;
            return MultiBlocListener(
              listeners: [
                BlocListener<StoreOrderCubit, StoreOrderState>(
                  listener: (context, storeOrderState) {
                    if (storeOrderState is StoreOrderLoaded) {
                      context
                          .read<SelectedOrderItemCubit>()
                          .cancelCurrentSelection(isOrderCanceled: false);
                    }
                  },
                ),
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
                            text: 'Pavé numérique',
                          ),
                          Tab(
                            text: 'Catalogue',
                          ),
                        ],
                      ),
                    ),
                    // tab bar view here
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                Column(
                                  children: [
                                    // clavier numérique
                                    SizedBox(
                                      height: 150,
                                      child: Center(
                                        child: Text(
                                          '$customisedAmount FCFA',
                                          style: const TextStyle(
                                            fontFamily: 'Poppins-light',
                                            fontSize: 50,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            for (var column = 0;
                                                column < 4;
                                                column++)
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    for (var row = 0;
                                                        row < 3;
                                                        row++)
                                                      Expanded(
                                                        child: InkWell(
                                                          onTap: () {
                                                            int value =
                                                                determineValue(
                                                                    column:
                                                                        column,
                                                                    row: row);
                                                            if (value == 10) {
                                                              setState(() {
                                                                customisedAmount =
                                                                    '';
                                                              });
                                                              return;
                                                            }
                                                            if (value == 11) {
                                                              if (customisedAmount !=
                                                                  '') {
                                                                var uuid =
                                                                    Uuid();

                                                                Product
                                                                    product =
                                                                    Product(
                                                                  id: uuid.v1(),
                                                                  label:
                                                                      'Montant personalisé',
                                                                  purchasePrice:
                                                                      double.tryParse(
                                                                          customisedAmount),
                                                                  salePrice: double
                                                                      .tryParse(
                                                                          customisedAmount),
                                                                  isDeleted:
                                                                      false,
                                                                );
                                                                context
                                                                    .read<
                                                                        SelectedOrderItemCubit>()
                                                                    .selectOrderItem(
                                                                        product);
                                                                setState(() {
                                                                  customisedAmount =
                                                                      '';
                                                                });
                                                              }
                                                              return;
                                                            }
                                                            setState(() {
                                                              customisedAmount =
                                                                  customisedAmount +
                                                                      '${determineValue(column: column, row: row)}';
                                                            });
                                                            return;
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade400,
                                                                    width:
                                                                        0.4)),
                                                            child: Center(
                                                              child: Text(
                                                                '${(determineValue(column: column, row: row) == 10) ? 'C' : (determineValue(column: column, row: row) == 11) ? '+' : determineValue(column: column, row: row)}',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Poppins-light',
                                                                  color: (determineValue(
                                                                              column:
                                                                                  column,
                                                                              row:
                                                                                  row) ==
                                                                          11)
                                                                      ? Colors
                                                                          .blue
                                                                      : Colors
                                                                          .black,
                                                                  fontSize: 30,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                  ],
                                                ),
                                              )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                if (products.isNotEmpty)
                                  Container(
                                    padding: const EdgeInsets.only(
                                      left: 10,
                                      right: 10,
                                    ),
                                    child: GridView.builder(
                                      itemCount: products.length,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        mainAxisSpacing: 20,
                                        crossAxisSpacing: 20,
                                        crossAxisCount: MediaQuery.of(context)
                                                    .size
                                                    .shortestSide <
                                                600
                                            ? 2
                                            : 4,
                                      ),
                                      itemBuilder: (context, index) => InkWell(
                                        onTap: () {
                                          context
                                              .read<SelectedOrderItemCubit>()
                                              .selectOrderItem(
                                                products[index],
                                              );
                                        },
                                        child: BlocBuilder<
                                            SelectedOrderItemCubit,
                                            SelectedOrderItemState>(
                                          builder: (context,
                                              selectedOrderItemState) {
                                            bool? isProductSelected =
                                                selectedOrderItemState
                                                    .selectedOrderItem
                                                    ?.where((element) =>
                                                        element.product!.id ==
                                                        products[index].id)
                                                    .isNotEmpty;
                                            return Container(
                                              padding: const EdgeInsets.all(11),
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
                                                    BorderRadius.circular(10),
                                                border: (isProductSelected ??
                                                        false)
                                                    ? Border.all(
                                                        color: kPrimaryColor)
                                                    : null,
                                              ),
                                              child: Stack(children: [
                                                Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        '${products[index].label}',
                                                        style: const TextStyle(
                                                          fontFamily:
                                                              'Poppins-Bold',
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      const SizedBox(
                                                          height: 13),
                                                      Text(
                                                        '${products[index].purchasePrice} FCFA',
                                                        style: const TextStyle(
                                                          fontFamily:
                                                              'Poppins-Light',
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 5,
                                                  right: 5,
                                                  child: AnimatedSwitcher(
                                                      duration: const Duration(
                                                          milliseconds: 9000),
                                                      child:
                                                          (isProductSelected ??
                                                                  false)
                                                              ? Container(
                                                                  height: 30,
                                                                  width: 30,
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    color:
                                                                        kPrimaryColor,
                                                                    shape: BoxShape
                                                                        .circle,
                                                                  ),
                                                                  child:
                                                                      const Center(
                                                                    child: Icon(
                                                                      Ionicons
                                                                          .checkmark,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 20,
                                                                    ),
                                                                  ),
                                                                )
                                                              : Container()),
                                                )
                                              ]),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                if (products.isEmpty)
                                  const Expanded(
                                    child: BoxMessage(
                                        message:
                                            "Vous n'avez pas enregistré d'article"),
                                  )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: BlocBuilder<SelectedOrderItemCubit,
                                SelectedOrderItemState>(
                              builder: (context, selectedOrderItemState) {
                                double sum = 0;
                                if (selectedOrderItemState
                                        .selectedOrderItem?.length !=
                                    null) {
                                  selectedOrderItemState.selectedOrderItem!
                                      .forEach((element) {
                                    sum = sum +
                                        (element.price! * element.amount!);
                                  });
                                }
                                return Container(
                                  height: 80,
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: (sum > 0)
                                        ? kPrimaryColor
                                        : Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      if (selectedOrderItemState
                                              .selectedOrderItem?.length !=
                                          null) {
                                        context.pushNamed('orderVerification',
                                            params: {'tab': '0'});
                                      }
                                    },
                                    child: Text(
                                      'Facturer $sum FCFA',
                                      style: TextStyle(
                                        fontFamily: 'Poppins-Bold',
                                        color: (sum > 0)
                                            ? Colors.white
                                            : kPrimaryColor,
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }
          if (fetchProductState is FetchProductsError) {
            return BoxMessage(
                message:
                    ErrorMessages.errorMessages(fetchProductState.message!));
          }
          return const BoxMessage(message: '');
        },
      ),
    );
  }

  int determineValue({required int column, required int row}) {
    if (column == 0) {
      return row + 1;
    }
    if (column == 1) {
      return row + 4;
    }
    if (column == 2) {
      return row + 7;
    }
    if (row == 0) {
      return 10;
    }
    if (row == 1) {
      return 0;
    }
    return 11;
  }
}
