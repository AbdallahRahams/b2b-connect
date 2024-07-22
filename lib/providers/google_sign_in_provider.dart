import 'dart:convert';
import 'package:b2b_connect/components/custom_toast.dart';
import 'package:b2b_connect/models/response.dart';
import 'package:b2b_connect/models/verify_email_on_social_account.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final String type = "GOOGLE";
  late final googleSignIn = GoogleSignIn();
  User? _user;
  User get user => _user!;

  Future<ResponseMessage> googleLogin() async {
    var googleUser;
    try {
      googleUser = await googleSignIn.signIn();
    } catch (e) {
      CustomToast.error("Google Error: $e");
      return ResponseMessage(
        error: true,
        unauthorized: false,
        message: "Failed to login with Google account",
      );
    }

    if (googleUser == null)
      return ResponseMessage(
        error: true,
        unauthorized: false,
        message: "Failed to login with Google account",
      );

    ///
    /// Check if email exists on system
    ///
    final ResponseMessage response =
        await checkIfUserAlreadyInTheSystem(googleUser);

    /// Logout if not successful
    if (response.error == true) {
      notifyListeners();
      googleSignIn.signOut();
    }
    if (response.unauthorized == true) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: "${response.message}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        fontSize: 12,
        backgroundColor: cToastNetwork,
        timeInSecForIosWeb: 2,
      );
    }
    return response;
  }

  Future<ResponseMessage> checkIfUserAlreadyInTheSystem(
      GoogleSignInAccount googleUser) async {
    late ResponseMessage responseMessage;
    try {
      http.Response verifyEmailIfExistResponse;
      verifyEmailIfExistResponse = await http.post(
        Uri.parse('$baseURL/api/v1/verify/email'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          "email": googleUser.email,
        }),
      );

      print(verifyEmailIfExistResponse.body);
      if (verifyEmailIfExistResponse.statusCode == 200) {
        final Map<String, dynamic> responseData =
            json.decode(verifyEmailIfExistResponse.body);
        if (responseData.containsKey('ERROR') &&
            responseData.containsKey('MESSAGE')) {
          responseMessage = ResponseMessage(
            error: responseData['ERROR'],
            message: responseData['MESSAGE'],
            unauthorized: false,
          );
          if (responseMessage.error == false) {
            final googleAuth = await googleUser.authentication;
            final credential = GoogleAuthProvider.credential(
              accessToken: googleAuth.accessToken,
              idToken: googleAuth.idToken,
            );
            await FirebaseAuth.instance
                .signInWithCredential(credential)
                .then((value) => _user = value.user);
            notifyListeners();
            return ResponseMessage(
              error: false,
              unauthorized: false,
              message: "Successful logged in with Google account",
            );
          } else {
            return ResponseMessage(
              error: true,
              unauthorized: false,
              message: "Failed to verify Google email on the system",
            );
          }
        } else {
          return ResponseMessage(
            error: true,
            unauthorized: false,
            message: "Failed to verify Google email on the system",
          );
        }
      } else if (verifyEmailIfExistResponse.statusCode == 400) {
        final Map<String, dynamic> responseData =
            json.decode(verifyEmailIfExistResponse.body);
        if (responseData.containsKey("email")) {
          if (responseData["email"][0].toString().contains("already")) {
            /// Check if is used on Social, and try to login using email and uid from Firebase
            ResponseMessage response = await checkIfEmailIsUsedOnSocial(
              SocialEmailTypeUsed(email: googleUser.email, type: type),
            );
            Fluttertoast.cancel();
            Fluttertoast.showToast(
              msg: response.message,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.SNACKBAR,
              fontSize: 12,
              backgroundColor: cToastNetwork,
              timeInSecForIosWeb: 2,
            );

            /// Login if success
            if (response.error == false) {
              final googleAuth = await googleUser.authentication;
              final credential = GoogleAuthProvider.credential(
                accessToken: googleAuth.accessToken,
                idToken: googleAuth.idToken,
              );
              await FirebaseAuth.instance
                  .signInWithCredential(credential)
                  .then((value) => _user = value.user);
              notifyListeners();
              return ResponseMessage(
                error: false,
                unauthorized: false,
                message: response.message,
              );
            }
          }
        }

        return ResponseMessage(
          error: true,
          unauthorized: true,
          message: "Email is already used on the system",
        );
      } else {
        return ResponseMessage(
          error: true,
          unauthorized: false,
          message: "Failed to verify Google email",
        );
      }
    } catch (e) {
      return ResponseMessage(
        error: true,
        unauthorized: false,
        message: "Something went wrong",
      );
    }
  }

  Future<ResponseMessage> checkIfEmailIsUsedOnSocial(
      SocialEmailTypeUsed socialEmailTypeUsed) async {
    try {
      http.Response emailIsUsedOnSocialResponse = await http.post(
        Uri.parse('$baseURL/api/v1/verify/social/network/email'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          "email": socialEmailTypeUsed.email,
          "type": socialEmailTypeUsed.type,
        }),
      );

      if (emailIsUsedOnSocialResponse.statusCode == 200) {
        return ResponseMessage(
          error: false,
          unauthorized: false,
          message: "success",
        );
      } else if (emailIsUsedOnSocialResponse.statusCode == 400) {
        return ResponseMessage(
          error: true,
          unauthorized: false,
          message: "Invalid social network",
        );
      } else {
        return ResponseMessage(
          error: true,
          unauthorized: false,
          message: "Something went wrong",
        );
      }
    } catch (e) {
      return ResponseMessage(
        error: true,
        unauthorized: false,
        message: "Something went wrong",
      );
    }
  }

  Future googleLogout() async {
    await googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
    notifyListeners();
  }
}
