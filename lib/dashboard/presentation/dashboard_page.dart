import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mpos_app/core/shared/time_formater.dart';
import '../../authentication/infrastructures/authentication_cubit.dart';
import '../../core/presentation/snack_bar.dart';
import '../../core/shared/error_message.dart';
import '../../invoices/shared/fetch_invoice_cubit.dart';
import '../../src/shared/app_colors.dart';
import '../../src/widgets/box_dashboard_info.dart';
import '../../src/widgets/box_text.dart';
import '../shared/dashboard_cubit.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    context.read<DashboardCubit>().dashboardData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        centerTitle: true,
        elevation: 0,
        title: BoxText.headingTwo(
          'Boutique'.toUpperCase(),
          color: kThreeColor,
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthenticationCubit>().logout();
            },
            icon: const Icon(
              Ionicons.log_out_outline,
              color: kPrimaryColor,
            ),
          )
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthenticationCubit, AuthenticationState>(
            listener: (context, authenticationState) {
              if (authenticationState is AuthenticationNotValidated) {
                context.goNamed('login');
              }
            },
          ),
          BlocListener<FetchInvoiceCubit, FetchInvoiceState>(
            listener: (context, fetchInvoiceState) {
              if (fetchInvoiceState is FetchInvoiceError) {
                buidSnackbar(
                  context: context,
                  backgroundColor: Colors.red,
                  text: ErrorMessage.errorMessages[fetchInvoiceState.message] ??
                      '',
                );
              }
            },
          ),
        ],
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          child: BlocBuilder<DashboardCubit, DashboardState>(
            builder: (context, dashbboardState) {
              return Column(
                children: [
                  BoxText.caption(
                    TimeFormater().myDateFormat(
                      DateTime.now(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: BoxDashboardInfo.salesDetails(
                        data: '${dashbboardState.numberOfSalesOfTheDay}'),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Expanded(
                    child: BoxDashboardInfo.salesTotal(
                        data: '${dashbboardState.incomeOftheday}'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
