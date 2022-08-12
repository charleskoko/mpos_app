import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mpos_app/core/infrastructures/sembast_database.dart';
import 'core/Environment/environement.dart';
import 'core/presentation/m_pos_initial.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
  await dotenv.load(fileName: Environment.fileName);
  SembastDatabase sembastDatabase = SembastDatabase();
  await sembastDatabase.init();
  runApp(
    Mpos(sembastDatabase: sembastDatabase),
  );
}
