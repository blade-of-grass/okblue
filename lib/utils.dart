import 'package:flutter/material.dart';

import 'package:okbluemer/customizations.dart';

class Packet {
  UserInfo user;
  Message message;

  Packet({@required this.user, @required this.message});

  static Packet deserialize(dynamic payload) {
    final origin = payload["origin"];
    final data = payload["message"];

    int start = 0;
    int end = data.indexOf(" ", start);
    final name = data.substring(start, end).replaceAll("%20", " ");

    start = end + 1;
    end = data.indexOf(" ", start);
    String date = data.substring(start, end);

    start = end + 1;
    String message = data.substring(start);

    return Packet(
      message: Message(
        time: DateTime.fromMillisecondsSinceEpoch(int.parse(date)),
        text: message,
      ),
      user: UserInfo(
        name: name,
        id: origin,
      ),
    );
  }

  String serialize() {
    final name = this.user.name.replaceAll(" ", "%20");
    final time = this.message.time.millisecondsSinceEpoch.toString();
    final text = this.message.text;

    return "$name $time $text";
  }
}

class UserInfo {
  final String name;
  final String id;
  bool isOnline;

  Color _color;
  Color get color {
    if (_color == null) {
      _color = getDeterministicColor(id + name);
    }
    return _color;
  }

  UserInfo({
    @required String name,
    @required this.id,
    this.isOnline = true,
  }) : name = validateName(name);

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

  bool commpareIdentifiers(UserInfo other) {
    return this.id == other.id && this.name == other.name;
  }
}

/// a class representing a "block" of messages sent by a single user
class MessageGroup {
  final List<Message> messages;
  final UserInfo user;

  /// construct a MessageBlock from a list of messages and their associated user
  MessageGroup({@required this.messages, @required this.user});

  /// construct a MessageBlock with a single message and it's associated user
  MessageGroup.withPacket(Packet packet)
      : messages = [],
        user = packet.user {
    messages.add(packet.message);
  }
}

/// a class representing a single message, contains message text and time sent
class Message {
  final String text;
  final DateTime time;

  Message({
    @required this.time,
    @required this.text,
  });
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
