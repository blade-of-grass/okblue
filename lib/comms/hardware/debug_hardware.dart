import 'dart:math';
import 'dart:typed_data';
import 'dart:convert';

import 'package:okbluemer/comms/comms_utils.dart';
import 'package:okbluemer/utils.dart';

final CommsHardware debugHardware = DebugHardware.instance;

class DebugHardware implements CommsHardware {
  CommsConfiguration _config;
  bool _shouldScan = false;

  static const ID_COUNT = 100;
  static const ID_LENGTH = 4;

  static const ODDS_OF_A_SUCCESSFUL_CONNECTION = 0.8;

  final generatedIds = Set<String>();
  final takenIds = Set<String>();
  final random = new Random();

  Set<String> get unusedIds => generatedIds.difference(this.takenIds);

  String getAndUseID() {
    final idPool = this.unusedIds.toList(growable: false);
    final id = idPool[random.nextInt(idPool.length)];

    takenIds.add(id);

    return id;
  }

  static DebugHardware _instance;
  static DebugHardware get instance {
    if (_instance == null) {
      _instance = DebugHardware._init();
    }
    return _instance;
  }

  DebugHardware._init() {
    const PERMITTED_CHARACTERS =
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-~!@#\$%^&*()<>?:,./;'\[]{}|";

    for (int i = 0; i < ID_COUNT; ++i) {
      var id = "";
      for (int j = 0; j < ID_LENGTH; ++j) {
        id += PERMITTED_CHARACTERS[random.nextInt(PERMITTED_CHARACTERS.length)];
      }

      generatedIds.add(id);
    }
  }

  Future<bool> checkPermissions() async => true;

  void sendPayload(Set<String> mailingList, Uint8List payload) {}

  Future<void> disconnect() async {}

  void endScan() => this._shouldScan = false;

  void beginScan(CommsConfiguration config) async {
    this._config = config;
    this._shouldScan = true;

    final self = getAndUseID();

    Future.doWhile(() async {
      String a = getAndUseID();
      assert(this._config.onDeviceFound(a));
      await Future.delayed(Duration(seconds: 1));
      this._config.onConnectSuccess(a);

      final handshake = utf8.encode(self);
      this._config.onPayloadReceived(a, handshake);

      await Future.delayed(Duration(seconds: 3));

      final timestamp = DateTime.now();
      final message = Message(time: timestamp, text: "hello world");
      final user = UserInfo(id: a, name: null, isOnline: true);
      final packet = Packet(message: message, user: user);
      final payload = a +
          " " +
          timestamp.millisecondsSinceEpoch.toString() +
          " " +
          packet.serialize();
      final bytes = Uint8List.fromList(utf8.encode(payload));

      this._config.onPayloadReceived(a, bytes);

      // if (random.nextDouble() < ODDS_OF_A_SUCCESSFUL_CONNECTION) {
      //   this._config.onConnectSuccess(id);
      // } else {
      //   this._config.onConnectFail(id);
      // }{
      // this._config.onDisconnect(id);

      await Future.delayed(Duration(seconds: 2));

      return this._shouldScan;
    });
  }
}
