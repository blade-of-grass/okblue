import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:okbluemer/blocs/communications_bloc.dart';
import 'package:okbluemer/blocs/message_bloc.dart';
import 'package:okbluemer/colors.dart';
import 'package:okbluemer/pages/home_page.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: appBarColor,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MessageBloc(
      // [MessageBloc] contains all of the messages sent & received in the app
      child: CommunicationBloc(
        // [CommunicationBloc] manages all bluetooth connection info
        child: MaterialApp(
          title: 'Ok Bluemer',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.deepOrange,
            scaffoldBackgroundColor: backgroundColor,
          ),
          home: HomePage(),
        ),
      ),
    );
  }
}
