import 'package:flutter/material.dart';

// Using layout of homepage

class ScanPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  // Need to add methods when detect connections

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[400],
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.red[300],
                shape: BoxShape.circle,
              ),
              width: 180,
              height: 180,
            ),
            SizedBox(
              height: 180,
            ),
            Text(
              "Scanning...",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30),
            ),
          ],
        ),
      ),
    );
  }
}
