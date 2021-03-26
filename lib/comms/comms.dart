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

  Function(String, String) onMessageReceived;

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
    // TODO: cache message by the substring that matches "id timestamp".
    // TODO: This will be the id of the original sender, plus the timestamp the message was sent at.
    // TODO: We will need to reference this cache before calling onMessageReceived
    // TODO: if the message is already cached, then we don't need to trigger the event
    // TODO: items will need to be evicted from cache every so often, maybe every minute remove items that are a minute+ old?
    this.onMessageReceived(id, message);

    // TODO: scan beginning of packet for tags

    final tags = Set<String>();
    this._encodeAndSendMessage("$id$message", excludedIds: tags);
  }

  void sendMessage(String message, [DateTime time]) {
    time ??= DateTime.now();
    final timestamp = time.millisecondsSinceEpoch.toString();

    _encodeAndSendMessage(" $timestamp $message");
  }

  void _encodeAndSendMessage(String message, {Set<String> excludedIds}) {
    final Uint8List bytes = utf8.encode(message);
    final payload = Uint8List.fromList(bytes.toList(growable: false));
    final mailingList = connections.difference(excludedIds ?? []);

    this.hardware.sendPayload(mailingList, payload);
  }
}
