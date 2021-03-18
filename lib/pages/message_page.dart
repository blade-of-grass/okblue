import 'package:flutter/material.dart';
import 'package:okbluemer/filler_test_data.dart';
import 'package:okbluemer/utils.dart';
import 'package:okbluemer/widgets/message_box.dart';

class MessagePage extends StatefulWidget {
  final UserInfo user;

  MessagePage({@required this.user});

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  final List<MessageBlock> messages = [];

  @override
  void initState() {
    super.initState();

    getFillerTestMessages(this.widget.user, addMessage, messages: 300, users: 20);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              controller: scrollController,
              physics: BouncingScrollPhysics(),
              itemCount: this.messages.length,
              itemBuilder: (BuildContext context, int index) {
                //final user = messages[index].user;
                final messageBlock = messages[messages.length - 1 - index];
                final user = messageBlock.user;
                CrossAxisAlignment alignment;
                if (user.name == this.widget.user.name) {
                  alignment = CrossAxisAlignment.end;
                } else {
                  alignment = CrossAxisAlignment.start;
                }

                return MessageBox(
                  messageBlock: messageBlock,
                  alignment: alignment,
                );
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
                    controller: this.messageController,
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
                        onTap: onClickSendMessage,
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

  void addMessage(Message message, UserInfo user) {
    if (this.messages.isNotEmpty) {
      final lastBlock = this.messages.last;
      // TODO: switch this to user id
      if (lastBlock.user == user) {
        lastBlock.messages.add(message);
        return;
      }
    }
    this.messages.add(MessageBlock.withMessage(message: message, user: user));
  }

  void onClickSendMessage() {
    // don't send null or empty messages
    final trimmedMessage = this.messageController.text.trim();
    if (trimmedMessage == null || trimmedMessage.isEmpty) {
      return;
    }

    final message = Message(
      messageText: trimmedMessage,
      time: DateTime.now(),
    );

    final user = this.widget.user;

    setState(() {
      this.addMessage(message, user);
    });
    this.messageController.text = "";

    // scroll to the end when scrolled too far up (backup)
    scrollController.jumpTo(0);
  
    //scrollController.jumpTo(scrollController.position.maxScrollExtent);

    // scrollController.animateTo(
    //   scrollController.position.maxScrollExtent,
    //   duration: Duration(milliseconds: 250),
    //   curve: Curves.fastOutSlowIn,
    // );
  }
}
