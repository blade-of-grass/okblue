import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:okbluemer/customizations.dart';
import 'package:okbluemer/utils.dart';

/// generate a list of messages & users, sending them to a provided function
///
/// self - the user representing the current "user" of the app
/// addMessage - a function that each message along with it's sender will get passed into
/// messages - the number of messages to generate
/// users - the number of users to generate
getFillerTestMessages(
    UserInfo self, void addMessage(Message message, UserInfo user),
    {int messages = 30, int users = 6}) {
  // don't allow test messages to be shown in release mode
  if (kReleaseMode) {
    return;
  }

  // generate user list
  final List<UserInfo> sampleUsers = [];
  Random random = new Random();
  for (int i = 0; i < users; ++i) {
    sampleUsers.add(UserInfo(name: null, isOnline: random.nextBool()));
  }
  sampleUsers.add(self);

  // generate message list
  final List<Message> sampleMessages = [
    Message(text: "hello there", time: DateTime.now()),
    Message(text: "is anyone out there", time: DateTime.now()),
    Message(text: "goodbye then", time: DateTime.now()),
    Message(text: "I'm here", time: DateTime.now()),
    Message(text: "me too", time: DateTime.now()),
    Message(text: "do you all want to get some food?", time: DateTime.now()),
    Message(text: "I'm not sure", time: DateTime.now()),
    Message(
        text:
            "I'm now going to type a very long message to test how the message box reacts to receiving a very long string that is above and beyond the normal expected length for a message to be received I'm rambling now but that's ok I'm just trying to generate text or as much text as possible",
        time: DateTime.now()),
    Message(text: "ok that's weird I'm leaving", time: DateTime.now()),
    Message(text: "goodbye", time: DateTime.now()),
  ];

  // send messages and users to the provided function
  for (int i = 0; i < messages; ++i) {
    addMessage(getRandomItemFromArray(sampleMessages),
        getRandomItemFromArray(sampleUsers));
  }
}
