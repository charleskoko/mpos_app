import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mpos_app/core/presentation/m_pos_router.dart';
import '../../authentication/infrastructures/authentication_local_service.dart';
import '../../authentication/infrastructures/authentication_remote_service.dart';
import '../../invoices/core/infrastructure/invoice_remote_service.dart';
import '../../orders/core/infrastructure/order_remote_service.dart';
import '../../products/core/infrastructure/product_remote_service.dart';
import '../infrastructures/blocs_provider.dart';
import '../infrastructures/repositories_provider.dart';
import '../shared/dio_interceptor.dart';

class Mpos extends StatefulWidget {
  const Mpos({Key? key}) : super(key: key);

  @override
  State<Mpos> createState() => _MposState();
}

class _MposState extends State<Mpos> {
  late Dio _dio;
  late FlutterSecureStorage _flutterSecureStorage;
  late AuthenticationLocalService _authenticationLocalService;
  late AuthenticationRemoteService _authenticationRemoteService;
  late ProductRemoteService _productRemoteService;
  late OrderRemoteService _orderRemoteService;
  late InvoiceRemoteService _invoiceRemoteService;

  @override
  void initState() {
    _flutterSecureStorage = const FlutterSecureStorage();
    _authenticationLocalService =
        AuthenticationLocalService(_flutterSecureStorage);
    _dio = Dio()
      ..options = BaseOptions(headers: {'Accept': 'application/json'})
      ..interceptors
          .add(AuthenticationInterceptor(_authenticationLocalService));
    _authenticationRemoteService = AuthenticationRemoteService(_dio);
    _productRemoteService = ProductRemoteService(_dio);
    _orderRemoteService = OrderRemoteService(_dio);
    _invoiceRemoteService = InvoiceRemoteService(_dio);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        ...RepositoriesProvider.init(
          context: context,
          authenticationRemoteService: _authenticationRemoteService,
          authenticationLocalService: _authenticationLocalService,
          productRemoteService: _productRemoteService,
          orderRemoteService: _orderRemoteService,
          invoiceRemoteService: _invoiceRemoteService,
        )
      ],
      child: MultiBlocProvider(
        providers: [...BlocsProvider.init()],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routeInformationParser: MposRouter.router.routeInformationParser,
          routerDelegate: MposRouter.router.routerDelegate,
          title: 'mPos',
        ),
      ),
    );
  }
}
