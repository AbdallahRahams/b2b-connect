import 'package:flutter/material.dart';

class TermsAndConditions extends StatefulWidget {
  static const String route = '/termsAndConditions';
  const TermsAndConditions({Key? key}) : super(key: key);

  @override
  _TermsAndConditionsState createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Terms and conditions", style: TextStyle(color: Colors.white),),
          iconTheme: IconThemeData(color: Colors.white), // ),
        ),
        body: Center(
          child: const Text("Terms and conditions"),
        ),
      ),
    );
  }
}
