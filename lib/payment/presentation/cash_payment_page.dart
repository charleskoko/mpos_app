import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mpos_app/src/shared/app_colors.dart';

import '../../core/shared/mixin_scaffold.dart';
import '../../core/shared/mixin_validation.dart';
import '../../not_processed_order/shared/cubit/delete_not_processed_order_cubit.dart';
import '../../not_processed_order/shared/cubit/fetch_not_processed_order_cubit.dart';
import '../../orders/shared/cubit/selected_order_item_cubit.dart';
import '../../orders/shared/cubit/store_order_cubit.dart';
import '../../src/widgets/box_button.dart';
import '../../src/widgets/box_input_field.dart';

class CashPaymentPage extends StatefulWidget {
  final double sum;
  final String isNotProcessedOrder;

  const CashPaymentPage(
      {Key? key, required this.sum, required this.isNotProcessedOrder})
      : super(key: key);

  @override
  State<CashPaymentPage> createState() => _CashPaymentPageState();
}

class _CashPaymentPageState extends State<CashPaymentPage>
    with ValidationMixin, ScaffoldMixin {
  TextEditingController paymentTextFieldController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late String orderType;
  @override
  void initState() {
    paymentTextFieldController.text = '${widget.sum}';
    orderType = widget.isNotProcessedOrder;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: kPrimaryColor,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          '${widget.sum} FCFA en espèces',
          style: const TextStyle(
            fontFamily: 'Poppins-bold',
            color: kPrimaryColor,
            fontSize: 20,
          ),
        ),
        leading: const BackButton(
          color: kPrimaryColor,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocListener<StoreOrderCubit, StoreOrderState>(
        listener: (context, storeOrderCubit) {
          if (storeOrderCubit is StoreOrderLoaded) {
            context.goNamed(
              'receiptOptions',
              params: {
                'tab': '0',
                'orderId': storeOrderCubit.order.id ?? '',
                'sum': '${widget.sum}',
                'cash': paymentTextFieldController.text,
                'origin': 'paiementPage'
              },
            );
            if (orderType == 'true') {
              context
                  .read<DeleteNotProcessedOrderCubit>()
                  .delete(storeOrderCubit.notProcessedOrder!);
              context
                  .read<FetchNotProcessedOrderCubit>()
                  .index(id: storeOrderCubit.notProcessedOrder?.id ?? '');
            }
          }
        },
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 21, right: 21, top: 20),
                child: BoxInputField.number(
                  autofocus: true,
                  controller: paymentTextFieldController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Entrez un montant valide';
                    } else {
                      double? valueTodouble = double.tryParse(value);
                      if (valueTodouble! < widget.sum) {
                        return 'Entrez un montant superieur ou égale a la somme total';
                      }
                      return null;
                    }
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 21, right: 21, top: 10),
                child: BoxButton.main(
                  isBusy: false,
                  title: 'Encaisser',
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      var state = context.read<SelectedOrderItemCubit>().state;
                      context.read<StoreOrderCubit>().store(
                            state.selectedOrderItem!,
                            isNotProcessedOrder:
                                (widget.isNotProcessedOrder == 'false')
                                    ? false
                                    : true,
                            notProcessedOrder: state.notProcessedOrder,
                          );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
