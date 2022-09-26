import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mpos_app/custom_calendar/infrastructures/calendar_cubit.dart';
import '../../authentication/infrastructures/authentication_cubit.dart';
import '../../core/presentation/snack_bar.dart';
import '../../core/shared/error_message.dart';
import '../../core/shared/time_formater.dart';
import '../../invoices/shared/fetch_invoice_cubit.dart';
import '../../src/shared/app_colors.dart';
import '../../src/widgets/box_loading.dart';
import '../../src/widgets/box_message.dart';
import '../shared/cubit/dashboard_cubit.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late String _timeString;
  late String _selectedDate;

  @override
  void initState() {
    _timeString = _formatDateTime(DateTime.now());
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
    context.read<DashboardCubit>().dashboardData();
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
    return SafeArea(
      child: Scaffold(
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
                      text: ErrorMessage
                              .errorMessages[fetchInvoiceState.message] ??
                          '',
                    );
                  }
                },
              ),
            ],
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 100,
                        child: Image(
                          image: AssetImage(
                            "assets/images/charly_logo.png",
                          ),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              TimeFormater().dashboardDate((DateTime.now())),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kPrimaryColor,
                                fontSize: 14,
                                fontFamily: 'Poppins-Regular',
                              ),
                            ),
                            Text(
                              '${TimeFormater().dashboardDay(DateTime.now())} | $_timeString',
                              style: const TextStyle(
                                color: kPrimaryColor,
                                fontSize: 14,
                                fontFamily: 'Poppins-Regular',
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 17,
                          top: 15,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            context.read<AuthenticationCubit>().logout();
                          },
                          child: const CircleAvatar(
                            backgroundColor: kPrimaryColor,
                            radius: 25,
                            child: Icon(
                              Ionicons.person_circle_outline,
                              color: Colors.white,
                              size: 45,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                BlocBuilder<DashboardCubit, DashboardState>(
                  builder: (context, dashboardState) {
                    if (dashboardState is DashboardInfoLoaded) {
                      return Expanded(
                          child: Column(children: [
                        const SizedBox(height: 13),
                        Container(
                          margin: const EdgeInsets.only(left: 18, right: 18),
                          width: MediaQuery.of(context).size.width,
                          height: 120,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Stack(
                                    children: [
                                      const Positioned(
                                        left: 20,
                                        top: 13,
                                        child: Icon(Ionicons.wallet,
                                            color: Colors.white, size: 30),
                                      ),
                                      Positioned(
                                        left: 15,
                                        top: 55,
                                        child: Text(
                                          'XOF ${dashboardState.incomeOftheday}',
                                          style: const TextStyle(
                                            fontFamily: 'Poppins-Regular',
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      const Positioned(
                                        left: 9,
                                        bottom: 15,
                                        child: Text(
                                          'Recettes',
                                          style: TextStyle(
                                            fontFamily: 'Poppins-Regular',
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Stack(
                                    children: [
                                      const Positioned(
                                        left: 20,
                                        top: 13,
                                        child: Icon(Ionicons.reader_outline,
                                            color: Colors.white, size: 30),
                                      ),
                                      Positioned(
                                        left: 15,
                                        top: 55,
                                        child: Text(
                                          '${dashboardState.numberOfSalesOfTheDay}',
                                          style: const TextStyle(
                                            fontFamily: 'Poppins-Regular',
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      const Positioned(
                                        left: 9,
                                        bottom: 15,
                                        child: Text(
                                          'Commandes',
                                          style: TextStyle(
                                            fontFamily: 'Poppins-Regular',
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              //
                            ],
                          ),
                        ),
                        const SizedBox(height: 21),
                        Container(
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
                                offset: const Offset(1, 2), // Shadow position
                              ),
                            ],
                          ),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 18,
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.only(
                              top: 12,
                              left: 14,
                            ),
                            height: 40,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 14,
                                  child: RichText(
                                    text: const TextSpan(
                                        style: TextStyle(
                                          fontFamily: 'Poppins-Regular',
                                          color: kPrimaryColor,
                                          fontSize: 16,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: 'Articles ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'commandés',
                                          ),
                                        ]),
                                  ),
                                ),
                                Positioned(
                                  right: 13,
                                  child: GestureDetector(
                                    onTap: () => showBottomSheet(
                                      context: context,
                                      builder: (context) => BlocBuilder<
                                          CalendarCubit, CalendarState>(
                                        builder: (context, calendarState) {
                                          return StatefulBuilder(builder:
                                              (BuildContext context,
                                                  StateSetter setState) {
                                            return Container(
                                              padding: const EdgeInsets.only(
                                                left: 45,
                                                right: 45,
                                                top: 39,
                                              ),
                                              height: 402,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  topLeft: Radius.circular(10),
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey.shade300,
                                                    blurRadius: 2,
                                                    spreadRadius: 2,
                                                    offset: const Offset(1,
                                                        2), // Shadow position
                                                  ),
                                                ],
                                              ),
                                              child: Column(children: [
                                                Row(children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      Map<String, dynamic>
                                                          prevMonth =
                                                          _getPreviousMonth(
                                                        calendarState.month!,
                                                        calendarState.year!,
                                                      );
                                                      context
                                                          .read<CalendarCubit>()
                                                          .getMonth(
                                                            prevMonth['month']!,
                                                            prevMonth['year'],
                                                          );
                                                    },
                                                    icon: const Icon(
                                                      Ionicons
                                                          .chevron_back_outline,
                                                      color: kPrimaryColor,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: AnimatedContainer(
                                                      duration: const Duration(
                                                          seconds: 10),
                                                      child: Center(
                                                        child: Text(
                                                          '${TimeFormater().months[calendarState.month! - 1]} ${calendarState.year}',
                                                          style:
                                                              const TextStyle(
                                                            fontFamily:
                                                                'Roboto-Regular',
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      Map<String, int>
                                                          nextMonth =
                                                          _getNextMonth(
                                                        calendarState.month!,
                                                        calendarState.year!,
                                                      );
                                                      if (calendarState
                                                                  .month! >=
                                                              DateTime.now()
                                                                  .month &&
                                                          calendarState.year! ==
                                                              DateTime.now()
                                                                  .year) {
                                                      } else {
                                                        context
                                                            .read<
                                                                CalendarCubit>()
                                                            .getMonth(
                                                              nextMonth[
                                                                  'month']!,
                                                              nextMonth[
                                                                  'year']!,
                                                            );
                                                      }
                                                    },
                                                    icon: Icon(
                                                      (calendarState.month! >=
                                                                  DateTime.now()
                                                                      .month &&
                                                              calendarState
                                                                      .year! ==
                                                                  DateTime.now()
                                                                      .year)
                                                          ? null
                                                          : Ionicons
                                                              .chevron_forward_outline,
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
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: const [
                                                          Expanded(
                                                            child: Center(
                                                              child: Text(
                                                                'L',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Roboto-Regular',
                                                                  fontSize: 15,
                                                                  color:
                                                                      kPrimaryColor,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Center(
                                                              child: Text(
                                                                'M',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Roboto-Regular',
                                                                  fontSize: 15,
                                                                  color:
                                                                      kPrimaryColor,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Center(
                                                              child: Text(
                                                                'M',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Roboto-Regular',
                                                                  fontSize: 15,
                                                                  color:
                                                                      kPrimaryColor,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Center(
                                                              child: Text(
                                                                'J',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Roboto-Regular',
                                                                  fontSize: 15,
                                                                  color:
                                                                      kPrimaryColor,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Center(
                                                              child: Text(
                                                                'V',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Roboto-Regular',
                                                                  fontSize: 15,
                                                                  color:
                                                                      kPrimaryColor,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Center(
                                                              child: Text(
                                                                'S',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Roboto-Regular',
                                                                  fontSize: 15,
                                                                  color:
                                                                      kPrimaryColor,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Center(
                                                              child: Text(
                                                                'D',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Roboto-Regular',
                                                                  fontSize: 15,
                                                                  color:
                                                                      kPrimaryColor,
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
                                                            maxCrossAxisExtent:
                                                                50,
                                                            childAspectRatio:
                                                                3 / 2,
                                                          ),
                                                          itemCount:
                                                              calendarState
                                                                  .monthDays
                                                                  ?.length,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  index) {
                                                            int day =
                                                                calendarState
                                                                    .monthDays![
                                                                        index]
                                                                    .date
                                                                    .day;
                                                            bool isThisMonth =
                                                                calendarState
                                                                    .monthDays![
                                                                        index]
                                                                    .thisMonth;
                                                            bool isToday = ((calendarState
                                                                        .monthDays![
                                                                            index]
                                                                        .date
                                                                        .day ==
                                                                    DateTime.now()
                                                                        .day) &&
                                                                (calendarState
                                                                        .monthDays![
                                                                            index]
                                                                        .date
                                                                        .month ==
                                                                    DateTime.now()
                                                                        .month) &&
                                                                (calendarState
                                                                        .monthDays![
                                                                            index]
                                                                        .date
                                                                        .year ==
                                                                    DateTime.now()
                                                                        .year));
                                                            return (calendarState
                                                                    .monthDays![
                                                                        index]
                                                                    .thisMonth)
                                                                ? GestureDetector(
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        _selectedDate = TimeFormater().formatDateForBackend(
                                                                            calendarState.monthDays![index].date.day,
                                                                            calendarState.month,
                                                                            calendarState.year);
                                                                      });
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: ((_selectedDate ==
                                                                                TimeFormater().formatDateForBackend(
                                                                                  calendarState.monthDays![index].date.day,
                                                                                  calendarState.month!,
                                                                                  calendarState.year!,
                                                                                )))
                                                                            ? kPrimaryColor
                                                                            : null,
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          calendarState
                                                                              .monthDays![index]
                                                                              .date
                                                                              .day
                                                                              .toString(),
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                'Roboto-Regular',
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: (_selectedDate ==
                                                                                    TimeFormater().formatDateForBackend(
                                                                                      calendarState.monthDays![index].date.day,
                                                                                      calendarState.month!,
                                                                                      calendarState.year!,
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
                                                const SizedBox(height: 26),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                          context
                                                              .read<
                                                                  CalendarCubit>()
                                                              .getMonth(
                                                                DateTime.now()
                                                                    .month,
                                                                DateTime.now()
                                                                    .year,
                                                              );
                                                          setState(() {
                                                            _selectedDate = TimeFormater()
                                                                .formatDateForBackend(
                                                                    DateTime.now()
                                                                        .day,
                                                                    DateTime.now()
                                                                        .month,
                                                                    DateTime.now()
                                                                        .year);
                                                          });
                                                          context
                                                              .read<
                                                                  DashboardCubit>()
                                                              .dashboardData(
                                                                selectedDate:
                                                                    _selectedDate,
                                                              );
                                                        },
                                                        child: const SizedBox(
                                                          height: 40,
                                                          width: 100,
                                                          child: Center(
                                                            child: Text(
                                                              'Annuler',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto-Regular',
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                          context
                                                              .read<
                                                                  DashboardCubit>()
                                                              .dashboardData(
                                                                  selectedDate:
                                                                      _selectedDate);
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                kPrimaryColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                          ),
                                                          height: 40,
                                                          width: 100,
                                                          child: const Center(
                                                            child: Text(
                                                              'Terminé',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto-Regular',
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ]),
                                            );
                                          });
                                        },
                                      ),
                                    ),
                                    child: Container(
                                      width: 110,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: kPrimaryColor,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const ImageIcon(
                                            AssetImage(
                                              'assets/images/Option.png',
                                            ),
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 9),
                                          Center(
                                            child: Text(
                                              _selectedDate,
                                              style: const TextStyle(
                                                fontFamily: 'Barlow-Regular',
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade300,
                                  blurRadius: 2,
                                  spreadRadius: 2,
                                  offset: const Offset(1, 2), // Shadow position
                                ),
                              ],
                            ),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 18,
                            ),
                            child: ListView(
                              children: [
                                FittedBox(
                                  child: (dashboardState.products!.isNotEmpty)
                                      ? DataTable(
                                          columns: const [
                                            DataColumn(
                                              label: Text(
                                                'Article',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Poppins-Regular',
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              numeric: true,
                                              label: Text(
                                                'Cmd',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Poppins-Regular',
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              numeric: true,
                                              label: Text(
                                                'PU',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Poppins-Regular',
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              numeric: true,
                                              label: Text(
                                                'Recette',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Poppins-Regular',
                                                ),
                                              ),
                                            ),
                                          ],
                                          rows: dashboardState.products!
                                              .map(
                                                (product) => DataRow(
                                                  cells: <DataCell>[
                                                    DataCell(
                                                      Text(
                                                        product.product!.label!,
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                              'Poppins-Regular',
                                                        ),
                                                      ),
                                                    ), //Extracting from Map element the value
                                                    DataCell(
                                                      Text(
                                                        product.numberOfOrder
                                                            .toString(),
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14,
                                                          fontFamily:
                                                              'Poppins-Regular',
                                                        ),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Text(
                                                        'XOF ${product.product!.purchasePrice}'
                                                            .toString(),
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                              'Poppins-Regular',
                                                        ),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Text(
                                                        'XOF ${product.product!.purchasePrice! * product.numberOfOrder!}'
                                                            .toString(),
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14,
                                                          fontFamily:
                                                              'Poppins-Regular',
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                              .toList(),
                                        )
                                      : Container(
                                          margin:
                                              const EdgeInsets.only(top: 50),
                                          padding: const EdgeInsets.all(20),
                                          child: const BoxMessage(
                                            message:
                                                "Vous n'avez pas venté enregistré pour ce jour",
                                          ),
                                        ),
                                )
                              ],
                            ),
                          ),
                        )
                      ]));
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
