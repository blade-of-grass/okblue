import 'package:flutter/widgets.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';
import 'package:okbluemer/utils.dart';

import 'package:permission_handler/permission_handler.dart';

enum BluetoothEvent {
  onConnect,
  onDisconnect,
  onMessageReceived,
}

class BluetoothBloc extends StatefulWidget {
  final Widget child;

  BluetoothBloc({@required this.child});

  @override
  BluetoothBlocState createState() => BluetoothBlocState();

  static BluetoothBlocState of(BuildContext context) {
    return context.findAncestorStateOfType<BluetoothBlocState>();
  }
}

class BluetoothBlocState extends State<BluetoothBloc> {
  PermissionStatus _locationPermissionStatus = PermissionStatus.unknown;

  final Map<BluetoothEvent, EventListener> _events = {
    BluetoothEvent.onConnect: EventListener(),
    BluetoothEvent.onDisconnect: EventListener(),
    BluetoothEvent.onMessageReceived: EventListener(),
  };

  Future<void> _checkPermissions() async {
    // if (Platform.isAndroid) {
    var permissionStatus = await PermissionHandler()
        .requestPermissions([PermissionGroup.location]);

    _locationPermissionStatus = permissionStatus[PermissionGroup.location];

    if (_locationPermissionStatus != PermissionStatus.granted) {
      return Future.error(Exception("Location permission not granted"));
    }
    // }
  }

  scan() async {
    await _checkPermissions();
    // BleManager bleManager = BleManager();
    // await bleManager.createClient();

    // // bleManager.destroyClient();

    // bleManager
    //     .enableRadio(); //ANDROID-ONLY turns on BT. NOTE: doesn't check permissions
    // // bleManager.disableRadio() //ANDROID-ONLY turns off BT. NOTE: doesn't check permissions
    // final currentState = await bleManager.bluetoothState();
    // print(currentState);
    // bleManager.observeBluetoothState().listen((btState) {
    //   print(btState);
    //   //do your BT logic, open different screen, etc.
    // });

    const our_uuid = "d6052cb2-8aa0-11eb-8dcd-0242ac130003";

    // bleManager.startPeripheralScan(
    //   uuids: [
    //     our_uuid,
    //   ],
    // ).listen((scanResult) {
    //   //Scan one peripheral and stop scanning
    //   print(
    //       "Scanned Peripheral ${scanResult.peripheral.name}, RSSI ${scanResult.rssi}");
    //   bleManager.stopPeripheralScan();
    //   this.fire(BluetoothEvent.onConnect);
    // });

    // this part is needed for discoverable devices
    final data = AdvertiseData();
    data.uuid = our_uuid;
    FlutterBlePeripheral().start(data);
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

  @override
  Widget build(BuildContext context) {
    return this.widget.child;
  }
}