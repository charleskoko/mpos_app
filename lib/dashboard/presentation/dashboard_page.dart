import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mpos_app/core/shared/time_formater.dart';
import '../../authentication/infrastructures/authentication_cubit.dart';
import '../../src/shared/app_colors.dart';
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
      body: BlocListener<AuthenticationCubit, AuthenticationState>(
        listener: (context, authenticationState) {
          if (authenticationState is AuthenticationNotValidated) {
            context.goNamed('login');
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          child: BlocBuilder<DashboardCubit, DashboardState>(
            builder: (context, dashbboardState) {
              return Column(
                children: [
                  BoxText.caption(TimeFormater().myDateFormat(DateTime.now())),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xffF4E9F3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFE9DFE8),
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                              ),
                              height: 60,
                              width: 60,
                              child: const Center(
                                child: Icon(Ionicons.receipt_outline),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 40,
                            child: BoxText.subheading(
                              'Ventes',
                              color: Colors.grey.shade500,
                            ),
                          ),
                          Positioned(
                            bottom: 5,
                            child: BoxText.headingThree(
                              '${dashbboardState.numberOfSalesOfTheDay}',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6E8EA),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8DDDF),
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                              ),
                              height: 60,
                              width: 60,
                              child: const Center(
                                child: Icon(Ionicons.cash_outline),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 40,
                            child: BoxText.subheading(
                              'Recette',
                              color: Colors.grey.shade500,
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            child: Row(
                              children: [
                                BoxText.caption(
                                  'XOF',
                                  color: Colors.grey.shade500,
                                ),
                                const SizedBox(height: 5),
                                BoxText.headingThree(
                                  '${dashbboardState.incomeOftheday}',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
