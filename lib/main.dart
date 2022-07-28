import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/Environment/environement.dart';
import 'core/presentation/m_pos_initial.dart';

void main() async {
  await dotenv.load(fileName: Environment.fileName);
  runApp(
    const Mpos(),
  );
}
