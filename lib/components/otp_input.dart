import 'package:b2b_connect/constants.dart';
import 'package:flutter/material.dart';

class OtpInput extends StatelessWidget {
  final bool autoFocus;
  final TextEditingController controller;

  const OtpInput({Key? key, required this.controller, required this.autoFocus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 50,
      child: TextField(
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        controller: controller,
        maxLength: 1,
        cursorColor: Theme.of(context).primaryColor,
        decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black26),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: cPrimary),
            ),
            border: UnderlineInputBorder(),
            counterText: '',
            hintStyle: TextStyle(color: Colors.red, fontSize: 20)),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}
