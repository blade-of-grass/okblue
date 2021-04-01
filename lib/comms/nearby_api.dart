import 'dart:math';
import 'dart:typed_data';

import 'package:nearby_connections/nearby_connections.dart';
import 'package:okbluemer/comms/comms_interface.dart';

final CommsHardware nearbyAPI = _NearbyAPI.instance;

class _NearbyAPI implements CommsHardware {
  CommsConfiguration _config;
  bool _shouldScan = false;

  // a simple "reference counter" to keep track of pending connections
  int _pendingConnections = 0;
  final _service = Nearby();

  // singleton + private constructor combo
  // this will effectively prevent details about _NearbyAPI from escaping this file
  static CommsHardware _instance;
  static CommsHardware get instance {
    if (_instance == null) {
      _instance = _NearbyAPI._init();
    }
    return _instance;
  }

  _NearbyAPI._init();

  bool get attemptingConnection => this._pendingConnections > 0;

  Future<void> _advertise() async {
    try {
      await this._service.startAdvertising(
            this._config.username,
            Strategy.P2P_CLUSTER,
            onConnectionInitiated: this._onConnectionInitiated,
            onConnectionResult: this._onConnectionResult,
            onDisconnected: this._onDisconnected,
            serviceId: this._config.serviceID,
          );
    } catch (e) {
      print(e);
    }
  }

  Future<void> _discover() async {
    try {
      await this._service.startDiscovery(
        this._config.username,
        Strategy.P2P_CLUSTER,
        onEndpointFound: (String id, String username, String serviceId) {
          if (this._config.onDeviceFound(id, username)) {
            print(
                "found advertiser with name $username and id $id, requesting connection");
            this._service.requestConnection(
                  username,
                  id,
                  onConnectionInitiated: this._onConnectionInitiated,
                  onConnectionResult: this._onConnectionResult,
                  onDisconnected: this._onDisconnected,
                );
          }

          // TODO: the following line was in our working implementation, I am unsure if it is necessary
          // this._service.stopDiscovery();
        },
        onEndpointLost: (String id) {
          // called when an advertiser is lost (only if we weren't connected to it )
        },
        serviceId: this._config.serviceID,
      );
    } catch (e) {
      print(e);
    }
  }

  Future<bool> checkPermissions() async {
    final hasLocationPermissions =
        await this._service.checkLocationPermission();

    if (!hasLocationPermissions) {
      return await this._service.askLocationPermission();
    } else {
      return true;
    }

    // // OPTIONAL: if you need to transfer files and rename it on device
    // bool b = await this.service.checkExternalStoragePermission();
    // // asks for READ + WRTIE EXTERNAL STORAGE permission only if its not given
    // Nearby().askExternalStoragePermission() ;
  }

  void beginScan(CommsConfiguration config) async {
    this._config = config;

    this._shouldScan = true;

    await this._service.stopAllEndpoints();

    final _random = Random();
    const baseDelaySeconds = 2;
    const variationDelaySeconds = 5;

    Future.doWhile(() async {
      await _advertise();

      // wait in advertising mode between 2 & 6 seconds
      await Future.delayed(Duration(
          seconds: baseDelaySeconds + _random.nextInt(variationDelaySeconds)));

      // if we are attempting a connection, stay here
      await Future.doWhile(() => this.attemptingConnection);

      // stop advertising, prepare to switch to discovery mode
      await this._service.stopAdvertising();

      // repeat the same process as above, but now in discovery mode
      await _discover();
      await Future.delayed(Duration(
          seconds: baseDelaySeconds + _random.nextInt(variationDelaySeconds)));
      await Future.doWhile(() => this.attemptingConnection);
      await this._service.stopDiscovery();

      return this._shouldScan;
    });
  }

  void endScan() {
    this._shouldScan = false;
  }

  /// if a connection is initiated, accept it immediately
  /// increment [_pendingConnections] as well
  void _onConnectionInitiated(String id, ConnectionInfo info) {
    print("onConnectionInitiated $id");
    ++this._pendingConnections;

    this._service.acceptConnection(
          id,
          onPayLoadRecieved: this._onPayloadReceived,
          onPayloadTransferUpdate: this._onPayloadTransferUpdate,
        );
  }

  /// if the connection succeeded, trigger an onConnectSuccess event
  /// if the connection failed, trigger an onConnectFail event
  ///
  /// decrement [_pendingConnections]
  void _onConnectionResult(String id, Status status) {
    print("onConnectionResult $id $status");
    --this._pendingConnections;

    if (status == Status.CONNECTED) {
      this._config.onConnectSuccess(id);
    } else {
      this._config.onConnectFail(id);
    }
  }

  /// called on disconnect, triggers an onDisconnect event
  void _onDisconnected(String id) {
    print("disconnected from $id");

    this._config.onDisconnect(id);
  }

  /// triggers an onPayloadReceived event
  void _onPayloadReceived(String id, Payload payload) {
    print("payload receieved from $id");

    this._config.onPayloadReceived(id, payload.bytes);
  }

  void _onPayloadTransferUpdate(String id, PayloadTransferUpdate update) {}

  /// iterates through [ids], sending [payload] to the connection represented by each one
  void sendPayload(Set<String> ids, Uint8List payload) {
    ids.forEach((connection) {
      this._service.sendBytesPayload(connection, payload);
    });
  }
}
