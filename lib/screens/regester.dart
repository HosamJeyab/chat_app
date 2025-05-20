import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:RESALATY/constants.dart';
import 'package:RESALATY/helper/ShowSnackBar.dart';
import 'package:RESALATY/screens/chatpage.dart';
import 'package:RESALATY/screens/homepage.dart';
import 'package:RESALATY/widgets/customFormTextField.dart';
import 'package:RESALATY/widgets/customButton.dart';

class Register extends StatefulWidget {
  Register({super.key});
  static String id = "Register";

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String? email;
  String? username;
  String? password;

  bool isloading = false;

  GlobalKey<FormState> formkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isloading,

      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Form(
            key: formkey,
            child: ListView(
              children: [
                //LOGO
                Image.asset(kLogo, height: 200),
                Center(
                  child: Text(
                    "RESALATY",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 80),

                //UI
                Row(
                  children: [
                    Text(
                      "Register",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                //username text
                CustomFormTextfield(
                  onChanged: (data) {
                    username = data;
                  },
                  hintText: "username",
                ),
                const SizedBox(height: 20),
                //email text
                CustomFormTextfield(
                  onChanged: (data) {
                    email = data;
                  },
                  hintText: "email",
                ),
                const SizedBox(height: 20),
                //password text
                CustomFormTextfield(
                  onChanged: (data) {
                    password = data;
                  },
                  hintText: "password",
                ),
                const SizedBox(height: 20),

                //button login
                Custombutton(
                  onTap: () async {
                    if (formkey.currentState!.validate()) {
                      isloading = true;
                      setState(() {});
                      try {
                        await registerUser();
                        showSnackBar(context, "Register successfully");
                        Navigator.pushReplacementNamed(
                          context,
                          HomePage.id,
                          arguments: email,
                        );
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'week-password') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("week password")),
                          );
                        } else if (e.code == 'email-already-in-use') {
                          showSnackBar(context, "Email already used");
                        }
                      } catch (e) {
                        showSnackBar(
                          context,
                          "something wrong, please try again later!",
                        );
                      }
                      isloading = false;
                      setState(() {});
                    } else {}
                  },
                  buttonText: "Register",
                ),
                const SizedBox(height: 20),

                //Register
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "already have an account?",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "  Sign In",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 101, 171, 230),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> registerUser() async {
    UserCredential user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);
    await FirebaseFirestore.instance.collection('user').doc(email).set({
      'username': username,
      'email': email,
      'createdAt': DateTime.now(),
    });
  }
}
