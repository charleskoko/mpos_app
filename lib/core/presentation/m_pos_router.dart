import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../authentication/presentation/login_page.dart';
import '../../authentication/presentation/password_forgot_page.dart';
import '../../authentication/presentation/register_page.dart';
import '../../main/main_page.dart';
import '../../not_processed_order/presentation/show_not_processed_order_page.dart';
import '../../orders/presentation/order_details.dart';
import '../../orders/presentation/order_verification_page.dart';
import '../../orders/presentation/save_order_status.dart';
import '../../sales/presentation/sale_details.dart';
import '../../splash/presentation/splash_page.dart';

class MposRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const SplashPage(),
        ),
      ),
      GoRoute(
          name: 'login',
          path: '/login',
          pageBuilder: (context, state) => MaterialPage(
                key: state.pageKey,
                child: const LoginPage(),
              ),
          routes: [
            GoRoute(
              name: 'register',
              path: 'register',
              pageBuilder: (context, state) => MaterialPage(
                key: state.pageKey,
                child: const RegisterPage(),
              ),
            ),
            GoRoute(
              name: 'passwordForgot',
              path: 'passwordForgot',
              pageBuilder: (context, state) => MaterialPage(
                key: state.pageKey,
                child: const PasswordForgotPage(),
              ),
            ),
          ]),
      GoRoute(
          name: 'main',
          path: '/main',
          pageBuilder: (context, state) => MaterialPage(
                key: state.pageKey,
                child: const MainPage(),
              ),
          routes: [
            GoRoute(
              name: 'orderDetails',
              path: 'orderDetails',
              pageBuilder: (context, state) => MaterialPage(
                key: state.pageKey,
                child: OrderDetails(),
              ),
            ),
            GoRoute(
              name: 'orderVerification',
              path: 'orderVerification',
              pageBuilder: (context, state) => MaterialPage(
                key: state.pageKey,
                child: const OrderVerificationPage(),
              ),
            ),
            GoRoute(
              name: 'saveOrderStatus',
              path: 'saveOrderStatus',
              pageBuilder: (context, state) => MaterialPage(
                key: state.pageKey,
                child: const SaveOrderStatus(),
              ),
            ),
            GoRoute(
              name: 'salesDetails',
              path: 'salesDetails',
              pageBuilder: (context, state) => MaterialPage(
                key: state.pageKey,
                child: const SaleDetails(),
              ),
            ),
            GoRoute(
              name: 'notProcessedOrderDetails',
              path: 'notProcessedOrderDetails',
              pageBuilder: (context, state) => MaterialPage(
                key: state.pageKey,
                child: const ShowNotProcessedOrderPage(),
              ),
            ),
          ]),
    ],
  );
}
