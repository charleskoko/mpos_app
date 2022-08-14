import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mpos_app/core/presentation/m_pos_router.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../authentication/infrastructures/authentication_local_service.dart';
import '../../authentication/infrastructures/authentication_remote_service.dart';
import '../../invoices/core/infrastructure/invoice_local_service.dart';
import '../../invoices/core/infrastructure/invoice_remote_service.dart';
import '../../orders/core/infrastructure/order_remote_service.dart';
import '../../products/core/infrastructure/product_local_service.dart';
import '../../products/core/infrastructure/product_remote_service.dart';
import '../infrastructures/blocs_provider.dart';
import '../infrastructures/repositories_provider.dart';
import '../infrastructures/sembast_database.dart';
import '../shared/dio_interceptor.dart';

class Mpos extends StatefulWidget {
  final SembastDatabase sembastDatabase;
  const Mpos({
    Key? key,
    required this.sembastDatabase,
  }) : super(key: key);

  @override
  State<Mpos> createState() => _MposState();
}

class _MposState extends State<Mpos> {
  late Dio _dio;
  late FlutterSecureStorage _flutterSecureStorage;
  late AuthenticationLocalService _authenticationLocalService;
  late AuthenticationRemoteService _authenticationRemoteService;
  late ProductRemoteService _productRemoteService;
  late ProductLocalService _productLocalService;
  late OrderRemoteService _orderRemoteService;
  late InvoiceRemoteService _invoiceRemoteService;
  late InvoiceLocalService _invoiceLocalService;

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
    _productLocalService = ProductLocalService(widget.sembastDatabase);
    _orderRemoteService = OrderRemoteService(_dio);
    _invoiceRemoteService = InvoiceRemoteService(_dio);
    _invoiceLocalService = InvoiceLocalService(widget.sembastDatabase);
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
          productLocalService: _productLocalService,
          orderRemoteService: _orderRemoteService,
          invoiceRemoteService: _invoiceRemoteService,
          invoiceLocalservice: _invoiceLocalService,
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
