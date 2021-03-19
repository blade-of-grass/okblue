
import 'package:flutter/material.dart';
import 'package:okbluemer/blocs/message_bloc.dart';
import 'package:okbluemer/utils.dart';
import 'package:okbluemer/widgets/message_box.dart';

class MessageList extends StatelessWidget {

  final ScrollController scrollController;

  final UserInfo user;

  MessageList({@required this.user, this.scrollController});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MessageGroup>>(
      stream: MessageBloc.of(context).stream,
      initialData: MessageBloc.of(context).currentMessages,
      builder: (context, messageSnapshot) {
        final messages = messageSnapshot.hasData ? messageSnapshot.data : [];

        return ListView.builder(
          reverse: true,
          controller: scrollController,
          physics: BouncingScrollPhysics(),
          itemCount: messages.length,
          itemBuilder: (BuildContext context, int index) {
            //final user = messages[index].user;
            final messageBlock = messages[messages.length - 1 - index];
            final user = messageBlock.user;
            CrossAxisAlignment alignment;
            if (user.name == this.user.name) {
              alignment = CrossAxisAlignment.end;
            } else {
              alignment = CrossAxisAlignment.start;
            }

            return MessageBox(
              messageBlock: messageBlock,
              alignment: alignment,
            );
          },
        );
      }
    );
  }
}