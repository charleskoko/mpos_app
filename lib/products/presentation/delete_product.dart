import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/presentation/snack_bar.dart';
import '../../core/shared/error_message.dart';
import '../../src/shared/app_colors.dart';
import '../../src/widgets/box_text.dart';
import '../core/domaine/product.dart';
import '../shared/cubit/delete_product/delete_product_cubit.dart';
import '../shared/cubit/fetch_product/fetch_products_cubit.dart';

buildAlertDialogeForDeleteProduct(BuildContext context, Product? product) {
  showDialog(
    context: context,
    builder: (context) => BlocListener<DeleteProductCubit, DeleteProductState>(
      listener: (context, deleteProductState) {
        if (deleteProductState is DeleteProductError) {
          String errorKey = ErrorMessage.determineMessageKey(
              deleteProductState.message ?? '');
          buidSnackbar(
            context: context,
            backgroundColor: Colors.red,
            text: ErrorMessage.errorMessages[errorKey] ??
                'Une erreur a eu lieu. Veuillez réessayer',
          );
        }
        if (deleteProductState is DeleteProductDeleted) {
          buidSnackbar(
            context: context,
            backgroundColor: Colors.green,
            text: 'Le produit a été supprimé avec succès',
          );
          Navigator.pop(context);
          context.read<FetchProductsCubit>().fetchProductList();
        }
      },
      child: AlertDialog(
        title: BoxText.headingTwo('Attention', color: kPrimaryColor),
        content: BoxText.body(
            'Voulez-vous vraiment supprimer cet article? \n${product?.label}'),
        actions: [
          TextButton(
            child: BoxText.body(
              'Annuler',
              color: Colors.grey.shade500,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: BoxText.body('oui'),
            onPressed: () {
              context.read<DeleteProductCubit>().deleteProduct(
                    product!,
                  );
            },
          )
        ],
      ),
    ),
  );
}
