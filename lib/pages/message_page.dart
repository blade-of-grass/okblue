import 'package:flutter/material.dart';
import 'package:okbluemer/blocs/bluetooth_bloc.dart';
import 'package:okbluemer/blocs/message_bloc.dart';
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
  BluetoothBlocState bt;

  @override
  void initState() {
    super.initState();

    this.bt = BluetoothBloc.of(context);
    this.bt.subscribe(BluetoothEvent.onMessageReceived, onMessageReceived);
  }

  onMessageReceived(dynamic message) {
    MessageBloc.of(context)
        .addMessage(message as Message, UserInfo(name: "unknown"));
  }

  @override
  Widget build(BuildContext context) {
    // final addMessage = MessageBloc.of(context).addMessage;
    // getFillerTestMessages(this.user, addMessage, messages: 300, users: 20);

    return Scaffold(
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
    );
  }

  void onClickSendMessage(BuildContext context, Message message) {
    MessageBloc.of(context).addMessage(message, this.widget.user);
    bt.sendMessage(message);

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
