import 'package:flutter/material.dart';
import 'package:okbluemer/blocs/message_bloc.dart';
import 'package:okbluemer/pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MessageBloc(child: MaterialApp(
      title: 'Ok Bluemer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: HSLColor.fromColor(Colors.indigo).withSaturation(0.2).withLightness(0.2).toColor(),
      ),
      home: HomePage(),
    ));
  }
}
