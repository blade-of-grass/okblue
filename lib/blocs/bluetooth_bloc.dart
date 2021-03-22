import 'package:flutter/widgets.dart';
import 'package:okbluemer/comms/beacon.dart';
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
    Beacon.instance.write("ugh");
    Beacon.instance.read();
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
