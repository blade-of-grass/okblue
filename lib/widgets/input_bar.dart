import 'package:flutter/material.dart';
import 'package:okbluemer/utils.dart';

class InputBar extends StatelessWidget {

  final void Function(Message message) onSubmit;
  final TextEditingController controller;

  InputBar({@required this.onSubmit, TextEditingController controller})
    : controller = controller ?? TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
            color: Colors.black,
            padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: this.controller,
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
                        onTap: validateSubmission,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  validateSubmission() {
    
    // trim whitespace on either side of message content, so users can't send large blocks of emptiness
    final trimmedMessage = this.controller.text.trim();

    // don't send null or empty messages
    if (trimmedMessage == null || trimmedMessage.isEmpty) {
      return;
    }

    // clear the input field
    this.controller.text = "";

    this.onSubmit(Message(
      messageText: trimmedMessage,
      time: DateTime.now(),
    ));
  }
}