import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/presentation/snack_bar.dart';
import '../../core/shared/error_message.dart';
import '../../src/shared/app_colors.dart';
import '../../src/shared/styles.dart';
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
        contentPadding: EdgeInsets.zero,
        //BoxText.headingTwo('Attention', color: kPrimaryColor),
        content: Container(
          color: kScaffoldBackgroundColor,
          height: 200,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                color: kAppBarBackgroundColor,
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                child: Text(
                  'Attention',
                  style: subheadingStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: 16,
                ),
                child: Center(
                    child: BoxText.body(
                        'Voulez-vous vraiment supprimer ce produit?')),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                                border: Border(
                              right: BorderSide(color: Colors.white),
                            )),
                            child: Center(
                              child: BoxText.body(
                                'Annuler',
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
                            context.read<DeleteProductCubit>().deleteProduct(
                                  product!,
                                );
                          },
                          child: Center(
                            child: BoxText.body(
                              'Confirmer',
                              fontWeight: FontWeight.bold,
                              color: kAppBarBackgroundColor,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
