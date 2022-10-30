import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/shared/mixin_scaffold.dart';
import '../../core/shared/mixin_validation.dart';
import '../../not_processed_order/shared/cubit/store_not_processed_order_cubit.dart';
import '../../src/shared/app_colors.dart';
import '../../src/widgets/box_button.dart';
import '../../src/widgets/box_input_field.dart';
import '../shared/cubit/selected_order_item_cubit.dart';

class SaveNewTicketPage extends StatefulWidget {
  const SaveNewTicketPage({Key? key}) : super(key: key);

  @override
  State<SaveNewTicketPage> createState() => _SaveNewTicketPageState();
}

class _SaveNewTicketPageState extends State<SaveNewTicketPage>
    with ValidationMixin, ScaffoldMixin {
  TextEditingController ticketLabelFieldController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(color: kPrimaryColor),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Nouveau ticket',
          style: TextStyle(
            fontSize: 22,
            fontFamily: 'Poppins-Regular',
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocListener<StoreNotProcessedOrderCubit,
          StoreNotProcessedOrderState>(
        listener: (context, storeNotProcessedOrderState) {
          if (storeNotProcessedOrderState is StoreNotProcessedOrderLoaded) {
            context.goNamed('main', params: {'tab': '1'});
          }
        },
        child: Container(
          margin: const EdgeInsets.only(
            top: 150,
            left: 21,
            right: 21,
          ),
          child: Form(
              key: formKey,
              child: Column(
                children: [
                  BoxInputField.text(
                    autofocus: true,
                    controller: ticketLabelFieldController,
                    labelText: 'Nom du ticket',
                    validator: (text) {
                      return isTextfieldNotEmpty(text)
                          ? null
                          : 'Veuillez entrer un nom de ticket valide';
                    },
                  ),
                  const SizedBox(height: 20),
                  BoxButton.main(
                      isBusy: false,
                      title: 'Enregistrer',
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          var state =
                              context.read<SelectedOrderItemCubit>().state;
                          context.read<StoreNotProcessedOrderCubit>().store(
                              label: ticketLabelFieldController.text,
                              orderItems: state.selectedOrderItem!);
                        }
                      }),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
