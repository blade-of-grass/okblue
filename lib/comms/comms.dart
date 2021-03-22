// import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';

import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:nearby_connections/nearby_connections.dart';

class Comms {
  static const SERVICE_ID = "com.okbluemer";

  final service = Nearby();

  final connections = Set<String>();

  bool isConnected = false;
  bool attemptingConnection = false;
  String username;

  Function(String) onMessageReceived;

  Comms({@required this.onMessageReceived});

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

  Future<void> _advertise() async {
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

  Future<void> _discover() async {
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

  Future<void> sync(String username) async {
    this.username = username;
    bool hasPermissions = await checkPermissions();
    if (!hasPermissions) {
      return;
    }

    final _random = Random();

    while (!isConnected) {
      // activate advertising mode
      await _advertise();

      // wait in advertising mode between 2 & 6 seconds
      await Future.delayed(Duration(seconds: _random.nextInt(5) + 2));

      // if we are attempting a connection, stay here
      await Future.doWhile(() async {
        return this.attemptingConnection;
      });

      // stop advertising, prepare to switch to discovery mode
      await service.stopAdvertising();
      // if we found a connection get out of here
      if (this.isConnected) break;

      // enable discovery mode
      await _discover();

      //
      await Future.delayed(Duration(seconds: _random.nextInt(5) + 2));
      await Future.doWhile(() async {
        return this.attemptingConnection;
      });
      await service.stopDiscovery();
      if (this.isConnected) break;
    }
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
      this.isConnected = true;

      this.connections.add(id);
    } else {
      attemptingConnection = false;
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
    this.onMessageReceived(message);
  }

  void _onPayloadTransferUpdate(String id, PayloadTransferUpdate update) {}

  void sendMessage(String message) {
    if (this.isConnected) {
      final bytes = Uint8List.fromList(message.codeUnits);

      this.connections.forEach((connection) {
        service.sendBytesPayload(connection, bytes);
      });
    }
  }
}
