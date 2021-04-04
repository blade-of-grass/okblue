import 'package:flutter/material.dart';
import 'package:okbluemer/configs.dart';
import 'package:okbluemer/blocs/communications_bloc.dart';

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: DecoratedBox(
        decoration: BoxDecoration(color: appBarColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.maybePop(context),
              color: Colors.white,
            ),
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.circle,
                    color: Colors.green,
                    size: 8,
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  StreamBuilder<int>(
                    stream: CommunicationBloc.of(context).connectionsStream,
                    initialData: 1,
                    builder: (context, connectionSnapshot) {
                      final count = connectionSnapshot.data;

                      return Text(
                        "$count active " + (count != 1 ? 'users' : 'user'),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
