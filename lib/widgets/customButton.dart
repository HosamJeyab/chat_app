import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Custombutton extends StatelessWidget {
  Custombutton({super.key, required this.buttonText,this.onTap});
  
  VoidCallback? onTap;
  String buttonText;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
