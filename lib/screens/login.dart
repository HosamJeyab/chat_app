import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:RESALATY/constants.dart';
import 'package:RESALATY/screens/chatpage.dart';
import 'package:RESALATY/screens/homepage.dart';
import 'package:RESALATY/helper/ShowSnackBar.dart';
import 'package:RESALATY/screens/regester.dart';
import 'package:RESALATY/widgets/customFormTextField.dart';
import 'package:RESALATY/widgets/customButton.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});
  static String id = "LoginPage";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isloading = false;
  String? email, password;

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
                      "Sign In",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
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
                  scure: true,
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
                        await loginUserUser();
                        showSnackBar(context, "LogIn successfully");
                        Navigator.pushReplacementNamed(
                          context,
                          HomePage.id,
                          arguments: email,
                        );
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          showSnackBar(
                            context,
                            'No user found for that email.',
                          );
                        } else if (e.code == 'wrong-password') {
                          showSnackBar(
                            context,
                            'Wrong password provided for that user.',
                          );
                        }
                      } catch (e) {
                        print(e);
                        showSnackBar(
                          context,
                          "something wrong, please try again later!",
                        );
                      }
                      isloading = false;
                      setState(() {});
                    }
                  },
                  buttonText: "Sign In",
                ),
                const SizedBox(height: 20),

                //Register
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, Register.id);
                      },
                      child: Text(
                        "  Register",
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

  Future<void> loginUserUser() async {
    UserCredential user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
  }
}
