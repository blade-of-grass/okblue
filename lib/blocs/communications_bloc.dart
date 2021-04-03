import 'package:flutter/widgets.dart';
import 'package:okbluemer/comms/comms.dart';
import 'package:okbluemer/utils.dart';

enum CommunicationEvent {
  onConnect,
  onDisconnect,
  onMessageReceived,
}

class CommunicationBloc extends StatefulWidget {
  final Widget child;

  CommunicationBloc({@required this.child});

  @override
  CommunicationBlocState createState() => CommunicationBlocState();

  static CommunicationBlocState of(BuildContext context) {
    return context.findAncestorStateOfType<CommunicationBlocState>();
  }
}

class CommunicationBlocState extends State<CommunicationBloc> {
  Comms _comms;

  final Map<CommunicationEvent, EventListener> _events = {
    CommunicationEvent.onConnect: EventListener(),
    CommunicationEvent.onDisconnect: EventListener(),
    CommunicationEvent.onMessageReceived: EventListener(),
  };

  CommunicationBlocState() {
    this._comms = Comms(onMessageReceived: _onMessageReceived);
  }

  scan(String username) async {
    await this._comms.beginScan(username);

    while (!this._comms.isConnected) {
      await Future.delayed(const Duration(seconds: 1));
    }

    this.fire(CommunicationEvent.onConnect);
  }

  sendMessage(Packet packet) {
    this._comms.sendMessage(packet.serialize());
  }

  disconnect() {
    return this._comms.disconnect();
  }

  _onMessageReceived(String id, String data) {
    print(data);
    this.fire(
      CommunicationEvent.onMessageReceived,
      Packet.deserialize(data, id),
    );
  }

  subscribe(CommunicationEvent event, Function(dynamic) f) {
    _events[event].subscribe(f);
  }

  unsubscribe(CommunicationEvent event, Function(dynamic) f) {
    _events[event].unsubscribe(f);
  }

  fire(CommunicationEvent event, [dynamic data]) {
    _events[event].fire(data);
  }

  @override
  Widget build(BuildContext context) {
    return this.widget.child;
  }
}
