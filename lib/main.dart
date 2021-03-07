import 'package:flutter/material.dart';
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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String userName;
  void _onClickContinue() {
    print(userName);
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
            TextField(
              onChanged: (inputedUserName) {
                userName = inputedUserName;
              },
              decoration: InputDecoration(hintText: "User Name"),
            ),
            SizedBox(
              height: 30,
            ),
            RaisedButton(
              onPressed: _onClickContinue,
              child: Text("Continue"),
            ),
          ],
        ),
      ),
    );
  }
}
