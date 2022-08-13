import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import '../src/shared/app_colors.dart';
import '../src/widgets/box_text.dart';

class PrintPage extends StatefulWidget {
  PrintPage({Key? key}) : super(key: key);

  @override
  State<PrintPage> createState() => _PrintPageState();
}

class _PrintPageState extends State<PrintPage> {
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  List<BluetoothDevice> _devices = [];
  String _devicesMsg = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        ?.addPostFrameCallback((timeStamp) => {initPrinter()});
  }

  Future<void> initPrinter() async {
    bluetoothPrint.startScan(timeout: const Duration(seconds: 4));
    if (!mounted) return;
    bluetoothPrint.scanResults.listen((val) {
      if (!mounted) return;
      setState(() {
        _devices = val;
      });
      if (_devices.isEmpty) {
        setState(() {
          _devicesMsg = 'No devices';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        title: BoxText.headingTwo(
          'Imprimantes'.toUpperCase(),
          color: kThreeColor,
        ),
      ),
    );
  }
}
