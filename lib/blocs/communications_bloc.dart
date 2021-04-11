import 'package:flutter/widgets.dart';
import 'package:okbluemer/comms/comms.dart';
import 'package:okbluemer/comms/comms_utils.dart';
import 'package:okbluemer/comms/hardware/nearby_api.dart';

class CommunicationBloc extends StatefulWidget {
  final Widget child;
  final CommsHardware hardware;

  CommunicationBloc({@required this.child, CommsHardware hardware})
      : this.hardware = hardware ?? nearbyAPIHardware;

  @override
  CommunicationBlocState createState() => CommunicationBlocState();

  static CommunicationBlocState of(BuildContext context) {
    return context.findAncestorStateOfType<CommunicationBlocState>();
  }
}

class CommunicationBlocState extends State<CommunicationBloc> {
  Comms _comms;

  Stream<int> get connectionsStream => _comms.connectionsStream;

  final Map<CommunicationEvent, EventListener> _events = {
    CommunicationEvent.onConnect: EventListener(),
    CommunicationEvent.onDisconnect: EventListener(),
    CommunicationEvent.onMessageReceived: EventListener(),
    CommunicationEvent.onJoin: EventListener(),
  };

  @override
  void initState() {
    super.initState();

    this._comms = Comms(
      events: _events,
      hardware: this.widget.hardware,
    );
    this._comms.beginScan("");
  }

  @override
  void dispose() async {
    _events.forEach((event, listener) => listener.clear());
    await this._comms.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return this.widget.child;
  }

  bool get isConnected => this._comms.isConnected;
  String get id => this._comms.id;

  void sendMessage(String message) {
    this._comms.sendMessage(message);
  }

  subscribe(CommunicationEvent event, Function(dynamic) f) {
    _events[event].subscribe(f);
  }

  unsubscribe(CommunicationEvent event, Function(dynamic) f) {
    _events[event].unsubscribe(f);
  }
}
