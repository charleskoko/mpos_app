import 'dart:io';

import 'package:dio/dio.dart';

extension DioExtension on DioError {
  bool get isNoConnectionError {
    return type == DioErrorType.other && error is SocketException;
  }
}
