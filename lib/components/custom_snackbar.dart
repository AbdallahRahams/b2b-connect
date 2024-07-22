import 'package:flutter/material.dart';

import '../constants.dart';

class CustomSnackbar {
  CustomSnackbar();
  snackbarWithAction({
    required BuildContext context,
    required String text,
    required VoidCallback action,
    required String actionLabel,
  }) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: Theme.of(context).primaryColor,
        margin: EdgeInsets.all(p2),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          onPressed: action,
          label: actionLabel,
          textColor: Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
    );
  }
}
