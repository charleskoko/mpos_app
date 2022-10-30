import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ionicons/ionicons.dart';
import '../../core/shared/mixin_scaffold.dart';
import '../../core/shared/mixin_validation.dart';
import '../../src/shared/app_colors.dart';
import '../../src/widgets/box_button.dart';
import '../../src/widgets/box_input_field.dart';
import '../shared/cubit/fetch_product/fetch_products_cubit.dart';
import '../shared/cubit/show_product/show_product_cubit.dart';
import '../shared/cubit/store_product/store_product_cubit.dart';
import '../shared/cubit/update_product/update_product_cubit.dart';

class UpdateProductPage extends StatefulWidget {
  UpdateProductPage({Key? key}) : super(key: key);

  @override
  State<UpdateProductPage> createState() => _UpdateProductPageState();
}

class _UpdateProductPageState extends State<UpdateProductPage>
    with ValidationMixin, ScaffoldMixin {
  TextEditingController productLabelController = TextEditingController();
  TextEditingController salePriceController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShowProductCubit, ShowProductState>(
      builder: (context, showProductState) {
        productLabelController.text = showProductState.product!.label!;
        salePriceController.text =
            '${showProductState.product!.purchasePrice!}';
        return Scaffold(
          bottomSheet: BlocBuilder<UpdateProductCubit, UpdateProductState>(
            builder: (context, updateProductState) {
              return Container(
                margin: const EdgeInsets.only(
                  bottom: 50,
                  left: 30,
                  right: 30,
                ),
                child: BoxButton.main(
                  isBusy: (updateProductState is StoreProductLoading)
                      ? true
                      : false,
                  title: 'Enregistrer',
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      if (productLabelController.text ==
                              showProductState.product!.label &&
                          double.parse(salePriceController.text) ==
                              showProductState.product!.salePrice) {
                        Navigator.pop(context);
                        return;
                      }
                      context.read<UpdateProductCubit>().updateProduct(
                            label: productLabelController.text,
                            productId: showProductState.product!.id!,
                            price: double.parse(salePriceController.text),
                          );
                      return;
                    }
                  },
                ),
              );
            },
          ),
          backgroundColor: const Color(0xFFF5F5F5),
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            leading: const BackButton(color: kPrimaryColor),
            backgroundColor: const Color(0xFFF5F5F5),
            title: Text(
              '${showProductState.product?.label!}',
              style: const TextStyle(
                fontSize: 22,
                fontFamily: 'Poppins-Regular',
                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: BlocListener<UpdateProductCubit, UpdateProductState>(
            listener: (context, updateProductState) {
              if (updateProductState is UpdateProductUpdated) {
                Navigator.pop(context);
                context.read<FetchProductsCubit>().fetchProductList();
                Fluttertoast.showToast(
                  gravity: ToastGravity.TOP,
                  backgroundColor: kPrimaryColor,
                  msg: "L'article a été modifié avec succès",
                );
              }
              if (updateProductState is UpdateProductError) {}
            },
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.only(
                left: 28,
                right: 28,
                top: 52,
              ),
              physics: const BouncingScrollPhysics(),
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 12),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          BoxInputField.text(
                            labelText: "Nom de l'article",
                            hintText: "Entrez le nom de l'article",
                            controller: productLabelController,
                            validator: (productLabel) {
                              return isTextfieldNotEmpty(productLabel)
                                  ? null
                                  : 'Veuillez un nom valide';
                            },
                          ),
                          const SizedBox(height: 20),
                          BoxInputField.number(
                            labelText: "Prix de l'article",
                            hintText: 'Entrez le prix de vente',
                            controller: salePriceController,
                            validator: (productPrice) {
                              return isNumeric<double>(
                                      double.tryParse(productPrice))
                                  ? null
                                  : 'Veuillez un prix valide';
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
