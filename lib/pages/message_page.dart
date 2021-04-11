import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:okbluemer/blocs/communications_bloc.dart';
import 'package:okbluemer/blocs/message_bloc.dart';
import 'package:okbluemer/comms/comms_utils.dart';
import 'package:okbluemer/utils.dart';
import 'package:okbluemer/widgets/custom_app_bar.dart';
import 'package:okbluemer/widgets/frosted_glass.dart';
import 'package:okbluemer/widgets/input_bar.dart';
import 'package:okbluemer/widgets/message_list.dart';

class MessagePage extends StatefulWidget {
  final UserInfo user;

  MessagePage({@required this.user});

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final scrollController = ScrollController();
  CommunicationBlocState bt;

  @override
  void initState() {
    super.initState();

    bt = CommunicationBloc.of(context);
    bt.subscribe(CommunicationEvent.onMessageReceived, onMessageReceived);
  }

  @override
  void dispose() {
    bt.unsubscribe(CommunicationEvent.onMessageReceived, onMessageReceived);

    super.dispose();
  }

  onMessageReceived(dynamic payload) {
    final packet = Packet.deserialize(payload);
    MessageBloc.of(context).addMessage(packet);
  }

  @override
  Widget build(BuildContext context) {
    // final addMessage = MessageBloc.of(context).addMessage;
    // getFillerTestMessages(this.user, addMessage, messages: 300, users: 20);

    return WillPopScope(
      onWillPop: () async {
        // TODO: show a verification dialog before disconnecting the user
        // TODO: add an on-screen button that can also trigger a Navigator.pop event
        MessageBloc.of(context).clear();
        return true;
      },
      child: Scaffold(
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            // message list & input field
            Column(children: [
              Expanded(
                child: MessageList(
                  user: this.widget.user,
                  scrollController: scrollController,
                ),
              ),
              // input field
              InputBar(
                onSubmit: (message) => onClickSendMessage(context, message),
              ),
            ]),
            // header
            FrostedGlass(
              child: SafeArea(
                top: true,
                child: CustomAppBar(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onClickSendMessage(BuildContext context, Message message) {
    Packet packet = Packet(message: message, user: this.widget.user);
    MessageBloc.of(context).addMessage(packet);
    bt.sendMessage(packet.serialize());

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
