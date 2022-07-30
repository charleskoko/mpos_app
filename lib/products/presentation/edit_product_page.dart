import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import '../../core/presentation/snack_bar.dart';
import '../../src/shared/app_colors.dart';
import '../../src/shared/styles.dart';
import '../../src/widgets/box_button.dart';
import '../../src/widgets/box_input_field.dart';
import '../../src/widgets/box_text.dart';
import '../core/domaine/product.dart';
import '../shared/cubit/fetch_products_cubit.dart';
import '../shared/cubit/update_product_cubit.dart';

buildBottomSheetForEditProduct(
  BuildContext context,
  GlobalKey<FormState> formKey,
  Product product,
  TextEditingController labelTextFieldController,
  TextEditingController priceTextFieldController,
) {
  final size = MediaQuery.of(context).size;
  labelTextFieldController.text = product.label ?? '';
  priceTextFieldController.text = product.price.toString();
  return showBottomSheet(
    context: context,
    builder: (context) => BlocListener<UpdateProductCubit, UpdateProductState>(
      listener: (context, updateProductState) {
        if (updateProductState is UpdateProductError) {}
        if (updateProductState is UpdateProductUpdated) {
          Navigator.pop(context);
          context.read<FetchProductsCubit>().fetchProductList();
          labelTextFieldController.text = '';
          priceTextFieldController.text = '';
          buidSnackbar(
            context: context,
            backgroundColor: Colors.green,
            text: 'Le produit a été modifié',
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
                      child: BoxText.headingThree('Modifier produit'),
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
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: 16),
                      BoxInputField.number(
                        controller: priceTextFieldController,
                        labelText: "Prix du produit",
                        validator: (value) {
                          return null;
                        },
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: 50),
                      BlocBuilder<UpdateProductCubit, UpdateProductState>(
                        builder: (context, updateProductCubit) {
                          return BoxButton(
                            isBusy: (updateProductCubit is UpdateProductUpdated)
                                ? true
                                : false,
                            title: 'Enregistrer',
                            onTap: () {
                              context.read<UpdateProductCubit>().updateProduct(
                                    label: labelTextFieldController.text,
                                    productId: product.id ?? '',
                                    price: double.parse(
                                        priceTextFieldController.text),
                                  );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
