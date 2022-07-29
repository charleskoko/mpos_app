import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

import '../../core/presentation/snack_bar.dart';
import '../../src/shared/app_colors.dart';
import '../../src/shared/styles.dart';
import '../../src/widgets/box_text.dart';
import '../core/domaine/product.dart';
import '../shared/cubit/fetch_products_cubit.dart';
import '../shared/cubit/store_product_cubit.dart';

buildBottomSheetForAddNewProduct(
  BuildContext context,
  GlobalKey<FormState> formKey,
  TextEditingController labelTextFieldController,
  TextEditingController priceTextFieldController,
) {
  final size = MediaQuery.of(context).size;

  return showBottomSheet(
    context: context,
    builder: (context) => BlocListener<StoreProductCubit, StoreProductState>(
      listener: (context, storeProductState) {
        if (storeProductState is StoreProductError) {}
        if (storeProductState is StoreProductStored) {
          Navigator.pop(context);
          context.read<FetchProductsCubit>().fetchProductList();
          labelTextFieldController.text = '';
          priceTextFieldController.text = '';
          buidSnackbar(
            context: context,
            backgroundColor: Colors.green,
            text: 'un nouveau produit ajouté',
          );
        }
      },
      child: Container(
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
              ]),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                  bottom: 10,
                  top: 5,
                ),
                alignment: Alignment.centerRight,
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        top: 10,
                      ),
                      child: const Center(
                        child: BoxText.headingThree('Nouveau produit'),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Ionicons.close_circle_outline,
                          size: 20,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Form(
                  key: formKey,
                  child: Container(
                    padding: const EdgeInsets.only(top: 10, right: 10),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: labelTextFieldController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: "Label du produit",
                            labelStyle: subheadingStyle.copyWith(
                              color: kblackColor,
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
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Label est obligatoire';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: priceTextFieldController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Prix du produit",
                            labelStyle: subheadingStyle.copyWith(
                              color: kblackColor,
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
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 30),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: kPrimaryColor.withOpacity(0.5),
                                offset: const Offset(0, 24),
                                blurRadius: 50,
                                spreadRadius: -18,
                              ),
                            ],
                          ),
                          child: GestureDetector(
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                Product product = Product(
                                  label: labelTextFieldController.text,
                                  price: (priceTextFieldController.text.isEmpty)
                                      ? 0
                                      : double.parse(
                                          priceTextFieldController.text,
                                        ),
                                );
                                context
                                    .read<StoreProductCubit>()
                                    .storeProduct(product);
                              }
                            },
                            child: Container(
                              child: Center(
                                child: BoxText.subheading(
                                  'Enregistrer',
                                  color: Colors.white,
                                ),
                              ),
                              width: size.width - 110,
                              height: 55,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: const LinearGradient(
                                  colors: [
                                    kPrimaryColorGradient,
                                    kPrimaryColorDark,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
    ),
  );
}
