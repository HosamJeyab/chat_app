import 'package:flutter/material.dart';
import 'package:my_chat/constants.dart';
import 'package:my_chat/models/messageModel.dart';
import 'package:my_chat/widgets/customChatBuble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatefulWidget {
  static String id = 'ChatPage';

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController controller = TextEditingController();
  final ScrollController _controller = ScrollController();

  CollectionReference messages = FirebaseFirestore.instance.collection(
    kMessagesCollection,
  );

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final currentUserEmail = args['currentUserEmail'];
    final friendEmail = args['friendEmail'];

    return StreamBuilder<QuerySnapshot>(
      //ordering message
      stream: messages.orderBy(kCreatedAt, descending: true).snapshots(),
      builder: (context, snapshot) {
        //check if there message
        if (snapshot.hasData) {
          //add message to list
          List<Message> messagesList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            final data = snapshot.data!.docs[i].data() as Map<String, dynamic>;
            if (data.containsKey('from') &&
                data.containsKey('to') &&
                data.containsKey(kmessage)) {
              final msg = Message.fromJeson(data);
              if ((msg.from == currentUserEmail && msg.to == friendEmail) ||
                  (msg.from == friendEmail && msg.to == currentUserEmail)) {
                messagesList.add(msg);
              }
            }
          }
          return Scaffold(
            //logo
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Image.asset(kLogo, height: 50), Text("RESALATY")],
              ),
              automaticallyImplyLeading: false,
              backgroundColor: kPrimaryColor,
            ),
            //body chatpage
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    controller: _controller,
                    itemCount: messagesList.length,
                    itemBuilder: (context, index) {
                      return messagesList[index].from == currentUserEmail
                          ? chatBuble(message: messagesList[index])
                          : chatBubleForFriend(message: messagesList[index]);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 5,
                    left: 10,
                    right: 10,
                    top: 5,
                  ),

                  //textdield to send message
                  child: TextField(
                    controller: controller,
                    onSubmitted: (data) {
                      messages.add({
                        kmessage: data,
                        kCreatedAt: DateTime.now(),
                        'from': currentUserEmail,
                        'to': friendEmail,
                      });

                      controller.clear();
                      _controller.animateTo(
                        0,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.fastOutSlowIn,
                      );
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: "Message",
                      suffixIcon: GestureDetector(
                        onTap: () {
                          final data = controller.text.trim();
                          if (data.isNotEmpty) {
                            messages.add({
                              kmessage: data,
                              kCreatedAt: DateTime.now(),
                              'from': currentUserEmail,
                              'to': friendEmail,
                            });
                            controller.clear();
                            _controller.animateTo(
                              0,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.fastOutSlowIn,
                            );
                            setState(() {});
                          }
                        },
                        child: Icon(Icons.send, color: kPrimaryColor),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: kPrimaryColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),

                        borderSide: BorderSide(color: kPrimaryColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator(color: kFriendColorChat,));
        }
      },
    );
  }
}
