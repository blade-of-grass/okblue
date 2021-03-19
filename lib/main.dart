import 'package:flutter/material.dart';
import 'package:okbluemer/blocs/bluetooth_bloc.dart';
import 'package:okbluemer/blocs/message_bloc.dart';
import 'package:okbluemer/pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: the MessageBloc and BluetoothBloc probably shouldn't be root dependencies of the app
    // instead the hierarchy should be more like the following, but this can be refactored later
    //
    // MaterialApp
    // \ HomePage
    //     MessageBloc
    //       \ BluetoothBloc
    //           \ ScanPage
    //           \ MessagePage
    //

    return MessageBloc( // the message bloc contains all of the messages sent & received in the app
      child: BluetoothBloc( // the bluetooth bloc manages all bluetooth connection info
        child: MaterialApp(
          title: 'Ok Bluemer',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.indigo,
            scaffoldBackgroundColor: HSLColor.fromColor(Colors.indigo).withSaturation(0.2).withLightness(0.1).toColor(),
          ),
          home: HomePage(),
        ),
      ),
    );
  }
}
