import 'package:flutter/material.dart';

import 'package:okbluemer/customizations.dart';

class UserInfo {
  final String name;
  final String userId;
  final Color color;
  bool isOnline;

  UserInfo({
    @required String name,
    this.userId = "",
    this.isOnline = true,
  })  : color = getRandomColor(),
        name = validateName(name);

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
class MessageGroup {
  final List<Message> messages;
  final UserInfo user;

  /// construct a MessageBlock from a list of messages and their associated user
  MessageGroup({@required this.messages, @required this.user});

  /// construct a MessageBlock with a single message and it's associated user
  MessageGroup.withMessage({@required Message message, @required this.user})
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

  static Message deserialize(String data) {
    int delimiter = data.indexOf(" ");
    String date = data.substring(0, delimiter);
    String message = data.substring(delimiter + 1);

    return Message(
      time: DateTime.fromMicrosecondsSinceEpoch(int.parse(date)),
      messageText: message,
    );
  }

  String serialize() {
    return time.millisecondsSinceEpoch.toString() + " " + messageText;
  }
}

class NetworkState {
  var _state = Map<UserInfo, List<UserInfo>>();

  void makeConnection(UserInfo a, UserInfo b) {
    _state[a].add(b);
    _state[b].add(a);
  }

  // String serialize() {
  //   String value = "";
  //   for (final user in _state.keys) {
  //     value += "user.id";
  //     for (final connection in _state[user]) {
  //       value += "connection.id" + "-";
  //     }
  //     value += ",";
  //   }

  //   return value;
  // }
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

class EventListener {
  final _listeners = Set<Function(dynamic)>();

  void subscribe(Function(dynamic) listener) {
    _listeners.add(listener);
  }

  void unsubscribe(Function(dynamic) listener) {
    _listeners.remove(listener);
  }

  void fire(dynamic data) {
    _listeners.forEach((listener) => listener(data));
  }
}
