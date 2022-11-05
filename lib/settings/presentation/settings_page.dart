import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../authentication/infrastructures/authentication_cubit.dart';
import '../../invoices/shared/fetch_invoice_cubit.dart';
import '../../src/shared/app_colors.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
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
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Paramètres',
          style: TextStyle(
            fontSize: 22,
            fontFamily: 'Poppins-Regular',
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocListener<AuthenticationCubit, AuthenticationState>(
        listener: (context, authenticationState) {
          if (authenticationState is AuthenticationNotValidated) {
            context.goNamed('login');
          }
        },
        child: Container(
          margin: const EdgeInsets.only(
            top: 35,
            left: 26,
            right: 26,
          ),
          child: Column(
            children: [
              // Container(
              //   margin: const EdgeInsets.only(bottom: 15),
              //   width: MediaQuery.of(context).size.width,
              //   height: 64,
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(10),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.grey.shade300,
              //         blurRadius: 2,
              //         spreadRadius: 2,
              //         offset: const Offset(1, 2), // Shadow position
              //       ),
              //     ],
              //   ),
              //   child: Row(children: [
              //     Expanded(
              //       child: Container(
              //         padding: const EdgeInsets.only(left: 16),
              //         alignment: Alignment.centerLeft,
              //         child: const Text(
              //           'Modifier mon profil',
              //           style: TextStyle(
              //             fontFamily: 'Poppins-Regular',
              //             color: Color(0xFF010118),
              //             fontSize: 16,
              //           ),
              //         ),
              //       ),
              //     ),
              //     Container(
              //       alignment: Alignment.centerRight,
              //       padding: const EdgeInsets.only(right: 14),
              //       width: 50,
              //       child: const Icon(
              //         Ionicons.chevron_forward_outline,
              //       ),
              //     )
              //   ]),
              // ),
              GestureDetector(
                onTap: () {
                  context.pushNamed('transactions', params: {'tab': '2'});
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  width: MediaQuery.of(context).size.width,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 2,
                        spreadRadius: 2,
                        offset: const Offset(1, 2), // Shadow position
                      ),
                    ],
                  ),
                  child: Row(children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 16),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Transactions',
                          style: TextStyle(
                            fontFamily: 'Poppins-Regular',
                            color: Color(0xFF010118),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 14),
                      width: 50,
                      child: const Icon(Ionicons.chevron_forward_outline),
                    )
                  ]),
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.goNamed('manageItems', params: {'tab': '2'});
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  width: MediaQuery.of(context).size.width,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 2,
                        spreadRadius: 2,
                        offset: const Offset(1, 2), // Shadow position
                      ),
                    ],
                  ),
                  child: Row(children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 16),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Gestion des articles',
                          style: TextStyle(
                            fontFamily: 'Poppins-Regular',
                            color: Color(0xFF010118),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 14),
                      width: 50,
                      child: const Icon(Ionicons.chevron_forward_outline),
                    )
                  ]),
                ),
              ),
              // Container(
              //   margin: const EdgeInsets.only(bottom: 15),
              //   width: MediaQuery.of(context).size.width,
              //   height: 64,
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(10),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.grey.shade300,
              //         blurRadius: 2,
              //         spreadRadius: 2,
              //         offset: const Offset(1, 2), // Shadow position
              //       ),
              //     ],
              //   ),
              //   child: Row(children: [
              //     Expanded(
              //         padding: const EdgeInsets.only(left: 16),
              //         alignment: Alignment.centerLeft,
              //         child: const Text(
              //           'Changer mon mot de passe',
              //           style: TextStyle(
              //             fontFamily: 'Poppins-Regular',
              //             color: Color(0xFF010118),
              //             fontSize: 16,
              //           ),
              //         ),
              //       ),
              //     ),
              //     Container(
              //       alignment: Alignment.centerRight,
              //       padding: const EdgeInsets.only(right: 14),
              //       width: 50,
              //       child: const Icon(Ionicons.chevron_forward_outline),
              //     )
              //   ]),
              // ),
              GestureDetector(
                onTap: () async {
                  final Uri url = Uri.parse(
                      'http://mpos-backend-app.herokuapp.com/privacy-policy');

                  await launchUrl(url);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  width: MediaQuery.of(context).size.width,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 2,
                        spreadRadius: 2,
                        offset: const Offset(1, 2), // Shadow position
                      ),
                    ],
                  ),
                  child: Row(children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 16),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Conditions générales d'utilisation",
                          style: TextStyle(
                            fontFamily: 'Poppins-Regular',
                            color: Color(0xFF010118),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 14),
                      width: 50,
                      child: const Icon(Ionicons.chevron_forward_outline),
                    )
                  ]),
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.read<AuthenticationCubit>().logout();
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  width: MediaQuery.of(context).size.width,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 2,
                        spreadRadius: 2,
                        offset: const Offset(1, 2), // Shadow position
                      ),
                    ],
                  ),
                  child: Row(children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 16),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Déconnexion',
                          style: TextStyle(
                            fontFamily: 'Poppins-Regular',
                            color: Color(0xFF010118),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 14),
                      width: 50,
                      child: const Icon(Ionicons.chevron_forward_outline),
                    )
                  ]),
                ),
              ),
              Expanded(
                child: Container(),
              ),
              Container(
                child: const Center(
                  child: Text(
                    'Version 3.1.0 - beta',
                    style: TextStyle(
                      fontFamily: 'Poppins-Regular',
                      fontSize: 13,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
