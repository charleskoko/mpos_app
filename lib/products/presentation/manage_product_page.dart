import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';

import '../../src/shared/app_colors.dart';
import '../../src/widgets/box_button.dart';
import '../../src/widgets/box_loading.dart';
import '../../src/widgets/box_message.dart';
import '../core/domaine/product.dart';
import '../shared/cubit/delete_product/delete_product_cubit.dart';
import '../shared/cubit/fetch_product/fetch_products_cubit.dart';
import '../shared/cubit/show_product/show_product_cubit.dart';

class ManageItemsPage extends StatefulWidget {
  const ManageItemsPage({Key? key}) : super(key: key);

  @override
  State<ManageItemsPage> createState() => ManageItemsPageState();
}

class ManageItemsPageState extends State<ManageItemsPage> {
  void getProductList() {
    var state = context.read<FetchProductsCubit>().state;
    if (state is FetchProductsLoaded) {
      return;
    }
    context.read<FetchProductsCubit>().fetchProductList();
    return;
  }

  @override
  void initState() {
    getProductList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: const BackButton(color: kPrimaryColor),
        backgroundColor: const Color(0xFFF5F5F5),
        title: const Text(
          'Gestion des articles',
          style: TextStyle(
            fontSize: 22,
            fontFamily: 'Poppins-Regular',
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocListener<DeleteProductCubit, DeleteProductState>(
        listener: (context, deleteProductState) {
          if (deleteProductState is DeleteProductDeleted) {
            Navigator.pop(context);
            context.read<FetchProductsCubit>().fetchProductList();
            Fluttertoast.showToast(
              gravity: ToastGravity.TOP,
              backgroundColor: kPrimaryColor,
              msg: "L'article a été suprimé avec succès",
            );
          }
          if (deleteProductState is DeleteProductError) {
            Navigator.pop(context);
            Fluttertoast.showToast(
              gravity: ToastGravity.TOP,
              backgroundColor: kPrimaryColor,
              msg: 'Une erreur a eu lieu, veuillez réessayer plus tard',
            );
          }
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 21),
          child: Column(
            children: [
              const SizedBox(height: 43),
              BoxButton.main(
                  isBusy: false,
                  title: 'Ajouter un article',
                  onTap: () {
                    context.goNamed('addProduct', params: {'tab': '2'});
                  }),
              Expanded(
                  child: BlocBuilder<FetchProductsCubit, FetchProductsState>(
                builder: (context, fetchProductState) {
                  if (fetchProductState is FetchProductsError) {
                    return BoxMessage(message: fetchProductState.message);
                  }
                  if (fetchProductState is FetchProductsLoaded) {
                    List<Product> products = fetchProductState.fresh.entity;
                    products.sort((a, b) => a.label!.compareTo(b.label!));
                    return ListView.builder(
                      itemCount: fetchProductState.fresh.entity.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(top: 15),
                          height: 87,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 2,
                                spreadRadius: 2,
                                offset: const Offset(1, 2), // Shadow position
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                left: 20,
                                top: 36,
                                child: Text(
                                  products[index].label!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Poppins-bold',
                                    color: Color(0xff121212),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 20,
                                top: 56,
                                child: Text(
                                  '${products[index].purchasePrice!} FCFA',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Poppins-light',
                                    color: Color(0xff121212),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 64,
                                top: 24,
                                child: InkWell(
                                  onTap: () {
                                    context
                                        .read<ShowProductCubit>()
                                        .showProduct(products[index]);
                                    context.goNamed('updateProduct',
                                        params: {'tab': '2'});
                                  },
                                  child: Container(
                                    height: 42,
                                    width: 42,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0x4A2622624A)),
                                    child: const ImageIcon(
                                      AssetImage('assets/images/trash-2.png'),
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 15,
                                top: 24,
                                child: InkWell(
                                  onTap: () {
                                    showGeneralDialog(
                                        barrierColor:
                                            Colors.black.withOpacity(0.5),
                                        transitionBuilder:
                                            (context, a1, a2, widget) {
                                          return Transform.scale(
                                            scale: a1.value,
                                            child: Opacity(
                                              opacity: a1.value,
                                              child: AlertDialog(
                                                contentPadding: EdgeInsets.zero,
                                                shape: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0)),
                                                content: Container(
                                                  width: 325,
                                                  height: 313,
                                                  child: Stack(
                                                    children: [
                                                      Positioned(
                                                          top: 5,
                                                          left: 5,
                                                          child: IconButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              icon: const Icon(
                                                                Ionicons.close,
                                                                size: 30,
                                                              ))),
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(top: 35),
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child: const Icon(
                                                          Ionicons
                                                              .trash_outline,
                                                          color: Color(
                                                            0xFFEC5D5D,
                                                          ),
                                                          size: 60,
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets
                                                                .only(
                                                            left: 10,
                                                            right: 10),
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child: const Center(
                                                          child: Text(
                                                            'Êtes-vous sûr de vouloir supprimer cet article de la liste de vos articles?',
                                                            style: TextStyle(
                                                              color:
                                                                  kPrimaryColor,
                                                              fontFamily:
                                                                  'Poppins-bold',
                                                              fontSize: 18,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        bottom: 33,
                                                        left: 49,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            context
                                                                .read<
                                                                    DeleteProductCubit>()
                                                                .deleteProduct(
                                                                    products[
                                                                        index]);
                                                          },
                                                          child: Container(
                                                            width: 227,
                                                            height: 54,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  kPrimaryColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                            ),
                                                            child: const Center(
                                                              child: Text(
                                                                'Confirmer',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontFamily:
                                                                      'Poppins-bold',
                                                                  fontSize: 18,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        transitionDuration:
                                            Duration(milliseconds: 200),
                                        barrierDismissible: true,
                                        barrierLabel: '',
                                        context: context,
                                        pageBuilder:
                                            (context, animation1, animation2) {
                                          return Container();
                                        });
                                  },
                                  child: Container(
                                    height: 42,
                                    width: 42,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0x59EC5D5D)),
                                    child: const Icon(Ionicons.trash_outline,
                                        color: Colors.red),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                        //: Container();
                      },
                    );
                  }
                  return BoxLoading();
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}
