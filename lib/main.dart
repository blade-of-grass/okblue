import 'package:flutter/material.dart';
import 'package:okbluemer/blocs/communications_bloc.dart';
import 'package:okbluemer/blocs/message_bloc.dart';
import 'package:okbluemer/pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MessageBloc(
      // the message bloc contains all of the messages sent & received in the app
      child: CommunicationBloc(
        // the bluetooth bloc manages all bluetooth connection info
        child: MaterialApp(
          title: 'Ok Bluemer',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.red,
            scaffoldBackgroundColor: HSLColor.fromColor(Colors.indigo)
                .withSaturation(0.2)
                .withLightness(0.1)
                .toColor(),
          ),
          home: HomePage(),
        ),
      ),
    );
  }
}
