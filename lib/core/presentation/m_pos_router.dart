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
import '../../products/presentation/add_product_page.dart';
import '../../products/presentation/edit_product_page.dart';
import '../../products/presentation/manage_product_page.dart';
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
          path: '/main/:tab',
          pageBuilder: (context, state) {
            final int tab = int.parse(state.params['tab']!);
            return MaterialPage(
              key: state.pageKey,
              child: MainPage(tab: tab),
            );
          },
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
              name: 'notProcessedOrderDetails',
              path: 'notProcessedOrderDetails',
              pageBuilder: (context, state) => MaterialPage(
                key: state.pageKey,
                child: const ShowNotProcessedOrderPage(),
              ),
            ),
            GoRoute(
                name: 'manageItems',
                path: 'manageItems',
                pageBuilder: (context, state) => MaterialPage(
                      key: state.pageKey,
                      child: const ManageItemsPage(),
                    ),
                routes: [
                  GoRoute(
                    name: 'addProduct',
                    path: 'addProduct',
                    pageBuilder: (context, state) => MaterialPage(
                      key: state.pageKey,
                      child: const AddProductPage(),
                    ),
                  ),
                  GoRoute(
                    name: 'updateProduct',
                    path: 'updateProduct',
                    pageBuilder: (context, state) => MaterialPage(
                      key: state.pageKey,
                      child: UpdateProductPage(),
                    ),
                  )
                ]),
          ]),
    ],
  );
}
