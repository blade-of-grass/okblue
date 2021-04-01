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

  void onPayloadReceived(String id, Uint8List payloadBytes) {
    final payload = utf8.decode(payloadBytes);
    print(payload);

    // get each user id attached to the beginning of the payload.
    // these user ids are assumed to be 4 bytes long each.
    // once a space is read the user ids have ended
    const USER_ID_LENGTH = 4;
    final tags = Set<String>();
    int index = 0;
    String origin = id;
    while (payload[index] != ' ') {
      ++index;

      if (index % USER_ID_LENGTH == 0) {
        origin = payload.substring(index - USER_ID_LENGTH, index);
        tags.add(origin);
      }
    }

    // extract the timestamp and message from the payload
    final messageBeginIndex = payload.indexOf(" ", index + 1);
    final timestamp = payload.substring(index + 1, messageBeginIndex);
    final message = payload.substring(messageBeginIndex + 1);

    final cacheKey = "$origin $timestamp";

    // check if the message already exists in the cache
    // if it does we discard it
    if (this._cache.contains(cacheKey)) {
      this._cache.add(cacheKey);
      // TODO: items will need to be evicted from cache every so often, maybe every minute remove items that are a minute+ old?

      this.onMessageReceived(origin, message);
      this._encodeAndSendMessage("$id$payload", excludedIds: tags);
    }
  }

  void sendMessage(String message, [DateTime time]) {
    time ??= DateTime.now();
    final timestamp = time.millisecondsSinceEpoch.toString();

    _encodeAndSendMessage(" $timestamp $message");
  }

  void _encodeAndSendMessage(String message, {Set<String> excludedIds}) {
    final mailingList = this._connections.difference(excludedIds ?? []);

    final taggedIds = mailingList.reduce((String a, String b) => a + b);

    final Uint8List bytes = utf8.encode(taggedIds + message);
    final payload = Uint8List.fromList(bytes.toList(growable: false));

    this.hardware.sendPayload(mailingList, payload);
  }
}
