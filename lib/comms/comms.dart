// import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:okbluemer/comms/comms_interface.dart';
import 'package:okbluemer/comms/comms_utils.dart';
import 'package:okbluemer/comms/nearby_api.dart';

class Comms {
  static const SERVICE_ID = "com.okbluemer";

  String id;
  final _connections = Set<String>();
  final _cache = Set<String>();
  final _activeUsers = StreamController<int>.broadcast();

  final CommsHardware hardware = nearbyAPI;
  final Map<CommunicationEvent, EventListener> events;

  Comms(this.events);

  Stream<int> get connectionsStream => _activeUsers.stream;

  bool get isConnected => this._connections.isNotEmpty && this.id != null;

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
    _activeUsers.add(_connections.length);
    
    // send the user id back to the sender, so they know who they are
    this.hardware.sendPayload({id}, utf8.encode(id));
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
    _activeUsers.add(_connections.length);

    if (this._connections.isEmpty) {
      this.id = null;
    }
    // TODO: probably put this in some kind of event stream, so the UI can inform the user
  }

  void onPayloadReceived(String id, Uint8List payloadBytes) {
    final payload = utf8.decode(payloadBytes);
    print(payload);

    const USER_ID_LENGTH = 4;

    // in the case where a message is only 4 bytes long we have received our
    // endpoint id (this is hacky, should probably just implement proper
    // message types instead, but for now it should do)
    if (payload.length == USER_ID_LENGTH) {
      this.id = payload;
      this.events[CommunicationEvent.onJoin].fire(this.id);
      return;
    }

    // get each user id attached to the beginning of the payload.
    // these user ids are assumed to be 4 bytes long each.
    // once a space is read the user ids have ended
    final tags = Set<String>();
    int index = 0;
    String origin;
    while (payload[index] != ' ') {
      ++index;

      if (index % USER_ID_LENGTH == 0) {
        final userID = payload.substring(index - USER_ID_LENGTH, index);
        tags.add(userID);

        // the last user id in the chain will be the origin
        // by continuing to reassign origin we ensure this will be the case
        origin = userID;
      }
    }

    assert(origin != null);

    // extract the timestamp and message from the payload
    final messageBeginIndex = payload.indexOf(" ", index + 1);
    final timestamp = payload.substring(index + 1, messageBeginIndex);
    final message = payload.substring(messageBeginIndex + 1);

    final cacheKey = "$origin $timestamp";

    // check if the message already exists in the cache
    // if it does we discard it
    if (!this._cache.contains(cacheKey)) {
      // TODO: items will need to be evicted from cache every so often, maybe every minute remove items that are a minute+ old?
      this._cache.add(cacheKey);

      this.events[CommunicationEvent.onMessageReceived].fire({
        "origin": origin,
        "message": message,
      });
      this._encodeAndSendMessage(payload, excludedIds: tags);
    }
  }

  void sendMessage(String message) {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();

    assert(this.id != null);

    _encodeAndSendMessage("$id $timestamp $message");
  }

  void _encodeAndSendMessage(String message, {Set<String> excludedIds}) {
    final mailingList =
        this._connections.difference(excludedIds ?? Set<String>());

    // if the mailing list is empty we can short-circuit the entire process
    // and not bother trying to forward the payload
    if (mailingList.isEmpty) return;
    final taggedIds = mailingList.reduce((a, b) => a + b);

    final payload = utf8.encode(taggedIds + message);

    this.hardware.sendPayload(mailingList, payload);
  }

  Future<void> disconnect() {
    // TODO: instead of having to clear the following 3 fields, consider putting
    // them in a "network state" class that we simply set to null, and reassign
    // when a new connection is created
    this.id = null;
    this._connections.clear();
    this._cache.clear();

    this.hardware.endScan();
    return this.hardware.disconnect();
  }
}
