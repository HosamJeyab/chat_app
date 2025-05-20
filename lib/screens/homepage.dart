import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_chat/constants.dart';
import 'package:my_chat/helper/ShowSnackBar.dart';
import 'package:my_chat/models/chatUsersModel.dart';
import 'package:my_chat/screens/chatpage.dart';
import 'package:my_chat/screens/login.dart';
import 'package:my_chat/widgets/customChatHistory.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});
  static String id = 'HomePage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ChatUser> chatUsers = [];
  String? currentUserEmail;

  @override
  void initState() {
    super.initState();
    fetchChatUsers();
  }

  Future<void> fetchChatUsers() async {
    currentUserEmail = FirebaseAuth.instance.currentUser?.email;
    if (currentUserEmail == null) {
      return;
    }

    final snapshot =
        await FirebaseFirestore.instance
            .collection('messages')
            .where('from', isEqualTo: currentUserEmail)
            .get();
    final snapshot2 =
        await FirebaseFirestore.instance
            .collection('messages')
            .where('to', isEqualTo: currentUserEmail)
            .get();

    Set<String> userEmails = {};

    for (var doc in snapshot.docs) {
      userEmails.add(doc['to']);
    }
    for (var doc in snapshot2.docs) {
      userEmails.add(doc['from']);
    }

    List<ChatUser> users = [];

    for (String email in userEmails) {
      var userSnapshot =
          await FirebaseFirestore.instance
              .collection('user')
              .where('email', isEqualTo: email)
              .get();

      if (userSnapshot.docs.isNotEmpty) {
        users.add(
          ChatUser(email: email, username: userSnapshot.docs.first['username']),
        );
      }
    }
    setState(() {
      chatUsers = users;
    });
  }

DateTime? lastBackPressTime;
  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments;
    return WillPopScope(
    onWillPop: () async {
      DateTime now = DateTime.now();
      if (lastBackPressTime == null ||
          now.difference(lastBackPressTime!) > Duration(seconds: 2)) {
        lastBackPressTime = now;
        showSnackBar(context, "Press again to exit");
        return false;
      }
      return true;
    },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(kLogo, height: 50), Text("RESALATY")],
          ),
          backgroundColor: kPrimaryColor,
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: Text("Sign Out"),
                        content: Text("Are you suru Sign out?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text("No",style: TextStyle(color: kPrimaryColor,fontWeight: FontWeight.bold),),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await FirebaseAuth.instance.signOut();
                              Navigator.of(
                                context,
                              ).pushReplacementNamed(LoginPage.id);
                            },
                            child: Text("Yes",style: TextStyle(color: kPrimaryColor,fontWeight: FontWeight.bold),),
                          ),
                        ],
                      ),
                );
              },
              icon: Icon(Icons.login, color: kFriendColorChat),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              //SEARCH FOR USER
              TextField(
                onSubmitted: (data) async {
                  try {
                    var result =
                        await FirebaseFirestore.instance
                            .collection('user')
                            .where('username', isEqualTo: data)
                            .get();
      
                    if (result.docs.isNotEmpty) {
                      currentUserEmail =
                          FirebaseAuth.instance.currentUser!.email!;
                      String friendEmail = result.docs.first['email'];
      
                      Navigator.pushNamed(
                        context,
                        ChatPage.id,
                        arguments: {
                          'currentUserEmail': currentUserEmail,
                          'friendEmail': friendEmail,
                        },
                      );
                    } else {
                      showSnackBar(
                        context,
                        "There is no user with this username.",
                      );
                    }
                  } catch (e) {
                    showSnackBar(context, "Sorry... please try again later.");
                  }
                },
                decoration: InputDecoration(
                  hintText: "Search",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
      
              //frind chat
              ...chatUsers.map((user) {
                return ChatUserTile(
                  username: user.username,
                  email: user.email,
                  currentUserEmail: currentUserEmail,
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
