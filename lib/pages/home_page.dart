
import 'package:flutter/material.dart';
import 'package:okbluemer/pages/scan_page.dart';
import 'package:okbluemer/utils.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName;

  @override
  void initState() {
    super.initState();

    userName = UserInfo.generateUsername();
  }

  void _onClickContinue() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ScanPage(userName)),
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
            SizedBox(height: 120),
            TextField(
              onChanged: (inputedUserName) {
                userName = inputedUserName;
              },
              controller: TextEditingController(text: userName),
              decoration: InputDecoration(hintText: "User Name"),
            ),
            SizedBox(
              height: 16,
            ),
            RaisedButton(
              onPressed: _onClickContinue,
              child: Text(
                "Continue",
                style: TextStyle(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
              splashColor: Colors.white,
              highlightColor: Colors.transparent,
              color: Colors.white.withAlpha(220),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
