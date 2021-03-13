import 'package:flutter/material.dart';
import 'package:okbluemer/utils.dart';
import './scan_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ok Bluemer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String userName;

  @override
  void initState() {
    // TODO: implement initState
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
      backgroundColor: Colors.cyan[400],
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
                  color: Colors.cyan[400],
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
