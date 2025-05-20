import 'package:flutter/material.dart';
import 'package:RESALATY/constants.dart';
import 'package:RESALATY/screens/chatpage.dart';

class ChatUserTile extends StatelessWidget {
  final String username;
  final String email;
  final String? currentUserEmail;

  const ChatUserTile({
    super.key,
    required this.username,
    required this.email,
    required this.currentUserEmail,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          ChatPage.id,
          arguments: {
            'currentUserEmail': currentUserEmail,
            'friendEmail': email,
          },
        );
      },
      child: Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          username,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
