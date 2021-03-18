import 'package:flutter/material.dart';
import 'dart:math';

import 'package:okbluemer/customizations.dart';

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
  final UUID userId;
  final Color color;
  bool isOnline;

  UserInfo({
    @required String name,
    @required this.userId,
    this.isOnline = true,
  }) : color = getRandomColor(), name = validateName(name);

  static String generateUsername() {
    return getRandomName();
  }

  static String validateName(String submittedName) {
    if (submittedName == null || submittedName.isEmpty) {
      return generateUsername();
    } else {
      return submittedName;
    }
  }
}

/// a class representing a "block" of messages sent by a single user
class MessageBlock {
  final List<Message> messages;
  final UserInfo user;

  /// construct a MessageBlock from a list of messages and their associated user
  MessageBlock({@required this.messages, @required this.user});

  /// construct a MessageBlock with a single message and it's associated user
  MessageBlock.withMessage({@required Message message, @required this.user})
      : messages = [] {
    messages.add(message);
  }
}

/// a class representing a single message, contains message text and time sent
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
