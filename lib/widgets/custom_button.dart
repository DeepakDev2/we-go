import 'package:flutter/material.dart';
import 'package:we_go/global/global_variable.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.onClick, required this.text});

  final void Function() onClick;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: GlobalVariable.buttonColor,
        ),
        onPressed: onClick,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
