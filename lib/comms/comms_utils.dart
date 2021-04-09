import 'dart:typed_data';
import 'package:flutter/foundation.dart';

enum CommunicationEvent {
  /// triggered when a connection is made, args include the other user's id
  onConnect,

  /// triggered when a connection is broken, args include the other user's id
  onDisconnect,

  /// triggered when a new connection is made, args include your user id
  onJoin,

  /// triggered when an application defined message has been received
  /// sends a dynamic in the form { "origin": String, "message": String}
  onMessageReceived,
}

/// an interface to interact with the "hardware layer" of whatever connection library we end up using
/// all of these endpoints need to be implemented, and the callbacks in [CommsConfiguration] must
/// be called in proper locations. I will write out a more detailed specification of the contract
/// that the implementor of this class must be fulfill if necessary.
abstract class CommsHardware {
  /// check if the relevant permissions are enabled
  /// we don't handle this purely internally in case we want to display UI to the user informing them why we need certain permissions
  Future<bool> checkPermissions();

  /// begin scanning for a connection, requires a well defined [CommsConfiguration] instance
  /// won't stop until [endScan] is called
  void beginScan(CommsConfiguration config);

  /// stop scanning for connections
  void endScan();

  /// send payload to all submitted ids
  void sendPayload(Set<String> mailingList, Uint8List payload);

  /// disconnect from all other devices
  Future<void> disconnect();
}

/// a config class that allows [CommsHardware] to interact with a higher layer of the app
class CommsConfiguration {
  /// the username to show while advertising/discovering connections
  String username;

  /// the service ID of your application
  String serviceID;

  /// called when [CommsHardware] detects a device available for connection
  /// [CommsHardware] calls this function to ask if it should connect to this device
  /// [id] and [username] parameters are properties belonging to the other device
  /// return true if you wish to initiate a connection, false otherwise
  bool Function(String id, String username) onDeviceFound;

  /// called when [CommmsHardware] successfully establishes a connection with device identified by [id]
  void Function(String id) onConnectSuccess;

  /// called when [CommmsHardware] failed to establish a connection with device identified by [id]
  void Function(String id) onConnectFail;

  /// called when [CommmsHardware] receives a [payload] from device identified by [id]
  void Function(String id, Uint8List payload) onPayloadReceived;

  /// called when [CommmsHardware] disconnects from a device identified by [id]
  void Function(String id) onDisconnect;

  CommsConfiguration({
    @required this.username,
    @required this.serviceID,
    @required this.onDeviceFound,
    @required this.onConnectSuccess,
    @required this.onConnectFail,
    @required this.onPayloadReceived,
    @required this.onDisconnect,
  });
}

class EventListener {
  final _listeners = Set<Function(dynamic)>();

  void clear() => _listeners.clear();

  void subscribe(Function(dynamic) listener) => _listeners.add(listener);

  void unsubscribe(Function(dynamic) listener) => _listeners.remove(listener);

  void fire(dynamic data) => _listeners.forEach((listener) => listener(data));
}
