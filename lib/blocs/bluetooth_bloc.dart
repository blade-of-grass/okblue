import 'package:flutter/widgets.dart';
import 'package:okbluemer/utils.dart';

enum BluetoothEvent {
  onConnect,
  onDisconnect,
  onMessageReceived,
}

class BluetoothBloc extends StatelessWidget {
  final Widget child;

  final Map<BluetoothEvent, EventListener> _events = {
    BluetoothEvent.onConnect: EventListener(),
    BluetoothEvent.onDisconnect: EventListener(),
    BluetoothEvent.onMessageReceived: EventListener(),
  };

  BluetoothBloc({@required this.child}) {
    // FlutterBlue flutterBlue = FlutterBlue.instance;
    // // Start scanning
    // flutterBlue.startScan(timeout: Duration(seconds: 4));

    // // Listen to scan results
    // var subscription = flutterBlue.scanResults.listen((results) async {
    //   // do something with scan results
    //   for (ScanResult r in results) {
    //     print('${r.device.name} found! rssi: ${r.rssi}');

    //     var x = await r.device.isDiscoveringServices.first;
    //     print('services: ${x}');
    //   }
    // });

    // // Stop scanning
    // flutterBlue.stopScan();
  }

  subscribe(BluetoothEvent event, Function(dynamic) f) {
    _events[event].subscribe(f);
  }

  unsubscribe(BluetoothEvent event, Function(dynamic) f) {
    _events[event].unsubscribe(f);
  }

  fire(BluetoothEvent event, [dynamic data]) {
    _events[event].fire(data);
  }

  static BluetoothBloc of(BuildContext context) {
    return context.findAncestorWidgetOfExactType<BluetoothBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return this.child;
  }
}
