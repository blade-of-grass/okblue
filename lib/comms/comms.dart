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

  final _connections = Set<String>();
  final _cache = Set<String>();

  Function(String, String) onMessageReceived;

  Comms({@required this.onMessageReceived});

  bool get isConnected => this._connections.isNotEmpty;

  Future<void> beginScan(String username) async {
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
    this._connections.add(id);
    // TODO: probably put this in some kind of event stream, so the UI can inform the user
  }

  void onConnectFail(String id) {
    // TODO: probably put this in some kind of event stream, so the UI can inform the user
  }

  bool onDeviceFound(String id, String username) {
    if (this._connections.contains(id)) {
      return false;
    } else {
      // TODO: probably put this in some kind of event stream, so the UI can inform the user
      return true;
    }
  }

  void onDisconnect(String id) {
    this._connections.remove(id);
    // TODO: probably put this in some kind of event stream, so the UI can inform the user
  }

  void onPayloadReceived(String id, Uint8List payload) {
    final message = utf8.decode(payload);

    print(message);

    final tags = Set<String>();

    int index = 0;
    String origin = id;
    while (message[index] != ' ') {
      ++index;

      if (index % 4 == 0) {
        origin = message.substring(index - 4, index);
        tags.add(origin);
      }
    }

    final messageBeginIndex = message.indexOf(" ", index + 1);
    final timestamp = message.substring(index + 1, messageBeginIndex);

    final cacheKey = "$origin $timestamp";

    // TODO: items will need to be evicted from cache every so often, maybe every minute remove items that are a minute+ old?
    if (this._cache.contains(cacheKey)) {
      this._cache.add(cacheKey);

      this.onMessageReceived(origin, message.substring(messageBeginIndex + 1));
      this._encodeAndSendMessage("$id$message", excludedIds: tags);
    }
  }

  void sendMessage(String message, [DateTime time]) {
    time ??= DateTime.now();
    final timestamp = time.millisecondsSinceEpoch.toString();

    _encodeAndSendMessage(" $timestamp $message");
  }

  void _encodeAndSendMessage(String message, {Set<String> excludedIds}) {
    final Uint8List bytes = utf8.encode(message);
    final payload = Uint8List.fromList(bytes.toList(growable: false));
    final mailingList = this._connections.difference(excludedIds ?? []);

    this.hardware.sendPayload(mailingList, payload);
  }
}
