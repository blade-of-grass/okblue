import 'package:beacon_broadcast/beacon_broadcast.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beacon/flutter_beacon.dart';

class Beacon {
  final our_uuid = "d6052cb2-8aa0-11eb-8dcd-0242ac130003";
  final _broadcaster = BeaconBroadcast();
  bool _deviceSupportsBeacons;
  static const MAJOR_ID = 7879;
  static const MINOR_ID = 6907;

  // beacon singleton
  static Beacon _instance;
  static Beacon get instance {
    if (_instance == null) {
      _instance = Beacon._init();
    }
    return _instance;
  }

  Beacon._init();

  Future<bool> get supportsBeacons async {
    if (_deviceSupportsBeacons == null) {
      final transmissionSupportStatus =
          await this._broadcaster.checkTransmissionSupported();
      _deviceSupportsBeacons =
          transmissionSupportStatus == BeaconStatus.supported;
    }
    return _deviceSupportsBeacons;
  }

  void write(String packet) {
    // TODO: break packets

    _broadcaster
        .setUUID(this.our_uuid)
        .setAdvertiseMode(AdvertiseMode.balanced)
        .setMajorId(Beacon.MAJOR_ID)
        .setMinorId(Beacon.MINOR_ID)
        .setIdentifier("okbluemer")
        .start();
  }

  void read() async {
    try {
      // if you want to manage manual checking about the required permissions
      await flutterBeacon.initializeScanning;

      // or if you want to include automatic checking permission
      await flutterBeacon.initializeAndCheckScanning;

      // if (Platform.isIOS) {
      //   // iOS platform, at least set identifier and proximityUUID for region scanning
      //   regions.add(Region(
      //       identifier: 'Apple Airlocate',
      //       proximityUUID: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0'));
      // } else {
      //   // android platform, it can ranging out of beacon that filter all of Proximity UUID
      //   regions.add(Region(identifier: 'com.beacon'));
      // }

      final regions = <Region>[
        Region(
          identifier: "all-beacons-region",
          major: Beacon.MAJOR_ID,
          minor: Beacon.MINOR_ID,
        ),
      ];

      // to start ranging beacons
      final readStream =
          flutterBeacon.ranging(regions).listen((RangingResult result) {
        // result contains a region and list of beacons found
        // list can be empty if no matching beacons were found in range
        result.beacons.forEach((beacon) async {
          print(beacon.proximityUUID);
          if (beacon.proximityUUID == this.our_uuid) {
            print("we found our guy");
          }
        });
      });

      // to stop ranging beacons
      // readStream.cancel();

    } on PlatformException catch (e) {
      // library failed to initialize, check code and message
    }
  }
}
