import 'package:flutter/material.dart';

class PasswordInput extends StatefulWidget {
  final TextEditingController? controller;
  final String placeholder;
  final FormFieldValidator<String>? validator;

  const PasswordInput(
      {Key? key, required this.placeholder, this.controller, this.validator})
      : super(key: key);

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        autofocus: true,
        controller: widget.controller,
        obscureText: _isObscure,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
            border:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
            suffixIcon: IconButton(
              icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                });
              },
            ),
            // contentPadding: EdgeInsets.only(
            //     left: 15, bottom: 1, top: 11, right: 15),
            hintText: widget.placeholder),
        validator: widget.validator
        //     (value) {
        //   widget.validator!();
        //   // if (value!.isEmpty) {
        //   //   return "its empty";
        //   // }
        //   // return null;
        // },
        );
  }
}
