import 'package:b2b_connect/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomToast {
  static success(String msg) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
      fontSize: 12,
      backgroundColor: cToastSuccess,
      timeInSecForIosWeb: 2,
    );
  }

  static error(String msg) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
      fontSize: 12,
      backgroundColor: cToastError,
      timeInSecForIosWeb: 2,
    );
  }

  static normal(String msg) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
      fontSize: 12,
      backgroundColor: cToastNetwork,
      timeInSecForIosWeb: 2,
    );
  }

  static primary(String msg) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
      fontSize: 12,
      backgroundColor: cToastDefault,
      timeInSecForIosWeb: 2,
    );
  }
}
