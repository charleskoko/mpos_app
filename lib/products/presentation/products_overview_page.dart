import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import '../../orders/shared/cubit/selected_order_item_cubit.dart';
import '../../orders/shared/cubit/store_order_cubit.dart';
import '../../src/shared/app_colors.dart';
import '../../src/widgets/box_loading.dart';
import '../../src/widgets/box_message.dart';
import '../core/domaine/product.dart';
import '../shared/cubit/fetch_product/fetch_products_cubit.dart';

class ProductsOverviewPage extends StatefulWidget {
  const ProductsOverviewPage({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewPage> createState() => _ProductsOverviewPageState();
}

class _ProductsOverviewPageState extends State<ProductsOverviewPage> {
  List<Product> selectedProduct = [];
  final formKey = GlobalKey<FormState>();
  TextEditingController labelTextFieldController = TextEditingController();
  TextEditingController priceTextFieldController = TextEditingController();

  @override
  void initState() {
    context.read<FetchProductsCubit>().fetchProductList();
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
          'ARTICLES',
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
                      Navigator.pop(context);
                      context
                          .read<SelectedOrderItemCubit>()
                          .cancelCurrentSelection(isOrderCanceled: false);
                      showBottomSheet(
                        context: context,
                        builder: (context) => Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: kPrimaryColor),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(10),
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(10)),
                                margin: const EdgeInsets.only(top: 5),
                                width: 100,
                                height: 5,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Center(
                                      child: Icon(
                                        Ionicons.checkmark_circle,
                                        size: 100,
                                        color: kPrimaryColor,
                                      ),
                                    ),
                                    Text(
                                      "Paiement réussi",
                                      style: TextStyle(
                                        fontFamily: 'Poppins-Bold',
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
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
                  },
                ),
              ],
              child: Column(
                children: [
                  if (products.isNotEmpty)
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                        ),
                        child: GridView.builder(
                          itemCount: products.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                            crossAxisCount:
                                MediaQuery.of(context).size.shortestSide < 600
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
                            child: BlocBuilder<SelectedOrderItemCubit,
                                SelectedOrderItemState>(
                              builder: (context, selectedOrderItemState) {
                                bool? isProductSelected = selectedOrderItemState
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
                                        offset: const Offset(
                                            1, 2), // Shadow position
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(10),
                                    border: (isProductSelected ?? false)
                                        ? Border.all(color: kPrimaryColor)
                                        : null,
                                  ),
                                  child: Stack(children: [
                                    Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${products[index].label}',
                                            style: const TextStyle(
                                              fontFamily: 'Poppins-Bold',
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 13),
                                          Text(
                                            'XOF ${products[index].purchasePrice}',
                                            style: const TextStyle(
                                              fontFamily: 'Poppins-Light',
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
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
                                          child: (isProductSelected ?? false)
                                              ? Container(
                                                  height: 30,
                                                  width: 30,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: kPrimaryColor,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Center(
                                                    child: Icon(
                                                      Ionicons.checkmark,
                                                      color: Colors.white,
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
                    ),
                  if (products.isEmpty)
                    const Expanded(
                      child: BoxMessage(
                          message: "Vous n'avez pas enregistré d'article"),
                    )
                ],
              ),
            );
          }
          if (fetchProductState is FetchProductsError) {
            return BoxMessage(
              message: '${fetchProductState.message}}',
            );
          }
          return const BoxMessage(message: '');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          BlocBuilder<SelectedOrderItemCubit, SelectedOrderItemState>(
        builder: (context, selectedOrderItemState) {
          double sum = 0;
          if (selectedOrderItemState.selectedOrderItem?.isNotEmpty ?? false) {
            selectedOrderItemState.selectedOrderItem!.forEach((element) {
              sum = sum + (element.price! * element.amount!);
            });
            return GestureDetector(
              onTap: () {
                context.goNamed('orderVerification', params: {'tab': '2'});
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
                        child: Text(
                          'XOF $sum',
                          style: const TextStyle(
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
                              child: Text(
                                'Caisse',
                                style: TextStyle(
                                  fontFamily: 'Poppins-Light',
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
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
            );
          }
          return Container();
        },
      ),
    );
  }
}
