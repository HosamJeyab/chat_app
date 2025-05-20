import 'package:flutter/material.dart';
import 'package:RESALATY/constants.dart';
import 'package:RESALATY/models/messageModel.dart';
//mychat
class chatBuble extends StatelessWidget {
  chatBuble({super.key, required this.message});
  final Message message;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.only(left: 20, bottom: 20, right: 20, top: 20),
        margin: EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
        ),
        child: Text(message.message, style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
//another chat
class chatBubleForFriend extends StatelessWidget {
  chatBubleForFriend({super.key, required this.message});
  final Message message;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.only(left: 20, bottom: 20, right: 20, top: 20),
        margin: EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: kFriendColorChat,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
            bottomLeft: Radius.circular(32),
          ),
        ),
        child: Text(message.message, style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
