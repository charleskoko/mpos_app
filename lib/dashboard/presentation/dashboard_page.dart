import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mpos_app/custom_calendar/infrastructures/calendar_cubit.dart';
import '../../authentication/infrastructures/authentication_cubit.dart';
import '../../core/presentation/snack_bar.dart';
import '../../core/shared/error_messages.dart';
import '../../core/shared/time_formater.dart';
import '../../invoices/shared/fetch_invoice_cubit.dart';
import '../../src/shared/app_colors.dart';
import '../../src/widgets/box_loading.dart';
import '../shared/cubit/dashboard_cubit.dart';
import '../shared/dashboard_info_transformator.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late String _timeString;
  late String _selectedDate;
  bool isBrutto = true;
  String duration = '1j';

  @override
  void initState() {
    _timeString = _formatDateTime(DateTime.now());
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
    context.read<DashboardCubit>().dashboardData(
          selectedDate: TimeFormater().formatDateForBackend(
              DateTime.now().day, DateTime.now().month, DateTime.now().year),
          period: duration,
        );
    context.read<CalendarCubit>().getMonth(
          DateTime.now().month,
          DateTime.now().year,
        );
    _selectedDate = TimeFormater().formatDateForBackend(
        DateTime.now().day, DateTime.now().month, DateTime.now().year);
    super.initState();
  }

  Map<String, int> _getNextMonth(int month, int year) {
    if (month == 12) {
      return {'month': 1, 'year': year + 1};
    }
    return {'month': month + 1, 'year': year};
  }

  Map<String, int> _getPreviousMonth(int month, int year) {
    if (month == 1) {
      return {'month': 12, 'year': year - 1};
    }
    return {'month': month - 1, 'year': year};
  }

  void _getTime() {
    if (!mounted) return;
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const BackButton(
          color: kPrimaryColor,
        ),
        title: const Text(
          'Rapport de vente',
          style: TextStyle(
            fontSize: 22,
            fontFamily: 'Poppins-Regular',
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: MultiBlocListener(
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
                      text: ErrorMessages.errorMessages(
                          fetchInvoiceState.message!),
                    );
                  }
                },
              ),
            ],
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade300),
                      bottom: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: TextButton(
                    onPressed: () => showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) =>
                          BlocBuilder<CalendarCubit, CalendarState>(
                        builder: (context, calendarState) {
                          return StatefulBuilder(builder:
                              (BuildContext context, StateSetter setState) {
                            return Container(
                              padding: const EdgeInsets.only(
                                top: 39,
                              ),
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  topLeft: Radius.circular(10),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade300,
                                    blurRadius: 2,
                                    spreadRadius: 2,
                                    offset:
                                        const Offset(1, 2), // Shadow position
                                  ),
                                ],
                              ),
                              child: Column(children: [
                                Container(
                                    margin: const EdgeInsets.only(bottom: 30),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey.shade300),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          child: IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: Icon(Ionicons.close),
                                          ),
                                        ),
                                        const Expanded(
                                          child: Center(
                                            child: Text('Personnaliser rapport',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto-Regular',
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                          ),
                                        ),
                                        Container(
                                          color: kPrimaryColor,
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              context
                                                  .read<DashboardCubit>()
                                                  .dashboardData(
                                                    selectedDate: _selectedDate,
                                                    period: duration,
                                                  );
                                            },
                                            child: const Text(
                                              'OK',
                                              style: TextStyle(
                                                fontFamily: 'Roboto-Regular',
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )),
                                Row(children: [
                                  IconButton(
                                    onPressed: () {
                                      Map<String, dynamic> prevMonth =
                                          _getPreviousMonth(
                                        calendarState.month!,
                                        calendarState.year!,
                                      );
                                      context.read<CalendarCubit>().getMonth(
                                            prevMonth['month']!,
                                            prevMonth['year'],
                                          );
                                    },
                                    icon: const Icon(
                                      Ionicons.chevron_back_outline,
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                  Expanded(
                                    child: AnimatedContainer(
                                      duration: const Duration(seconds: 10),
                                      child: Center(
                                        child: Text(
                                          '${TimeFormater().months[calendarState.month! - 1]} ${calendarState.year}',
                                          style: const TextStyle(
                                            fontFamily: 'Roboto-Regular',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Map<String, int> nextMonth =
                                          _getNextMonth(
                                        calendarState.month!,
                                        calendarState.year!,
                                      );
                                      if (calendarState.month! >=
                                              DateTime.now().month &&
                                          calendarState.year! ==
                                              DateTime.now().year) {
                                      } else {
                                        context.read<CalendarCubit>().getMonth(
                                              nextMonth['month']!,
                                              nextMonth['year']!,
                                            );
                                      }
                                    },
                                    icon: Icon(
                                      (calendarState.month! >=
                                                  DateTime.now().month &&
                                              calendarState.year! ==
                                                  DateTime.now().year)
                                          ? null
                                          : Ionicons.chevron_forward_outline,
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                ]),
                                const SizedBox(height: 36.55),
                                SizedBox(
                                  height: 200,
                                  width: 315,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: const [
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                'L',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto-Regular',
                                                  fontSize: 15,
                                                  color: kPrimaryColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                'M',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto-Regular',
                                                  fontSize: 15,
                                                  color: kPrimaryColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                'M',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto-Regular',
                                                  fontSize: 15,
                                                  color: kPrimaryColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                'J',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto-Regular',
                                                  fontSize: 15,
                                                  color: kPrimaryColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                'V',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto-Regular',
                                                  fontSize: 15,
                                                  color: kPrimaryColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                'S',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto-Regular',
                                                  fontSize: 15,
                                                  color: kPrimaryColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                'D',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto-Regular',
                                                  fontSize: 15,
                                                  color: kPrimaryColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      GridView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          gridDelegate:
                                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                            maxCrossAxisExtent: 50,
                                            childAspectRatio: 3 / 2,
                                          ),
                                          itemCount:
                                              calendarState.monthDays?.length,
                                          itemBuilder:
                                              (BuildContext context, index) {
                                            int day = calendarState
                                                .monthDays![index].date.day;
                                            bool isThisMonth = calendarState
                                                .monthDays![index].thisMonth;
                                            bool isToday = ((calendarState
                                                        .monthDays![index]
                                                        .date
                                                        .day ==
                                                    DateTime.now().day) &&
                                                (calendarState.monthDays![index]
                                                        .date.month ==
                                                    DateTime.now().month) &&
                                                (calendarState.monthDays![index]
                                                        .date.year ==
                                                    DateTime.now().year));
                                            return (calendarState
                                                    .monthDays![index]
                                                    .thisMonth)
                                                ? GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        _selectedDate = TimeFormater()
                                                            .formatDateForBackend(
                                                                calendarState
                                                                    .monthDays![
                                                                        index]
                                                                    .date
                                                                    .day,
                                                                calendarState
                                                                    .month,
                                                                calendarState
                                                                    .year);
                                                      });
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color:
                                                            ((_selectedDate ==
                                                                    TimeFormater()
                                                                        .formatDateForBackend(
                                                                      calendarState
                                                                          .monthDays![
                                                                              index]
                                                                          .date
                                                                          .day,
                                                                      calendarState
                                                                          .month!,
                                                                      calendarState
                                                                          .year!,
                                                                    )))
                                                                ? kPrimaryColor
                                                                : null,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          calendarState
                                                              .monthDays![index]
                                                              .date
                                                              .day
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Roboto-Regular',
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: (_selectedDate ==
                                                                    TimeFormater().formatDateForBackend(
                                                                      calendarState
                                                                          .monthDays![
                                                                              index]
                                                                          .date
                                                                          .day,
                                                                      calendarState
                                                                          .month!,
                                                                      calendarState
                                                                          .year!,
                                                                    ))
                                                                ? Colors.white
                                                                : (isThisMonth)
                                                                    ? Colors.black
                                                                    : const Color(
                                                                        0xFFBDBDBD,
                                                                      ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Container();
                                          })
                                    ],
                                  ),
                                ),
                              ]),
                            );
                          });
                        },
                      ),
                    ),
                    child: Text(
                      TimeFormater().dashboardDate(DateTime.parse(
                          TimeFormater().formatDateString(_selectedDate))),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor,
                        fontSize: 14,
                        fontFamily: 'Poppins-Regular',
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Row(children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            duration = '1j';
                          });
                          context.read<DashboardCubit>().dashboardData(
                                selectedDate: _selectedDate,
                                period: duration,
                              );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: (duration == '1j')
                                    ? kPrimaryColor
                                    : Colors.grey.shade300,
                                width: 2,
                              ),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              '1J',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kPrimaryColor,
                                fontSize: 12,
                                fontFamily: 'Poppins-bold',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            duration = '1s';
                          });
                          context.read<DashboardCubit>().dashboardData(
                                selectedDate: _selectedDate,
                                period: duration,
                              );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: (duration == '1s')
                                    ? kPrimaryColor
                                    : Colors.grey.shade300,
                                width: 2,
                              ),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              '1S',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kPrimaryColor,
                                fontSize: 12,
                                fontFamily: 'Poppins-bold',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            duration = '1m';
                          });
                          context.read<DashboardCubit>().dashboardData(
                                selectedDate: _selectedDate,
                                period: duration,
                              );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: (duration == '1m')
                                    ? kPrimaryColor
                                    : Colors.grey.shade300,
                                width: 2,
                              ),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              '1M',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kPrimaryColor,
                                fontSize: 12,
                                fontFamily: 'Poppins-bold',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              duration = '3m';
                            });
                            context.read<DashboardCubit>().dashboardData(
                                  selectedDate: _selectedDate,
                                  period: duration,
                                );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: (duration == '3m')
                                      ? kPrimaryColor
                                      : Colors.grey.shade300,
                                  width: 2,
                                ),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                '3M',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: kPrimaryColor,
                                  fontSize: 12,
                                  fontFamily: 'Poppins-bold',
                                ),
                              ),
                            ),
                          )),
                    ),
                    Expanded(
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              duration = '1a';
                            });
                            context.read<DashboardCubit>().dashboardData(
                                  selectedDate: _selectedDate,
                                  period: duration,
                                );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: (duration == '1a')
                                      ? kPrimaryColor
                                      : Colors.grey.shade300,
                                  width: 2,
                                ),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                '1A',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: kPrimaryColor,
                                  fontSize: 12,
                                  fontFamily: 'Poppins-bold',
                                ),
                              ),
                            ),
                          )),
                    ),
                  ]),
                ),
                BlocBuilder<DashboardCubit, DashboardState>(
                  builder: (context, dashboardState) {
                    if (dashboardState is DashboardInfoLoaded) {
                      return Expanded(
                        child: ListView(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                top: 20,
                                left: 21,
                                right: 21,
                              ),
                              alignment: Alignment.centerLeft,
                              width: MediaQuery.of(context).size.width,
                              child: const Text(
                                "RÉCAPUTILATIF DES VENTES: VUE D'ENSEMBLE DES VENTES",
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 13,
                                  fontFamily: 'Poppins-bold',
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 18, right: 18, top: 20),
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${dashboardState.incomeOftThePeriod} FCFA',
                                      style: const TextStyle(
                                        fontFamily: 'Poppins-light',
                                        fontSize: 18,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${dashboardState.numberOfSalesOfThePeriod}',
                                      style: const TextStyle(
                                        fontFamily: 'Poppins-light',
                                        fontSize: 18,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.only(left: 18, right: 18),
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade300),
                                        ),
                                      ),
                                      child: Text(
                                        'Ventes brutes',
                                        style: TextStyle(
                                          fontFamily: 'Poppins-light',
                                          fontSize: 11,
                                          color: Colors.grey.shade800,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade300),
                                        ),
                                      ),
                                      child: Text(
                                        'Total des ventes',
                                        style: TextStyle(
                                          fontFamily: 'Poppins-light',
                                          fontSize: 11,
                                          color: Colors.grey.shade800,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 18, right: 18, top: 20),
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${dashboardState.refundOfThePeriod} FCFA',
                                      style: const TextStyle(
                                        fontFamily: 'Poppins-light',
                                        fontSize: 18,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${dashboardState.numberOfRefundOfThePeriod}',
                                      style: const TextStyle(
                                        fontFamily: 'Poppins-light',
                                        fontSize: 18,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.only(left: 18, right: 18),
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade300),
                                        ),
                                      ),
                                      child: Text(
                                        'Remboursements',
                                        style: TextStyle(
                                          fontFamily: 'Poppins-light',
                                          fontSize: 11,
                                          color: Colors.grey.shade800,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade300),
                                        ),
                                      ),
                                      child: Text(
                                        'Total des Remboursements',
                                        style: TextStyle(
                                          fontFamily: 'Poppins-light',
                                          fontSize: 11,
                                          color: Colors.grey.shade800,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                top: 20,
                                left: 21,
                                right: 21,
                              ),
                              margin: const EdgeInsets.only(bottom: 10),
                              alignment: Alignment.centerLeft,
                              width: MediaQuery.of(context).size.width,
                              child: const Text(
                                "ARTICLES VENDUS",
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 13,
                                  fontFamily: 'Poppins-bold',
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: kPrimaryColor),
                                ),
                                margin: const EdgeInsets.only(
                                    left: 21, right: 21, bottom: 10),
                                height: 40,
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        color: (isBrutto)
                                            ? kPrimaryColor
                                            : Colors.white,
                                        child: TextButton(
                                            onPressed: () {
                                              setState(() {
                                                isBrutto = !isBrutto;
                                              });
                                            },
                                            child: Text(
                                              'Brut',
                                              style: TextStyle(
                                                color: isBrutto
                                                    ? Colors.white
                                                    : kPrimaryColor,
                                                fontSize: 13,
                                                fontFamily: 'Poppins-bold',
                                              ),
                                            )),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        color: (!isBrutto)
                                            ? kPrimaryColor
                                            : Colors.white,
                                        child: TextButton(
                                            onPressed: () {
                                              setState(() {
                                                isBrutto = !isBrutto;
                                              });
                                            },
                                            child: Text(
                                              'Nombre',
                                              style: TextStyle(
                                                color: !isBrutto
                                                    ? Colors.white
                                                    : kPrimaryColor,
                                                fontSize: 13,
                                                fontFamily: 'Poppins-bold',
                                              ),
                                            )),
                                      ),
                                    ),
                                  ],
                                )),
                            Wrap(children: [
                              for (DashboardProductList dashboardProductList
                                  in dashboardState.products!)
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        width: 0.5,
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                  ),
                                  margin: const EdgeInsets.only(
                                      left: 21, right: 21),
                                  child: Row(children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        dashboardProductList.productLabel!,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Poppins-Regular',
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                (isBrutto)
                                                    ? '${dashboardProductList.total}'
                                                    : '${dashboardProductList.numberOfOrder}',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Poppins-Regular',
                                                ),
                                                textAlign: TextAlign.right,
                                              ),
                                            ),
                                            if (isBrutto)
                                              const Text(
                                                ' FCFA',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontFamily: 'Poppins-Regular',
                                                ),
                                                textAlign: TextAlign.right,
                                              )
                                          ],
                                        ),
                                      ),
                                    )
                                  ]),
                                )
                            ])
                          ],
                        ),
                      );
                    }
                    return const Expanded(child: BoxLoading());
                  },
                )
              ],
            )),
      ),
    );
  }
}
