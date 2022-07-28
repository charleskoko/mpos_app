import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get fileName {
    if (kDebugMode) {
      if (Platform.isAndroid) {
        return ".env.production";
      }
      return ".env.development";
    }
    return ".env.production";
  }

  static String get apiUrl {
    return dotenv.env['API_URL'] ?? 'www.example.com';
  }

  static Uri getUri({required String unencodedPath}) {
    if (kDebugMode) {
      if (Platform.isAndroid) {
        return Uri.https(Environment.apiUrl, unencodedPath);
      }
      return Uri.http(Environment.apiUrl, unencodedPath);
    }
    return Uri.https(Environment.apiUrl, unencodedPath);
  }
}
