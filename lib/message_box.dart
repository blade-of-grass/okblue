import 'package:flutter/material.dart';
import 'package:okbluemer/utils.dart';

// This might not need to be a statefulwidget and maybe just a stateless widget...
class MessageBox extends StatefulWidget {
  final List<Message> messages;
  final UserInfo user;

  MessageBox(
    this.user,
    this.messages,
  );

  @override
  _MessageBoxState createState() {
    return _MessageBoxState();
  }
}

class _MessageBoxState extends State<MessageBox> {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        // TODO: Need to look into expanding dynamically based on List<Message>
        // look into "..." seems like a expander operator/function
        children: [
          Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black, width: 0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            color: Colors.blue,     //widget.user[0].color
            margin: EdgeInsets.fromLTRB(100, 100, 0, 0),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text("message..."), //widget.messages[0].messageText
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black, width: 0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            color: Colors.blue,
            margin: EdgeInsets.fromLTRB(100, 0, 0, 0),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text("Second message is a bit longer..."),
            ),
          ),
          Text("name....time"),
        ],
      ),
    );
  }
}
