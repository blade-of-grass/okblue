import 'dart:math';
import 'dart:typed_data';

import 'package:okbluemer/comms/comms_utils.dart';

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

    Future.doWhile(() async {
      return this._shouldScan;
    });
  }

  void _onConnectionResult(String id) {
    if (random.nextDouble() < ODDS_OF_A_SUCCESSFUL_CONNECTION) {
      this._config.onConnectSuccess(id);
    } else {
      this._config.onConnectFail(id);
    }
  }

  void _onDisconnected(String id) {
    this._config.onDisconnect(id);
  }

  void _onPayloadReceived(String id) {
    this._config.onPayloadReceived(id, bytes);
  }
}
