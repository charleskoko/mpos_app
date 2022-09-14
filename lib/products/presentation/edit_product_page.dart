import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/presentation/snack_bar.dart';
import '../../core/shared/error_message.dart';
import '../../src/shared/app_colors.dart';
import '../../src/widgets/box_button.dart';
import '../../src/widgets/box_input_field.dart';
import '../core/domaine/product.dart';
import '../shared/cubit/fetch_product/fetch_products_cubit.dart';
import '../shared/cubit/update_product/update_product_cubit.dart';

buildBottomSheetForEditProduct(
  BuildContext context,
  GlobalKey<FormState> formKey,
  Product product,
  TextEditingController labelTextFieldController,
  TextEditingController priceTextFieldController,
) {
  labelTextFieldController.text = product.label ?? '';
  priceTextFieldController.text = product.price.toString();
  return showBottomSheet(
    context: context,
    builder: (context) => BlocListener<UpdateProductCubit, UpdateProductState>(
      listener: (context, updateProductState) {
        if (updateProductState is UpdateProductError) {
          String errorKey = ErrorMessage.determineMessageKey(
            updateProductState.message,
          );
          buidSnackbar(
            context: context,
            backgroundColor: Colors.red,
            text: ErrorMessage.errorMessages[errorKey] ??
                'Une erreur a eu lieu. Veuillez réessayer',
          );
        }
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
        height: MediaQuery.of(context).size.height / 2.9,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
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
            const SizedBox(height: 20),
            SizedBox(
              height: 40,
              child: BoxInputField.text(
                controller: labelTextFieldController,
                labelText: "Label du produit",
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Label est obligatoire';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 40,
              child: BoxInputField.number(
                controller: priceTextFieldController,
                labelText: "Prix du produit",
                validator: (value) {
                  return null;
                },
              ),
            ),
            const SizedBox(height: 16),
            BlocBuilder<UpdateProductCubit, UpdateProductState>(
              builder: (context, updateProductCubit) {
                return BoxButton.normal(
                  width: MediaQuery.of(context).size.width,
                  isBusy: (updateProductCubit is UpdateProductUpdated)
                      ? true
                      : false,
                  title: 'Enregistrer',
                  onTap: () {
                    context.read<UpdateProductCubit>().updateProduct(
                          label: labelTextFieldController.text,
                          productId: product.id ?? '',
                          price: double.parse(priceTextFieldController.text),
                        );
                  },
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
}
