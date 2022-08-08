import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        if (deleteProductState is DeleteProductError) {}
        if (deleteProductState is DeleteProductDeleted) {
          Navigator.pop(context);
          context.read<FetchProductsCubit>().fetchProductList();
        }
      },
      child: AlertDialog(
        title: BoxText.headingTwo('Attention', color: kPrimaryColor),
        content: BoxText.body(
            'Voulez-vous vraiment supprimer cette article? \n${product?.label}'),
        actions: [
          TextButton(
            child: BoxText.body(
              'Annuler',
              color: Colors.grey.shade500,
            ),
            onPressed: () {
              Navigator.pop(context);
              context.read<FetchProductsCubit>().fetchProductList();
            },
          ),
          TextButton(
            child: BoxText.body('oui'),
            onPressed: () {
              context.read<DeleteProductCubit>().deleteProduct(
                    product?.id ?? '',
                  );
            },
          )
        ],
      ),
    ),
  );
}
