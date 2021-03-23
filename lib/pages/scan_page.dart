import 'package:flutter/material.dart';
import 'package:okbluemer/blocs/bluetooth_bloc.dart';
import 'package:okbluemer/pages/message_page.dart';
import 'package:okbluemer/utils.dart';

class ScanPage extends StatefulWidget {
  final String username;
  ScanPage(this.username);

  @override
  State<StatefulWidget> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  // Need to add methods when detect connections

  BluetoothBlocState bt;

  @override
  void initState() {
    super.initState();

    this.bt = BluetoothBloc.of(context);
    this.bt.subscribe(BluetoothEvent.onConnect, onConnect);

    this.bt.scan(this.widget.username);
  }

  @override
  void dispose() {
    this.bt.unsubscribe(BluetoothEvent.onConnect, onConnect);

    super.dispose();
  }

  void onConnect(dynamic _) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MessagePage(
          user: UserInfo(name: this.widget.username),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/icon.png"),
            SizedBox(height: 48),
            Text(
              "We're looking for a room for you, " + this.widget.username,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
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
