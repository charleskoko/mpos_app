import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ionicons/ionicons.dart';
import '../../core/presentation/snack_bar.dart';
import '../../core/shared/error_messages.dart';
import '../../core/shared/mixin_scaffold.dart';
import '../../core/shared/mixin_validation.dart';
import '../../src/shared/app_colors.dart';
import '../../src/widgets/box_button.dart';
import '../../src/widgets/box_input_field.dart';
import '../../src/widgets/box_text.dart';
import '../core/domaine/product.dart';
import '../shared/cubit/fetch_product/fetch_products_cubit.dart';
import '../shared/cubit/store_product/store_product_cubit.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({Key? key}) : super(key: key);

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage>
    with ValidationMixin, ScaffoldMixin {
  TextEditingController productLabelController = TextEditingController();
  TextEditingController salePriceController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<StoreProductCubit, StoreProductState>(
          listener: (context, storeProductState) {
            if (storeProductState is StoreProductError) {
              ;
              Fluttertoast.showToast(
                gravity: ToastGravity.TOP,
                backgroundColor: Colors.red,
                msg: ErrorMessages.errorMessages(storeProductState.message!),
              );
            }
            if (storeProductState is StoreProductStored) {
              Fluttertoast.showToast(
                gravity: ToastGravity.TOP,
                backgroundColor: kPrimaryColor,
                msg: 'Nouveau produit ajouté avec succès',
              );
              context.read<FetchProductsCubit>().fetchProductList();
              Navigator.pop(context);
              // Navigator.pop(context);
              // context.read<FetchProductsCubit>().fetchProductList();
              // labelTextFieldController.text = '';
              // priceTextFieldController.text = '';
              // buidSnackbar(
              //   context: context,
              //   backgroundColor: Colors.green,
              //   text: 'Nouveau produit ajouté avec succès',
              // );

            }
          },
        ),
      ],
      child: Scaffold(
        bottomSheet: BlocBuilder<StoreProductCubit, StoreProductState>(
          builder: (context, storeProductState) {
            return Container(
              margin: const EdgeInsets.only(
                bottom: 50,
                left: 30,
                right: 30,
              ),
              child: BoxButton.main(
                  isBusy:
                      (storeProductState is StoreProductLoading) ? true : false,
                  title: 'Enregistrer',
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      Product product = Product(
                        label: productLabelController.text,
                        salePrice: double.tryParse(
                          salePriceController.text,
                        ),
                        purchasePrice: double.tryParse(
                          salePriceController.text,
                        ),
                      );
                      context.read<StoreProductCubit>().storeProduct(product);
                    }
                  }),
            );
          },
        ),
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Center(
                child: Icon(Ionicons.chevron_back, color: kPrimaryColor),
              ),
            ),
          ),
          backgroundColor: const Color(0xFFF5F5F5),
          title: const Text(
            'AJOUTER UN ARTICLE',
            style: TextStyle(
              fontSize: 24,
              fontFamily: 'Poppins-Regular',
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: ListView(
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
                          return isNumeric<int>(int.tryParse(productPrice))
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
  }
}
