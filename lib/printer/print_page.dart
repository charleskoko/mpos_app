import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mpos_app/src/widgets/box_message.dart';
import '../invoices/core/domain/invoice.dart';
import '../orders/core/domain/order_line_item.dart';
import '../src/shared/app_colors.dart';
import '../src/widgets/box_text.dart';

class PrintPage extends StatefulWidget {
  final Invoice invoice;
  PrintPage(this.invoice, {Key? key}) : super(key: key);

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
        iconTheme: const IconThemeData(
          color: kPrimaryColor, //change your color here
        ),
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        title: BoxText.headingTwo(
          'Imprimantes'.toUpperCase(),
          color: kThreeColor,
        ),
      ),
      body: (_devices.isEmpty)
          ? Center(
              child: BoxMessage(message: _devicesMsg),
            )
          : ListView.builder(
              itemCount: _devices.length,
              itemBuilder: (BuildContext context, index) => ListTile(
                leading: const Icon(Ionicons.print_outline),
                title: BoxText.body(_devices[index].name ?? 'No name'),
                subtitle: BoxText.body(_devices[index].address ?? 'No adress'),
                onTap: () async {
                  await _startPrint(_devices[index]);
                },
              ),
            ),
    );
  }

  Future<void> _startPrint(BluetoothDevice device) async {
    if (device != null && device.address != null) {
      final isConnected = await bluetoothPrint.connect(device);

      Map<String, dynamic> config = {};
      List<LineText> list = [];
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: 'A Title',
          weight: 1,
          align: LineText.ALIGN_CENTER,
          linefeed: 1));
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: 'this is conent left',
          weight: 0,
          align: LineText.ALIGN_LEFT,
          linefeed: 1));
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: 'this is conent right',
          align: LineText.ALIGN_RIGHT,
          linefeed: 1));
      list.add(LineText(linefeed: 1));
      try {
        await bluetoothPrint.printReceipt(config, list);
      } catch (e) {
        print('fuckin exception: $e');
      }
    }
  }
}
