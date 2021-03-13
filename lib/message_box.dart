import 'package:flutter/material.dart';
import 'package:okbluemer/utils.dart';

class MessageBox extends StatelessWidget {
  final MessageBlock messageBlock;
  final CrossAxisAlignment alignment;

  MessageBox({
    @required this.messageBlock,
    @required this.alignment,
  });

  Widget build(BuildContext context) {
    final List<Widget> cards = this
        .messageBlock
        .messages
        .map(makeCardFromMessage)
        .toList(growable: false);

    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          ...cards,
          Text(
            this.messageBlock.user.name,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget makeCardFromMessage(Message message) {
    return Container(
        constraints: BoxConstraints.loose(Size(300, double.infinity)),
        child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.black, width: 0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          color: this.messageBlock.user.color,
          margin: EdgeInsets.fromLTRB(0, 4, 0, 0),
          child: Padding(
            padding: EdgeInsets.only(top: 8, right: 8, left: 8, bottom: 4),
            child: Column(
              crossAxisAlignment: alignment,
              children: [
                Text(message.messageText),
                SizedBox(height: 4),
                Text(
                  getFormattedTime(message.time),
                  style: TextStyle(fontSize: 11),
                ),
              ],
            ),
          ),
        ));
  }
}
