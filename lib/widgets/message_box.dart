import 'package:flutter/material.dart';
import 'package:okbluemer/utils.dart';

class MessageBox extends StatelessWidget {
  final MessageGroup messageBlock;
  final CrossAxisAlignment alignment;
  final bool isLocalUser;

  MessageBox({
    @required this.messageBlock,
    @required this.isLocalUser,
  }) : alignment =
            isLocalUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;

  Widget build(BuildContext context) {
    final List<Widget> cards = this
        .messageBlock
        .messages
        .map(makeCardFromMessage)
        .toList(growable: false);

    final List<Widget> nameplateInfo = [];

    if (!isLocalUser) {
      nameplateInfo.addAll(
        [
          _StatusCircle(user: this.messageBlock.user),
          SizedBox(
            width: 2,
          ),
        ],
      );
    }
    nameplateInfo.add(Text(
      this.messageBlock.user.name,
      style: TextStyle(color: Colors.white),
    ));

    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          ...cards,
          Padding(
            padding: EdgeInsets.only(right: 8, left: 8),
            child: Row(
              mainAxisAlignment: (alignment == CrossAxisAlignment.end
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start),
              children: nameplateInfo,
            ),
          ),
        ],
      ),
    );
  }

  Widget makeCardFromMessage(Message message) {
    return _MessageCard(
      color: this.messageBlock.user.color,
      alignment: this.alignment,
      message: message,
    );
  }
}

class _StatusCircle extends StatelessWidget {
  final UserInfo user;

  _StatusCircle({@required this.user});

  @override
  Widget build(BuildContext context) {
    // TODO: wrap this in a stream builder
    // remove the isOnline property from user
    // instead use CommunicationBloc.of(context) and access an "online state stream" by user id
    return Icon(
      Icons.circle,
      color: (this.user.isOnline ? Colors.green : Colors.grey),
      size: 8,
    );
  }
}

class _MessageCard extends StatelessWidget {
  final Color color;
  final CrossAxisAlignment alignment;
  final Message message;

  _MessageCard({
    @required this.color,
    @required this.alignment,
    @required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.loose(Size(300, double.infinity)),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: this.color,
        margin: EdgeInsets.fromLTRB(4, 1, 4, 0),
        child: Padding(
          padding: EdgeInsets.only(top: 8, right: 8, left: 8, bottom: 4),
          child: Column(
            crossAxisAlignment: this.alignment,
            children: [
              Text(this.message.text),
              SizedBox(height: 4),
              Text(
                getFormattedTime(this.message.time),
                style: TextStyle(fontSize: 11, color: Colors.black38),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
