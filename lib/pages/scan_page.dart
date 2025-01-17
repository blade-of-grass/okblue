import 'package:flutter/material.dart';
import 'package:okbluemer/blocs/communications_bloc.dart';
import 'package:okbluemer/comms/comms_utils.dart';
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

  CommunicationBlocState bt;

  @override
  void initState() {
    super.initState();

    this.bt = CommunicationBloc.of(context);
    this.bt.subscribe(CommunicationEvent.onJoin, this.onJoin);
  }

  @override
  void dispose() {
    this.bt.unsubscribe(CommunicationEvent.onJoin, this.onJoin);

    super.dispose();
  }

  void onJoin(dynamic id) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MessagePage(
          user: UserInfo(id: id, name: this.widget.username),
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
