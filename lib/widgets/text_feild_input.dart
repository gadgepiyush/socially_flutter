import 'package:flutter/material.dart';

class TextFeildInput extends StatelessWidget {

  final TextEditingController textEditingController;
  final bool isPassWord;
  final String hintText;
  final TextInputType textInputType;

  const TextFeildInput({Key? key,
          required this.textEditingController,
          this.isPassWord = false,
          required this.hintText,
          required this.textInputType,
        }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        focusedBorder: OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        enabledBorder: OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        filled: true,
        contentPadding: const EdgeInsets.all(8)
      ),

      keyboardType: textInputType,
      obscureText: isPassWord,
    );
  }
}