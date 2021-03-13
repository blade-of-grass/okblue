import 'package:flutter/material.dart';
import 'package:okbluemer/message_box.dart';
import 'package:okbluemer/utils.dart';

class MessagePage extends StatefulWidget {
  final UserInfo user;

  MessagePage({@required this.user});

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    final List<UserInfo> users = [
      UserInfo(name: "nuha", onlineStatus: "online", userId: UUID()),
      UserInfo(name: "anthony", onlineStatus: "online", userId: UUID()),
      UserInfo(name: "mark", onlineStatus: "online", userId: UUID()),
    ];

    final List<MessageBlock> messages = [
      MessageBlock(
        messages: [
          Message(messageText: "hello there", time: DateTime.now()),
          Message(messageText: "is anyone out there", time: DateTime.now()),
          Message(messageText: "goodbye then", time: DateTime.now()),
        ],
        user: users[1],
      ),
      MessageBlock(
        messages: [
          Message(messageText: "I'm here", time: DateTime.now()),
        ],
        user: users[0],
      ),
      MessageBlock(
        messages: [
          Message(messageText: "me too", time: DateTime.now()),
          Message(
              messageText: "do you all want to get some food?",
              time: DateTime.now()),
        ],
        user: users[2],
      ),
      MessageBlock(
        messages: [
          Message(messageText: "I'm not sure", time: DateTime.now()),
          Message(
              messageText:
                  "I'm now going to type a very long message to test how the message box reacts to receiving a very long string that is above and beyond the normal expected length for a message to be received I'm rambling now but that's ok I'm just trying to generate text or as much text as possible",
              time: DateTime.now()),
        ],
        user: this.widget.user,
      ),
      MessageBlock(
        messages: [
          Message(
              messageText: "ok that's weird I'm leaving", time: DateTime.now()),
        ],
        user: users[0],
      ),
      MessageBlock(
        messages: [
          Message(messageText: "goodbye", time: DateTime.now()),
        ],
        user: users[0],
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                final user = messages[index].user;
                CrossAxisAlignment alignment;
                if (user.name == this.widget.user.name) {
                  alignment = CrossAxisAlignment.end;
                } else {
                  alignment = CrossAxisAlignment.start;
                }

                return MessageBox(
                  messageBlock: messages[index],
                  alignment: alignment,
                );
                // var r = Random();
                // return Container(
                //   height: (r.nextInt(10) + 3) * 10.0,
                //   child: Text(
                //     "message",
                //     style: TextStyle(color: Colors.white),
                //   ),
                //   decoration: BoxDecoration(
                //     color: Colors.transparent,
                //     border: Border.all(color: Colors.yellow),
                //   ),
                // );
              },
            ),
          ),
          Container(
            color: Colors.black,
            padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    minLines: 1,
                    maxLines: 5,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: "Write message...",
                      hintStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Align(
                  alignment: Alignment.topRight,
                  child: ClipOval(
                    child: Material(
                      color: Colors.indigo,
                      child: InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.blue,
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Icon(
                            Icons.send,
                            size: 24.0,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {},
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
