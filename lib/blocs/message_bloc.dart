import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:okbluemer/utils.dart';

class MessageBloc extends StatefulWidget {
  final Widget child;

  MessageBloc({@required this.child});

  @override
  MessageBlocState createState() => MessageBlocState();

  static MessageBlocState of(BuildContext context) {
    return context.findAncestorStateOfType<MessageBlocState>();
  }
}

class MessageBlocState extends State<MessageBloc> {
  final _messageStream = StreamController<List<MessageGroup>>.broadcast();
  final List<MessageGroup> _messages = [];

  Stream<List<MessageGroup>> get stream => _messageStream.stream;

  List<MessageGroup> get currentMessages => _messages;

  void addMessage(Message message, UserInfo user) {
    if (this._messages.isNotEmpty) {
      final lastBlock = this._messages.last;
      // TODO: switch this to user id
      if (lastBlock.user == user) {
        lastBlock.messages.add(message);
        this._messageStream.add(this._messages);

        return;
      }
    }
    this._messages.add(MessageGroup.withMessage(message: message, user: user));
    this._messageStream.add(this._messages);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    this._messageStream.close();
    super.dispose();
  }
}