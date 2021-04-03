import 'package:flutter/widgets.dart';
import 'package:okbluemer/comms/comms.dart';
import 'package:okbluemer/comms/comms_utils.dart';
import 'package:okbluemer/utils.dart';

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
    CommunicationEvent.onJoin: EventListener(),
  };

  CommunicationBlocState() {
    this._comms = Comms(_events);
  }

  Future<void> scan(String username) {
    return this._comms.beginScan(username);
  }

  void sendMessage(String message) {
    this._comms.sendMessage(message);
  }

  disconnect() {
    _events.forEach((event, listener) => listener.clear());
    return this._comms.disconnect();
  }

  subscribe(CommunicationEvent event, Function(dynamic) f) {
    _events[event].subscribe(f);
  }

  unsubscribe(CommunicationEvent event, Function(dynamic) f) {
    _events[event].unsubscribe(f);
  }

  @override
  Widget build(BuildContext context) {
    return this.widget.child;
  }

  @override
  void dispose() {
    this.disconnect();
    super.dispose();
  }
}
