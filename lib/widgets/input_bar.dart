import 'package:flutter/material.dart';
import 'package:okbluemer/configs.dart';
import 'package:okbluemer/utils.dart';
import 'package:okbluemer/widgets/input_bar_button.dart';

class InputBar extends StatelessWidget {
  final void Function(Message message) onSubmit;
  final TextEditingController controller;

  InputBar({@required this.onSubmit, TextEditingController controller})
      : controller = controller ?? TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: appBarColor,
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
          Align(
            alignment: Alignment.topRight,
            child: Row(children: [
              /// GIF button
              InputBarButton(
                  color: Colors.pink,
                  onTap: () {},
                  isBorder: true,
                  child: Text(
                    "GIF",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )),

              /// submit button
              InputBarButton(
                  color: Colors.blue,
                  onTap: validateSubmission,
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                  )),
            ]),
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
      text: trimmedMessage,
      time: DateTime.now(),
    ));
  }
}
