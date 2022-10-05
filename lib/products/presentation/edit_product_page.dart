import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import '../../core/shared/mixin_scaffold.dart';
import '../../core/shared/mixin_validation.dart';
import '../../src/shared/app_colors.dart';
import '../../src/widgets/box_button.dart';
import '../../src/widgets/box_input_field.dart';
import '../shared/cubit/show_product/show_product_cubit.dart';
import '../shared/cubit/store_product/store_product_cubit.dart';

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
          bottomSheet: BlocBuilder<StoreProductCubit, StoreProductState>(
            builder: (context, storeProductState) {
              return Container(
                margin: const EdgeInsets.only(
                  bottom: 50,
                  left: 30,
                  right: 30,
                ),
                child: BoxButton.main(
                    isBusy: (storeProductState is StoreProductLoading)
                        ? true
                        : false,
                    title: 'Enregistrer',
                    onTap: () {}),
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
            title: Text(
              '${showProductState.product?.label!}',
              style: const TextStyle(
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
        );
      },
    );
  }
}
