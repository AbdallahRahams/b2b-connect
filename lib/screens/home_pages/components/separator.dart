import 'package:flutter/material.dart';
import '../../../constants.dart';

class Separator extends StatelessWidget {
  const Separator({
    Key? key,
    this.vPadding = 0,
  }) : super(key: key);
  final double vPadding;

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: 0.5,
      color: divider2,
      height: vPadding,
    );
  }
}
