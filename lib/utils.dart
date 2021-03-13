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

  @override
  int get hashCode {
    return 0;
  }

  @override
  String toString() {
    // TODO: implement toString
    return "$_lower$_upper";
  }
}

class UserInfo {
  final String name;
  bool isOnline = true;
  UUID userId;
  static final List<Color> colorPalette = [
    Colors.blue[50],
    Colors.blue[200],
    Colors.amber[50],
    Colors.amber[200],
    Colors.pink[50],
    Colors.pink[200],
    Colors.green[50],
    Colors.green[200],
    Colors.indigo[50],
    Colors.indigo[200],
    Colors.cyan[50],
    Colors.cyan[200],
    Colors.teal[50],
    Colors.teal[200],
    Colors.lime[50],
    Colors.lime[200],
    Colors.deepOrange[200],
    Colors.deepOrange[50],
    Colors.red[50],
    Colors.red[200]
  ];

  static final List<String> adjectives = [
    "Happy",
    "Sad",
    "Angry",
    "Indignant",
    "Annoyed",
    "Blue",
    "Charming",
    "Clumsy",
    "Funny",
    "Cute",
    "Confused",
    "Defiant",
    "Bubbly",
  ];
  static final List<String> nouns = [
    "Capybara",
    "Rhino",
    "Panda",
    "Kangaroo",
    "Platypus",
    "Puppy",
    "Kitten",
    "Spider",
    "Penguin",
    "Owl",
    "Bear",
    "Frog",
    "Axolotl",
  ];
  Color color;

  UserInfo({
    @required this.name,
    @required this.userId,
    this.isOnline,
  }) {
    this.color = getRandomItemFromArray(colorPalette);
  }

  static String generateUsername() {
    String begin = getRandomItemFromArray(UserInfo.adjectives);
    String end = getRandomItemFromArray(UserInfo.nouns);
    return begin + end;
  }
}

class MessageBlock {
  final List<Message> messages;
  final UserInfo user;

  MessageBlock({@required this.messages, @required this.user});

  MessageBlock.withMessage({@required Message message, @required this.user})
      : messages = [] {
    messages.add(message);
  }
}

class Message {
  final String messageText;
  final DateTime time;

  Message({
    @required this.time,
    @required this.messageText,
  });
}

class NetworkState {
  var _state = Map<UserInfo, List<UserInfo>>();

  void makeConnection(UserInfo a, UserInfo b) {
    _state[a].add(b);
    _state[b].add(a);
  }

  String serialize() {
    String value = "";
    for (final user in _state.keys) {
      value += "user.id";
      for (final connection in _state[user]) {
        value += "connection.id" + "-";
      }
      value += ",";
    }

    return value;
  }
}

String getFormattedTime(DateTime time) {
  String zeroPadding = "";
  if (time.minute < 10) {
    zeroPadding = "0";
  }

  int hour = time.hour;
  if (hour > 12) {
    hour -= 12;
  }
  if (hour == 0) {
    hour = 12;
  }

  return "$hour:$zeroPadding${time.minute}";
}

final Random _random = new Random();
T getRandomItemFromArray<T>(List<T> items) {
  return items[_random.nextInt(items.length)];
}
