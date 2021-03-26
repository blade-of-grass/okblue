// import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:okbluemer/comms/comms_interface.dart';
import 'package:okbluemer/comms/nearby_api.dart';

class Comms {
  static const SERVICE_ID = "com.okbluemer";

  final CommsHardware hardware = nearbyAPI;

  final connections = Set<String>();

  String username;

  Function(String, DateTime, String) onMessageReceived;

  Comms({@required this.onMessageReceived});

  Future<void> beginScan(String username) async {
    this.username = username;
    bool hasPermissions = await hardware.checkPermissions();
    if (!hasPermissions) {
      return;
    }

    this.hardware.beginScan(CommsConfiguration(
          username: username,
          serviceID: Comms.SERVICE_ID,
          onConnectSuccess: this.onConnectSuccess,
          onConnectFail: this.onConnectFail,
          onDeviceFound: this.onDeviceFound,
          onDisconnect: this.onDisconnect,
          onPayloadReceived: this.onPayloadReceived,
        ));
  }

  void endScan() async {
    this.hardware.endScan();
  }

  void onConnectSuccess(String id) {
    this.connections.add(id);
    // TODO: probably put this in some kind of event stream, so the UI can inform the user
  }

  void onConnectFail(String id) {
    // TODO: probably put this in some kind of event stream, so the UI can inform the user
  }

  bool onDeviceFound(String id, String username) {
    if (this.connections.contains(id)) {
      return false;
    } else {
      // TODO: probably put this in some kind of event stream, so the UI can inform the user
      return true;
    }
  }

  void onDisconnect(String id) {
    this.connections.remove(id);
    // TODO: probably put this in some kind of event stream, so the UI can inform the user
  }

  void onPayloadReceived(String id, Uint8List payload) {
    final message = utf8.decode(payload);

    print(message);

    // TODO: parse datetime from message
    this.onMessageReceived(id, DateTime.now(), message);

    // TODO: scan beginning of packet for sender_ids
    // TODO: set list = connections - sender_ids
    // TODO: set packet = "$id$message";
    // TODO: this.sendMessage(sender_ids, packet);
  }

  void sendMessage(String message, [Set<String> excludedIds]) {
    final bytes = utf8.encode(message);
    final payload = Uint8List.fromList(bytes.toList(growable: false));
    final mailingList = connections.difference(excludedIds ?? []);

    this.hardware.sendPayload(mailingList, payload);
  }
}
