import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpos_app/orders/core/infrastructure/order_remote_service.dart';
import '../../authentication/infrastructures/authentication_local_service.dart';
import '../../authentication/infrastructures/authentication_remote_service.dart';
import '../../authentication/infrastructures/authentication_repository.dart';
import '../../orders/core/infrastructure/order_repository.dart';
import '../../products/core/infrastructure/product_remote_service.dart';
import '../../products/core/infrastructure/product_repository.dart';

class RepositoriesProvider {
  static List init({
    required BuildContext context,
    required AuthenticationLocalService authenticationLocalService,
    required AuthenticationRemoteService authenticationRemoteService,
    required ProductRemoteService productRemoteService,
    required OrderRemoteService orderRemoteService,
  }) {
    return [
      RepositoryProvider<AuthenticationRepository>(
        create: (context) => AuthenticationRepository(
          authenticationLocalService,
          authenticationRemoteService,
        ),
      ),
      RepositoryProvider<ProductRepository>(
        create: (context) => ProductRepository(
          productRemoteService,
        ),
      ),
      RepositoryProvider<OrderRepository>(
        create: (context) => OrderRepository(
          orderRemoteService,
        ),
      )
    ];
  }
}
