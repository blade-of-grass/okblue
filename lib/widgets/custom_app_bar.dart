import 'package:flutter/material.dart';
import 'package:okbluemer/configs.dart';

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
              child: Text(
                "1 active user",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
