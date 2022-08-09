import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mpos_app/core/shared/extension.dart';
import 'package:mpos_app/products/presentation/delete_product.dart';
import 'package:mpos_app/products/presentation/edit_product_page.dart';
import '../../core/shared/error_message.dart';
import '../../orders/shared/cubit/selected_order_item_cubit.dart';
import '../../orders/shared/cubit/store_order_cubit.dart';
import '../../src/shared/app_colors.dart';
import '../../src/widgets/box_input_field.dart';
import '../../src/widgets/box_text.dart';
import '../core/domaine/product.dart';
import '../shared/cubit/fetch_product/fetch_products_cubit.dart';
import 'add_product_page.dart';

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

  void _addProductToList(Product product) {
    selectedProduct.add(product);
  }

  @override
  void initState() {
    context.read<FetchProductsCubit>().fetchProductList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        title: BoxText.headingTwo(
          'Produits'.toUpperCase(),
          color: kThreeColor,
        ),
        actions: [
          Stack(children: [
            IconButton(
              icon: const Icon(
                Ionicons.basket_outline,
                color: kThreeColor,
              ),
              onPressed: () {
                final selectedOrderItemState =
                    context.read<SelectedOrderItemCubit>().state;
                if (selectedOrderItemState.selectedOrderItem?.isNotEmpty ??
                    false) {
                  context.goNamed('orderVerification');
                }
              },
            ),
            BlocBuilder<SelectedOrderItemCubit, SelectedOrderItemState>(
              builder: (context, selectOrderItemState) {
                if (selectOrderItemState.selectedOrderItem?.isNotEmpty ??
                    false) {
                  return Positioned(
                    top: 6,
                    left: 5,
                    child: Container(
                      height: 20,
                      width: 20,
                      decoration: const BoxDecoration(
                        color: kThreeColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: BoxText.caption(
                            selectOrderItemState.selectedOrderItem!.length
                                .toString(),
                            color: Colors.white),
                      ),
                    ),
                  );
                }
                return Container();
              },
            )
          ])
        ],
      ),
      body: BlocBuilder<FetchProductsCubit, FetchProductsState>(
        builder: (context, fetchProductState) {
          if (fetchProductState is FetchProductsLoading) {
            return Center(
              child: SpinKitWave(
                color: Colors.grey.shade300,
                size: 30.0,
              ),
            );
          }
          if (fetchProductState is FetchProductsLoaded) {
            List<Product> products = fetchProductState.products;
            return MultiBlocListener(
              listeners: [
                BlocListener<StoreOrderCubit, StoreOrderState>(
                    listener: (context, soreOrderState) {
                  if (soreOrderState is StoreOrderLoaded) {
                    showBottomSheet(
                      context: context,
                      builder: (context) => Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10),
                            topLeft: Radius.circular(10),
                          ),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                              color: Colors.grey.shade300,
                              spreadRadius: 5,
                            )
                          ],
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
                              children: [
                                const Center(
                                  child: Icon(
                                    Ionicons.checkmark_circle,
                                    color: Colors.green,
                                  ),
                                ),
                                BoxText.caption("Achat enregistré avec succés")
                              ],
                            ))
                          ],
                        ),
                      ),
                    );
                  }
                })
              ],
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 10,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                              height: 55,
                              child: BoxInputField.text(
                                hintText: 'Rechercher un produit',
                                onChanged: (value) {
                                  context
                                      .read<FetchProductsCubit>()
                                      .filterProductsList(
                                        text: value,
                                        products: products,
                                      );
                                  return null;
                                },
                              )),
                        ),
                        const SizedBox(width: 5),
                        SizedBox(
                            width: 50,
                            height: 50,
                            child: Container(
                              decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: IconButton(
                                  onPressed: () =>
                                      buildBottomSheetForAddNewProduct(
                                    context,
                                    formKey,
                                    labelTextFieldController,
                                    priceTextFieldController,
                                  ),
                                  icon: Icon(
                                    Ionicons.add_outline,
                                    size: 30,
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
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
                              mainAxisSpacing: 1,
                              crossAxisSpacing: 1,
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
                              child: Card(
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        right: 0,
                                        child: InkWell(
                                          onTap: () =>
                                              buildAlertDialogeForDeleteProduct(
                                            context,
                                            products[index],
                                          ),
                                          child: const Icon(
                                            Ionicons.close_circle_outline,
                                            color: Colors.red,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 0,
                                        child: InkWell(
                                          onTap: () =>
                                              buildBottomSheetForEditProduct(
                                            context,
                                            formKey,
                                            products[index],
                                            labelTextFieldController,
                                            priceTextFieldController,
                                          ),
                                          child: const Icon(
                                            Ionicons.pencil_outline,
                                            size: 17,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 28,
                                        left: 10,
                                        child: BoxText.body(
                                            '${products[index].label}'),
                                      ),
                                      Positioned(
                                        bottom: 5,
                                        left: 10,
                                        child: BoxText.body(
                                          '${products[index].price} XOF',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Positioned(
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                            top: 20,
                                            left: 10,
                                            right: 10,
                                            bottom: 50,
                                          ),
                                          child: const Center(
                                            child: Image(
                                                image: AssetImage(
                                                    "assets/images/image_placeholder.jpeg")),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )),
                    ),
                  if (products.isEmpty)
                    Expanded(
                      child: Center(
                        child: BoxText.body(
                          'Ajouter vos Produits en cliquant sur "+"',
                          color: Colors.grey.shade500,
                        ),
                      ),
                    )
                ],
              ),
            );
          }
          if (fetchProductState is FetchProductsError) {
            return Center(
              child: BoxText.body(
                '${ErrorMessage.errorMessages['${fetchProductState.message}']}',
                color: Colors.grey.shade500,
              ),
            );
          }
          return const Center(
            child: Text('initial'),
          );
        },
      ),
    );
  }
}
