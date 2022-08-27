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
      backgroundColor: kScaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: kAppBarBackgroundColor,
            elevation: 0,
            floating: true,
            pinned: true,
            snap: false,
            centerTitle: true,
            title: BoxText.headingTwo(
              'Produits',
              color: Colors.white,
            ),
            actions: [
              Stack(children: [
                IconButton(
                  icon: const Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    final selectedOrderItemState =
                        context.read<SelectedOrderItemCubit>().state;
                    if (selectedOrderItemState.selectedOrderItem?.isNotEmpty ??
                        false) {
                      context.goNamed('orderVerification');
                    }
                    if (selectedOrderItemState.selectedOrderItem?.isEmpty ??
                        true) {
                      buidSnackbar(
                        context: context,
                        backgroundColor: kSecondaryColor,
                        text: 'Le panier est vide',
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
            bottom: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: kAppBarBackgroundColor,
              elevation: 0,
              title: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                width: double.infinity,
                height: 40,
                child: Center(
                  child: BoxInputField.text(
                    icon: Ionicons.search,
                  ),
                ),
              ),
            ),
          ),
          BlocBuilder<FetchProductsCubit, FetchProductsState>(
            builder: (context, fetchProductsState) {
              if (fetchProductsState is FetchProductsLoading) {
                return SliverList(
                  delegate: SliverChildListDelegate([
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: const BoxLoading(),
                    )
                  ]),
                );
              }
              if (fetchProductsState is FetchProductsError) {
                return SliverList(
                  delegate: SliverChildListDelegate([
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: BoxMessage(
                        message:
                            '${ErrorMessage.errorMessages['${fetchProductsState.message}']}',
                      ),
                    )
                  ]),
                );
              }
              if (fetchProductsState is FetchProductsLoaded) {
                List<Product> products = fetchProductsState.fresh.entity;
                return SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 3,
                    maxCrossAxisExtent: 200,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return InkWell(
                        onLongPress: () {
                          showBottomSheet(
                            context: context,
                            builder: (context) => Container(
                              width: MediaQuery.of(context).size.width,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.white,
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
                                    margin: const EdgeInsets.only(top: 4),
                                    height: 3,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: kScaffoldBackgroundColor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                              buildAlertDialogeForDeleteProduct(
                                                context,
                                                products[index],
                                              );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color:
                                                      kScaffoldBackgroundColor,
                                                ),
                                              ),
                                              child: Center(
                                                child: BoxText.subheading(
                                                  'Supprimer',
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red.shade400,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              buildBottomSheetForEditProduct(
                                                context,
                                                formKey,
                                                products[index],
                                                labelTextFieldController,
                                                priceTextFieldController,
                                              );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color:
                                                      kScaffoldBackgroundColor,
                                                ),
                                              ),
                                              child: Center(
                                                child: BoxText.subheading(
                                                  'Modifier',
                                                  fontWeight: FontWeight.bold,
                                                  color: kAppBarBackgroundColor,
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
                      );
                    },
                    childCount: products.length,
                  ),
                );
              }
              return SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: const BoxLoading(),
                  )
                ]),
              );
            },
          ),
        ],
      ),
    );
  }
}
