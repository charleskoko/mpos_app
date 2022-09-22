import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mpos_app/src/widgets/box_text.dart';

import '../../core/presentation/snack_bar.dart';
import '../shared/cubit/selected_order_item_cubit.dart';
import '../shared/cubit/store_order_cubit.dart';

class SaveOrderStatus extends StatefulWidget {
  const SaveOrderStatus({Key? key}) : super(key: key);

  @override
  State<SaveOrderStatus> createState() => _SaveOrderStatusState();
}

class _SaveOrderStatusState extends State<SaveOrderStatus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<StoreOrderCubit, StoreOrderState>(
        listener: (context, storeOrderState) {
          if (storeOrderState is StoreOrderLoaded) {
            context.read<SelectedOrderItemCubit>().cancelCurrentSelection();
            Navigator.pop(context);
          }
          if (storeOrderState is StoreOrderError) {
            context.goNamed('orderVerification');
            buidSnackbar(
                context: context,
                text: storeOrderState.message ??
                    'Une erreur a eu lieu. Veuillez réessayer');
          }
        },
        builder: (context, storeOrderState) {
          if (storeOrderState is StoreOrderLoading) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SpinKitWave(
                    color: Colors.grey.shade300,
                    size: 30.0,
                  ),
                ),
                BoxText.caption("Enregistrement en cours...")
              ],
            );
          }
          if (storeOrderState is StoreOrderLoaded) {
            Navigator.pop(context);
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: Icon(
                    Ionicons.checkmark_circle,
                    color: Colors.green,
                  ),
                ),
                BoxText.caption("Enregistrement terminé")
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}
