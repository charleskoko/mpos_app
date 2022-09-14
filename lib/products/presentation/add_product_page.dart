import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import '../../core/presentation/snack_bar.dart';
import '../../core/shared/error_message.dart';
import '../../src/widgets/box_button.dart';
import '../../src/widgets/box_input_field.dart';
import '../../src/widgets/box_text.dart';
import '../core/domaine/product.dart';
import '../shared/cubit/fetch_product/fetch_products_cubit.dart';
import '../shared/cubit/store_product/store_product_cubit.dart';

buildBottomSheetForAddNewProduct(
  BuildContext context,
  GlobalKey<FormState> formKey,
  TextEditingController labelTextFieldController,
  TextEditingController priceTextFieldController,
) {
  return showBottomSheet(
    context: context,
    builder: (context) => MultiBlocListener(
      listeners: [
        BlocListener<StoreProductCubit, StoreProductState>(
          listener: (context, storeProductState) {
            if (storeProductState is StoreProductError) {
              String errorKey = ErrorMessage.determineMessageKey(
                  storeProductState.message ?? '');
              buidSnackbar(
                context: context,
                backgroundColor: Colors.red,
                text: ErrorMessage.errorMessages[errorKey] ??
                    'Une erreur a eu lieu. Veuillez réessayer',
              );
            }
            if (storeProductState is StoreProductStored) {
              Navigator.pop(context);
              context.read<FetchProductsCubit>().fetchProductList();
              labelTextFieldController.text = '';
              priceTextFieldController.text = '';
              buidSnackbar(
                context: context,
                backgroundColor: Colors.green,
                text: 'Nouveau produit ajouté avec succès',
              );
            }
          },
        ),
      ],
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
                        BoxInputField.text(
                          controller: labelTextFieldController,
                          labelText: "Label du produit",
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Label est obligatoire';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        BoxInputField.number(
                          controller: priceTextFieldController,
                          labelText: "Prix du produit",
                          validator: (value) {
                            return null;
                          },
                        ),
                        const SizedBox(height: 50),
                        BlocBuilder<StoreProductCubit, StoreProductState>(
                          builder: (context, storeProductCubit) {
                            return BoxButton.normal(
                                isBusy:
                                    (storeProductCubit is StoreProductLoading)
                                        ? true
                                        : false,
                                title: 'Enregistrer',
                                onTap: () {
                                  if (formKey.currentState!.validate()) {
                                    Product product = Product(
                                      label: labelTextFieldController.text,
                                      price: (priceTextFieldController
                                              .text.isEmpty)
                                          ? 0
                                          : double.parse(
                                              priceTextFieldController.text,
                                            ),
                                    );
                                    context
                                        .read<StoreProductCubit>()
                                        .storeProduct(product);
                                  }
                                });
                          },
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
