import 'package:flutter/material.dart';
// import 'package:flutter_blue/flutter_blue.dart';

// Using layout of homepage

class ScanPage extends StatefulWidget {
  final String username;
  ScanPage(this.username);

  @override
  State<StatefulWidget> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  // Need to add methods when detect connections

  @override
  void initState() {
    super.initState();

    // FlutterBlue flutterBlue = FlutterBlue.instance;
    // // Start scanning
    // flutterBlue.startScan(timeout: Duration(seconds: 4));

    // // Listen to scan results
    // var subscription = flutterBlue.scanResults.listen((results) async {
    //   // do something with scan results
    //   for (ScanResult r in results) {
    //     print('${r.device.name} found! rssi: ${r.rssi}');

    //     var x = await r.device.isDiscoveringServices.first;
    //     print('services: ${x}');
    //   }
    // });

    // // Stop scanning
    // flutterBlue.stopScan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[400],
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/icon.png"),
            SizedBox(height: 48),
            Text(
              "Scanning...",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
