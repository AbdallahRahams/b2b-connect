import 'package:b2b_connect/components/custom_button.dart';
import 'package:b2b_connect/components/custom_dialog.dart';
import 'package:b2b_connect/components/custom_toast.dart';
import 'package:b2b_connect/constants.dart';
import 'package:b2b_connect/models/response.dart';
import 'package:b2b_connect/models/social_authenticate_details.dart';
import 'package:b2b_connect/models/social_data.dart';
import 'package:b2b_connect/providers/authentication_provider.dart';
import 'package:b2b_connect/providers/google_sign_in_provider.dart';
import 'package:b2b_connect/screens/authentication/complete_details_social_register.dart';
import 'package:b2b_connect/screens/authentication/register.dart';
import 'package:b2b_connect/screens/authentication/verify_otp.dart';
import 'package:b2b_connect/screens/home_pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import '../authentication/login.dart';

class Welcome extends StatefulWidget {
  static const String route = '/welcome';

  const Welcome({Key? key}) : super(key: key);

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  CustomMaterialButton materialButton = CustomMaterialButton();
  CustomOutlineButton outlineButton = CustomOutlineButton();
  CustomLoadingStateDialog loadingDialog = CustomLoadingStateDialog();

  DateTime? currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (ModalRoute.of(context)?.canPop == true) return Future.value(true);

    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
        msg: "Press again to exit",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        fontSize: 12,
        backgroundColor: cText2,
        timeInSecForIosWeb: 2,
      );
      return Future.value(false);
    }
    return Future.value(true);
  }

  _continueWithGoogle() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
    loadingDialog.createDialog(context);

    ResponseMessage responseMessage = await provider.googleLogin();

    /// Close loading dialog
    Navigator.of(context, rootNavigator: true).pop();

    if (responseMessage.error == false &&
        responseMessage.message.toLowerCase() == "success") {
      /// Auto authentication with Google
      loadingDialog.createDialog(context);

      ResponseMessage responseMessage = await AuthenticationProvider().socialAuthenticate(
        socialAuthenticateDetails: SocialAuthenticateDetails(
          email: provider.user.email!,
          uid: provider.user.uid,
        ),
      );

      /// Close loading dialog
      Navigator.of(context, rootNavigator: true).pop();
      CustomToast.success(responseMessage.message);

      ///
      if (responseMessage.error) {
        provider.googleLogout();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog(
              title: "Authentication failed",
              content: Text(responseMessage.message),
            );
          },
        );
      } else {
        if (preferences.getBool("is_valid_number") == true) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(Home.route, (_) => false);
          return true;
        } else {
          /// Verify phone number
          String phone = preferences.getString("phone")!;
          AuthenticationProvider().resendOTPCode(phone: phone);
          Navigator.of(context).pushNamed(VerifyOTP.route);
          return true;
        }
      }
    }

    /// Redirect to Complete details after Google
    else if (responseMessage.error == false &&
        responseMessage.unauthorized == false) {
      final List<String> names = provider.user.displayName!.split(" ");
      final firstname = names.first;
      var middlename = "---";
      if (names.length > 2) {
        middlename = names[1];
      }
      final lastname = names.last;

      /// Navigate to complete registration form page and pass SocialDataRegistration as Arguments
      Navigator.of(context).pushNamed(
        CompleteDetailsSocialRegister.route,
        arguments: SocialDataRegistration(
          firstName: firstname,
          middleName: middlename,
          lastName: lastname,
          email: provider.user.email!,
          uid: provider.user.uid,
          type: "GOOGLE",
        ),
      );
    } else {
      /// Failed to Continue with Google
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: SizedBox(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Welcome to $appName" ,style: TextStyle(color: Colors.white),),
          iconTheme: IconThemeData(color: Colors.white), //
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: pagePadding,
              vertical: pagePadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: p4,
                ),
                Center(
                  child: Image.asset(
                    "assets/images/logo.png",
                    fit: BoxFit.cover,
                    height: 80,
                    color: divider2,
                  ),
                ),
                const SizedBox(
                  height: p5,
                ),
                Text(
                  "Get started by Creating an account if you don't have $appName account or Sign in if you already have account",
                  // textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!,
                ),
                const SizedBox(
                  height: p5,
                ),
                materialButton.createButton(
                  function: () {
                    Navigator.of(context).pushNamed(Register.route);
                  },
                  label: "Create an account",
                  loadingLabel: "loadingLabel",
                ),
                const SizedBox(
                  height: p3,
                ),
                Container(
                  width: double.infinity,
                  child: outlineButton.createButton(
                    function: () {
                      Navigator.of(context).pushNamed(Login.route);
                    },
                    label: "Sign in",
                    loadingLabel: "",
                  ),
                ),
                const SizedBox(
                  height: p5,
                ),
                Platform.isAndroid ? or(context) : const SizedBox(),
                Platform.isAndroid
                    ? const SizedBox(
                        height: p5,
                      )
                    : const SizedBox(),
                Platform.isAndroid
                    ? Container(
                        width: double.infinity,
                        child: outlineButton.createButtonWithIcon(
                          function: _continueWithGoogle,
                          child: SvgPicture.asset(
                            "assets/images/google.svg",
                            height: 30,
                          ),
                          label: "Continue with Google",
                          loadingLabel: "Create...",
                        ),
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: p3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row or(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Divider(
            thickness: 0.5,
            height: 0,
            color: divider2,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: p2),
          child: Text(
            "OR",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(height: 1),
          ),
        ),
        Expanded(
          child: Divider(
            thickness: 0.5,
            height: 0,
            color: divider2,
          ),
        ),
      ],
    );
  }
}
