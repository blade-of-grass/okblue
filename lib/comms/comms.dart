// import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';

import 'dart:typed_data';

import 'package:nearby_connections/nearby_connections.dart';

class Comms {
  static const SERVICE_ID = "com.okbluemer";

  final service = Nearby();

  bool isConnected = false;
  String username;

  // beacon singleton
  static Comms _instance;
  static Comms get instance {
    if (_instance == null) {
      _instance = Comms._init();
    }
    return _instance;
  }

  Comms._init();

  Future<bool> checkPermissions() async {
    final hasLocationPermissions = await this.service.checkLocationPermission();

    if (!hasLocationPermissions) {
      return await this.service.askLocationPermission();
    } else {
      return true;
    }

    // // OPTIONAL: if you need to transfer files and rename it on device
    // bool b = await this.service.checkExternalStoragePermission();
    // // asks for READ + WRTIE EXTERNAL STORAGE permission only if its not given
    // Nearby().askExternalStoragePermission() ;
  }

  void _advertise() async {
    try {
      bool a = await this.service.startAdvertising(
            this.username,
            Strategy.P2P_CLUSTER,
            onConnectionInitiated: this._onConnectionInitiated,
            onConnectionResult: this._onConnectionResult,
            onDisconnected: this._onDisconnected,
            serviceId: Comms.SERVICE_ID,
          );
    } catch (e) {
      print(e);
      print("threw in advertiser");
    }
  }

  void _discover() async {
    try {
      bool a = await this.service.startDiscovery(
        this.username,
        Strategy.P2P_CLUSTER,
        onEndpointFound: (String id, String userName, String serviceId) {
          print("found advertiser with name $userName and id $id");

          service.requestConnection(
            userName,
            id,
            onConnectionInitiated: this._onConnectionInitiated,
            onConnectionResult: this._onConnectionResult,
            onDisconnected: this._onDisconnected,
          );

          service.stopDiscovery();
        },
        onEndpointLost: (String id) {
          // called when an advertiser is lost (only if we weren't connected to it )
        },
        serviceId: Comms.SERVICE_ID,
      );
    } catch (e) {
      print(e);
      print("threw in discovery");
    }
  }

  void sync(String username) async {
    this.username = username;
    bool hasPermissions = await checkPermissions();
    if (!hasPermissions) {
      return;
    }

    service.stopDiscovery();
    service.stopAdvertising();

    _discover();
    _advertise();

    while (!isConnected) {}
  }

  void _onConnectionInitiated(String id, ConnectionInfo info) {
    print("onConnectionInitiated $id");

    service.acceptConnection(
      id,
      onPayLoadRecieved: this._onPayloadReceived,
      onPayloadTransferUpdate: this._onPayloadTransferUpdate,
    );
  }

  void _onConnectionResult(String id, Status status) {
    print("onConnectionResult $id $status");

    if (status == Status.CONNECTED) {
      service.sendBytesPayload(id, Uint8List.fromList("hello world".codeUnits));
    }
  }

  void _onDisconnected(String id) {
    print("onDisconnected $id");
  }

  void _onPayloadReceived(String id, Payload payload) {
    print("onPayLoadRecieved $id");

    final bytes = payload.bytes.toList(growable: false);
    final message = String.fromCharCodes(bytes);

    print(message);
  }

  void _onPayloadTransferUpdate(String id, PayloadTransferUpdate update) {}
}
