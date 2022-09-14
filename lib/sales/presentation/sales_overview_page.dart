import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/shared/error_message.dart';
import '../../core/shared/time_formater.dart';
import '../../invoices/core/domain/invoice.dart';
import '../../invoices/shared/fetch_invoice_cubit.dart';
import '../../src/shared/app_colors.dart';
import '../../src/widgets/box_loading.dart';
import '../../src/widgets/box_message.dart';
import '../../src/widgets/box_sale.dart';
import '../../src/widgets/box_text.dart';
import '../shared/sale_details_cubit.dart';

class SalesOverviewPage extends StatefulWidget {
  const SalesOverviewPage({Key? key}) : super(key: key);

  @override
  State<SalesOverviewPage> createState() => _SalesOverviewPage();
}

class _SalesOverviewPage extends State<SalesOverviewPage> {
  @override
  void initState() {
    context.read<FetchInvoiceCubit>().fetchInvoice();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: BoxText.headingTwo(
          'Reçus'.toUpperCase(),
          color: kThreeColor,
        ),
      ),
      body: BlocBuilder<FetchInvoiceCubit, FetchInvoiceState>(
        builder: (context, fetchInvoiceState) {
          if (fetchInvoiceState is FetchInvoiceLoading) {
            return const BoxLoading();
          }
          if (fetchInvoiceState is FetchInvoiceLoaded) {
            List<Invoice> invoices = fetchInvoiceState.invoices;
            return Column(
              children: [
                BoxText.caption(TimeFormater().myDateFormat(DateTime.now())),
                const SizedBox(height: 10),
                if (invoices.isNotEmpty)
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                      ),
                      child: ListView.separated(
                        itemCount: invoices.length,
                        itemBuilder: (BuildContext context, index) =>
                            GestureDetector(
                          onTap: () {
                            context
                                .read<SaleDetailsCubit>()
                                .show(invoices[index]);
                            context.goNamed('salesDetails');
                          },
                          child: BoxSale(invoice: invoices[index]),
                        ),
                        separatorBuilder: (context, index) {
                          return const Divider(
                            color: kPrimaryColor,
                          );
                        },
                      ),
                    ),
                  ),
                if (invoices.isEmpty)
                  const Expanded(
                    child: BoxMessage(message: "Aucun reçu généré"),
                  )
              ],
            );
          }
          if (fetchInvoiceState is FetchInvoiceError) {
            return BoxMessage(
              message:
                  '${ErrorMessage.errorMessages['${fetchInvoiceState.message}']}',
            );
          }
          return Container();
        },
      ),
    );
  }
}
