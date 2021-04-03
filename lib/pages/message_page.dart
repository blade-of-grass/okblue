import 'package:flutter/material.dart';
import 'package:okbluemer/blocs/communications_bloc.dart';
import 'package:okbluemer/blocs/message_bloc.dart';
import 'package:okbluemer/comms/comms_utils.dart';
import 'package:okbluemer/utils.dart';
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

    this.bt = CommunicationBloc.of(context);
    this.bt.subscribe(CommunicationEvent.onMessageReceived, onMessageReceived);
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
        this.bt.disconnect();
        MessageBloc.of(context).clear();
        return true;
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: MessageList(
                user: this.widget.user,
                scrollController: scrollController,
              ),
            ),
            InputBar(
              onSubmit: (message) => onClickSendMessage(context, message),
            ),
          ],
        ),
      ),
    );
  }

  void onClickSendMessage(BuildContext context, Message message) {
    Packet packet = Packet(message: message, user: this.widget.user);
    MessageBloc.of(context).addMessage(packet);
    bt.sendMessage(packet);

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
