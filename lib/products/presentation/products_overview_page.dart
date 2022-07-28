import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

import '../../src/shared/app_colors.dart';
import '../../src/shared/styles.dart';
import '../../src/widgets/box_text.dart';
import '../core/domaine/product.dart';
import '../shared/cubit/fetch_products_cubit.dart';

class ProductsOverviewPage extends StatefulWidget {
  ProductsOverviewPage({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewPage> createState() => _ProductsOverviewPageState();
}

class _ProductsOverviewPageState extends State<ProductsOverviewPage> {
  List<Product> selectedProduct = [];

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
              onPressed: () {},
            ),
            if (selectedProduct.isNotEmpty)
              Positioned(
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
                    child: BoxText.caption(selectedProduct.length.toString(),
                        color: Colors.white),
                  ),
                ),
              )
          ])
        ],
      ),
      body: BlocBuilder<FetchProductsCubit, FetchProductsState>(
        builder: (context, fetchProductState) {
          if (fetchProductState is FetchProductsLoading) {
            return const Center(
              child: Text('loading'),
            );
          }
          if (fetchProductState is FetchProductsLoaded) {
            List<Product> products = fetchProductState.products;
            return Column(
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
                        child: TextField(
                            cursorColor: kPrimaryColor,
                            decoration: InputDecoration(
                              labelStyle: subheadingStyle.copyWith(
                                color: kblackColor,
                              ),
                              hintText: 'Rechercher un produit',
                              hintStyle: bodyStyle,
                              prefixIcon: const Icon(
                                Ionicons.search,
                                color: kPrimaryColor,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              print(value);
                            }),
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
                                onPressed: () {
                                  print('Ajouter nouveau produit');
                                },
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
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (BuildContext context, index) =>
                          GestureDetector(
                        onTap: () {
                          setState(() {
                            _addProductToList(products[index]);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: kSecondaryColor,
                              width: 0.5,
                            ),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.all(2),
                          width: double.infinity,
                          child: Row(children: [
                            Container(
                              padding: const EdgeInsets.all(3),
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Image(
                                  image: AssetImage(
                                      "assets/images/image_placeholder.jpeg")),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: BoxText.subheading(
                                      products[index].label ?? '',
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: BoxText.caption(
                                      'XOF ${products[index].price.toString()}',
                                      color: Colors.green,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              child: Row(children: [
                                GestureDetector(
                                  onTap: () {
                                    print("Modifier l'article");
                                  },
                                  child: Icon(
                                    Ionicons.pencil_outline,
                                    size: 20,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                GestureDetector(
                                  onTap: () {
                                    print("Supprimer l'article");
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 5),
                                    child: Icon(
                                      Ionicons.trash_outline,
                                      size: 20,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ),
                              ]),
                            )
                          ]),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          if (fetchProductState is FetchProductsError) {
            return const Center(
              child: Text('error'),
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
