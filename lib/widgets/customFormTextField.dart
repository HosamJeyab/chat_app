import 'package:flutter/material.dart';

class CustomFormTextfield extends StatelessWidget {
  CustomFormTextfield({super.key, this.hintText, this.onChanged, this.scure = false});
  String? hintText;
  bool? scure;
  Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: scure!,
      validator: (data){
        if(data!.isEmpty){
          return 'field is requierd';
        }
      },
      onChanged: onChanged,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white),

        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}
