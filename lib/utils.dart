import 'package:flutter/material.dart';
import 'dart:math';

class UUID {
  int _upper, _lower;

  UUID() {
    // TODO: implement this properly based on the documentation here
    // https://en.wikipedia.org/wiki/Universally_unique_identifier

    // dart doesn't have a 128 bit integer type by default
    // but int is 64 bits when not compiled to javascript
    // so if we ever compile to javascript we'll have to handle this differently
    _upper = 0;
    _lower = 0;
  }

  @override
  bool operator ==(other) =>
      other is UUID &&
      this._upper == other._upper &&
      this._lower == other._lower;
}

class UserInfo {
  final String name;
  String onlineStatus = "Online";
  UUID userId;
  static final List<Color> colorPalette = [
    Colors.blue[100],
    Colors.blue[50],
    Colors.blue[200],
    Colors.amber[50],
    Colors.amber[100],
    Colors.amber[200],
    Colors.pink[50],
    Colors.pink[100],
    Colors.pink[200],
    Colors.green[50],
    Colors.green[100],
    Colors.green[200],
    Colors.red[50],
    Colors.red[100],
    Colors.red[200]
  ];
  Color color;

  UserInfo({
    @required this.name,
    @required this.onlineStatus,
    @required this.userId,
  }) {
    Random random = new Random();
    int index = random.nextInt(colorPalette.length);
    this.color = colorPalette[index];
  }
}

class Message {
  // messageType is used to determine sender/reciever (to properly display message layout)
  String messageText, messageType, time;
  UserInfo user;

  Message({
    @required this.user,
    @required this.messageType,
    @required this.time,
    @required this.messageText,
  });
}

class NetworkState {
  // Map<>
}
