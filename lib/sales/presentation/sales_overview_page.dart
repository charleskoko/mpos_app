import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/shared/error_message.dart';
import '../../core/shared/time_formater.dart';
import '../../invoices/core/domain/invoice.dart';
import '../../invoices/shared/fetch_invoice_cubit.dart';
import '../../src/shared/app_colors.dart';
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
        backgroundColor: Colors.white,
        elevation: 0,
        title: BoxText.headingTwo(
          'Ventes'.toUpperCase(),
          color: kThreeColor,
        ),
      ),
      body: BlocBuilder<FetchInvoiceCubit, FetchInvoiceState>(
        builder: (context, fetchInvoiceState) {
          if (fetchInvoiceState is FetchInvoiceLoading) {
            return Center(
              child: SpinKitWave(
                color: Colors.grey.shade300,
                size: 30.0,
              ),
            );
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
                                child: ListTile(
                                  title: BoxText.body(
                                    '#' +
                                        '${invoices[index].number}'
                                            .padLeft(10, '0'),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  trailing: BoxText.body(
                                    DateFormat.Hm().format(
                                      invoices[index].createdAt ??
                                          DateTime.now(),
                                    ),
                                  ),
                                  subtitle: BoxText.body(
                                    '${invoices[index].total()} XOF',
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                          separatorBuilder: (context, index) {
                            return const Divider(
                              color: kPrimaryColor,
                            );
                          }),
                    ),
                  ),
                if (invoices.isEmpty)
                  Expanded(
                      child: Center(
                    child: BoxText.body(
                      "Aucune vente enregistrer pour l'instant",
                      color: Colors.grey.shade500,
                    ),
                  ))
              ],
            );
          }
          if (fetchInvoiceState is FetchInvoiceError) {
            return Center(
              child: BoxText.body(
                '${ErrorMessage.errorMessages['${fetchInvoiceState.message}']}',
                color: Colors.grey.shade500,
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
