import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_chat/firebase_options.dart';
import 'package:my_chat/screens/chatpage.dart';
import 'package:my_chat/screens/homepage.dart';
import 'package:my_chat/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_chat/screens/regester.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(resalaty());
}

class resalaty extends StatelessWidget {
  const resalaty({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: FirebaseAuth.instance.currentUser ==null? LoginPage.id:HomePage.id,
      routes: {
        Register.id: (context) => Register(),
        LoginPage.id: (context) => LoginPage(),
        ChatPage.id: (context) => ChatPage(),
        HomePage.id:(context)=>HomePage(),
      },
    );
  }
}
