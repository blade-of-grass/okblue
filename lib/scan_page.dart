import 'package:flutter/material.dart';
import 'package:okbluemer/message_page.dart';
import 'package:okbluemer/utils.dart';

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

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MessagePage(
                user: UserInfo(
                  name: this.widget.username,
                  userId: UUID(),
                ),
              )),
    );
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
            SizedBox(height: 120),
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
