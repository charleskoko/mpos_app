import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mpos_app/src/widgets/box_text.dart';
import '../../invoices/core/domain/invoice.dart';

class BoxSale extends StatelessWidget {
  final Invoice invoice;

  const BoxSale({
    Key? key,
    required this.invoice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: BoxText.body(
        '#' + '${invoice.number}'.padLeft(10, '0'),
        fontWeight: FontWeight.bold,
      ),
      trailing: BoxText.body(
        DateFormat.Hm().format(
          invoice.createdAt ?? DateTime.now(),
        ),
      ),
      subtitle: BoxText.body(
        '${invoice.total()} XOF',
        color: Colors.grey.shade700,
      ),
    );
  }
}
