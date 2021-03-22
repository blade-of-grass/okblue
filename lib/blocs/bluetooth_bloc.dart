import 'package:flutter/widgets.dart';
import 'package:okbluemer/comms/comms.dart';
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

  Comms _comms;

  final Map<BluetoothEvent, EventListener> _events = {
    BluetoothEvent.onConnect: EventListener(),
    BluetoothEvent.onDisconnect: EventListener(),
    BluetoothEvent.onMessageReceived: EventListener(),
  };

  BluetoothBlocState() {
    this._comms = Comms(onMessageReceived: _onMessageReceived);
  }

  scan(String username) async {
    await this._comms.sync(username);

    this.fire(BluetoothEvent.onConnect);
  }

  sendMessage(Message message) {
    this._comms.sendMessage(message.serialize());
  }

  _onMessageReceived(String data) {
    this.fire(
      BluetoothEvent.onMessageReceived,
      Message.deserialize(data),
    );
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
