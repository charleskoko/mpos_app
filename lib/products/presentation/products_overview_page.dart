import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mpos_app/products/presentation/delete_product.dart';
import 'package:mpos_app/products/presentation/edit_product_page.dart';
import '../../core/presentation/snack_bar.dart';
import '../../core/shared/error_message.dart';
import '../../orders/shared/cubit/fetch_not_processed_order_cubit.dart';
import '../../orders/shared/cubit/selected_order_item_cubit.dart';
import '../../orders/shared/cubit/store_order_cubit.dart';
import '../../src/shared/app_colors.dart';
import '../../src/widgets/box_input_field.dart';
import '../../src/widgets/box_loading.dart';
import '../../src/widgets/box_message.dart';
import '../../src/widgets/box_product.dart';
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
        centerTitle: true,
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
                if (selectedOrderItemState.selectedOrderItem?.isEmpty ?? true) {
                  buidSnackbar(
                    context: context,
                    backgroundColor: kSecondaryColor,
                    text: 'Votre panier d\'achat est vide',
                  );
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
                      showBottomSheet(
                        context: context,
                        builder: (context) => Container(
                          height: 500,
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
                                    BoxText.caption(
                                      "Achat enregistré avec succès",
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
                              onLongPress: () {
                                showBottomSheet(
                                  context: context,
                                  builder: (context) => Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 150,
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
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          margin: const EdgeInsets.only(top: 5),
                                          width: 100,
                                          height: 5,
                                        ),
                                        Expanded(
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TextButton.icon(
                                              icon: Icon(
                                                Ionicons.trash_outline,
                                                color: Colors.green.shade100,
                                              ),
                                              label: BoxText.subheading(
                                                  'Supprimer'),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                buildAlertDialogeForDeleteProduct(
                                                  context,
                                                  products[index],
                                                );
                                              },
                                            ),
                                            const Divider(),
                                            TextButton.icon(
                                              icon: Icon(
                                                Ionicons.pencil_outline,
                                                color: Colors.green.shade100,
                                              ),
                                              label: BoxText.subheading(
                                                  'Modifier'),
                                              onPressed: () {
                                                buildBottomSheetForEditProduct(
                                                  context,
                                                  formKey,
                                                  products[index],
                                                  labelTextFieldController,
                                                  priceTextFieldController,
                                                );
                                              },
                                            )
                                          ],
                                        ))
                                      ],
                                    ),
                                  ),
                                );
                              },
                              onTap: () {
                                context
                                    .read<SelectedOrderItemCubit>()
                                    .selectOrderItem(
                                      products[index],
                                    );
                              },
                              child: BoxProduct(
                                product: products[index],
                              ),
                            ),
                          )),
                    ),
                  if (products.isEmpty)
                    const Expanded(
                      child: BoxMessage(
                          message: 'Ajouter vos produits en cliquant sur "+"'),
                    )
                ],
              ),
            );
          }
          if (fetchProductState is FetchProductsError) {
            return BoxMessage(
              message:
                  '${ErrorMessage.errorMessages['${fetchProductState.message}']}',
            );
          }
          return const BoxMessage(message: '');
        },
      ),
    );
  }
}
