import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mpos_app/src/widgets/box_button.dart';
import 'package:mpos_app/src/widgets/box_text.dart';

class SaveOrderStatus extends StatefulWidget {
  const SaveOrderStatus({Key? key}) : super(key: key);

  @override
  State<SaveOrderStatus> createState() => _SaveOrderStatusState();
}

class _SaveOrderStatusState extends State<SaveOrderStatus> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
        ],
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.only(top: 5),
            width: 100,
            height: 5,
          ),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: Icon(
                  Ionicons.checkmark_circle,
                  color: Colors.green,
                ),
              ),
              BoxText.caption("Achat enregistré avec succés"),
              const SizedBox(height: 40),
              BoxButton(
                title: 'Imprimer le réçu',
                onTap: () {
                  context.goNamed('printPage');
                },
              )
            ],
          ))
        ],
      ),
    );
  }
}
