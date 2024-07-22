import 'package:flutter/material.dart';

class NoInternetStatus extends StatelessWidget {
  const NoInternetStatus({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
      ),
      alignment: Alignment.center,
      color: Colors.grey.shade800,
      child: const Text(
        "No internet connection",
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }
}
