import 'package:b2b_connect/components/custom_button.dart';
import 'package:b2b_connect/components/custom_dialog.dart';
import 'package:b2b_connect/constants.dart';
import 'package:b2b_connect/icon_fonts/icon_pack_outline_icons.dart';
import 'package:b2b_connect/models/reset_password_new_password_details.dart';
import 'package:b2b_connect/models/response.dart';
import 'package:b2b_connect/models/set_new_password_arguments.dart';
import 'package:b2b_connect/providers/authentication_provider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:b2b_connect/components/text_description.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'login.dart';

class SetNewPassword extends StatefulWidget {
  static const String route = '/setNewPassword';
  final SetNewPasswordArguments arguments;
  const SetNewPassword({Key? key, required this.arguments}) : super(key: key);

  @override
  _SetNewPasswordState createState() => _SetNewPasswordState();
}

class _SetNewPasswordState extends State<SetNewPassword> {
  CustomMaterialButton materialButton = CustomMaterialButton();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  GlobalKey setNewPasswordFormKey = GlobalKey<FormState>();

  /// Password and confirm password
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();

  FocusNode _passwordFN = FocusNode();
  FocusNode _confirmPasswordFN = FocusNode();
  final _passwordFieldKey = GlobalKey<FormFieldState>();
  final _confirmPasswordFieldKey = GlobalKey<FormFieldState>();
  bool _passwordV = true;
  bool _confirmPasswordV = true;
  CustomLoadingStateDialog loadingDialog = CustomLoadingStateDialog();
  bool _submitting = false;
  _submit() async {
    /// Check connectivity
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.cancel();
      return Fluttertoast.showToast(
        msg: "No internet connection",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        fontSize: 12,
        backgroundColor: cToastNetwork,
        timeInSecForIosWeb: 2,
      );
    }
    setState(() {
      _submitting = true;
    });

    /// Show loading dialog
    loadingDialog.createDialog(context);
    ResetPasswordNewPasswordDetails resetPasswordNewPasswordDetails =
        ResetPasswordNewPasswordDetails(
      otp: widget.arguments.otp,
      password: _password.text,
      userID: widget.arguments.userID,
    );
    ResponseMessage responseMessage =
        await AuthenticationProvider().resetPasswordSetNewPassword(
      resetPasswordNewPasswordDetails: resetPasswordNewPasswordDetails,
    );

    /// Close loading dialog
    Navigator.of(context, rootNavigator: true).pop();
    print(responseMessage.error);
    print(responseMessage.message);
    if (responseMessage.error == false) {
      /// Success

      Fluttertoast.showToast(
        msg: "Set successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        fontSize: 12,
        backgroundColor: cToastSuccess,
        timeInSecForIosWeb: 2,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PasswordSetSuccessful(),
        ),
      );
    } else {
      Fluttertoast.showToast(
        msg: responseMessage.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        fontSize: 12,
        backgroundColor: cToastNetwork,
        timeInSecForIosWeb: 2,
      );
    }

    setState(() {
      _submitting = false;
    });
  }

  @override
  void dispose() {
    _password.dispose();
    _confirmPassword.dispose();
    _passwordFN.dispose();
    _confirmPasswordFN.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Set new password'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: pagePadding,
            vertical: pagePadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextDescription(
                title: 'Create new password',
                description:
                    'Enter new password that you will be using for this account',
              ),
              Form(
                key: setNewPasswordFormKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: p4,
                    ),
                    TextFormField(
                      key: _passwordFieldKey,
                      controller: _password,
                      focusNode: _passwordFN,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.next,
                      obscureText: _passwordV,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Password is required";
                        }
                        if (value.length < 8) {
                          return "Password is too short";
                        }
                      },
                      decoration: InputDecoration(
                        labelText: "Password",
                        helperText: "At least 8 characters",
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              _passwordV = !_passwordV;
                            });
                          },
                          child: Icon(_passwordV
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: p5,
                    ),
                    TextFormField(
                      key: _confirmPasswordFieldKey,
                      controller: _confirmPassword,
                      focusNode: _confirmPasswordFN,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.go,
                      obscureText: _confirmPasswordV,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Password is required";
                        }
                        if (value.length < 8) {
                          return "Password is too short";
                        }
                        if (value != _password.text) {
                          return "Passwords do not match";
                        }
                      },
                      decoration: InputDecoration(
                        labelText: "Re-enter password",
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              _confirmPasswordV = !_confirmPasswordV;
                            });
                          },
                          child: Icon(_confirmPasswordV
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: p5,
                    ),
                    materialButton.createButton(
                      function: () {
                        if (!_passwordFieldKey.currentState!.validate()) {
                          _passwordFN.requestFocus();
                          return;
                        }
                        if (!_confirmPasswordFieldKey.currentState!
                            .validate()) {
                          _confirmPasswordFN.requestFocus();
                          return;
                        }
                        _submit();
                      },
                      label: 'Submit',
                      loadingLabel: 'Submitting ...',
                      loading: _submitting,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PasswordSetSuccessful extends StatelessWidget {
  PasswordSetSuccessful({Key? key}) : super(key: key);
  final CustomMaterialButton materialButton = CustomMaterialButton();
  final CustomOutlineButton outlineButton = CustomOutlineButton();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SizedBox(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(pagePadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  child: Icon(
                    IconPackOutline.lock,
                    size: 64,
                    color: cText2,
                  ),
                ),
                const SizedBox(height: p3),
                Text(
                  "New password is set successfully",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: p1),
                Text(
                  "You can now use it to login",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: p5),
                materialButton.createButtonSmall(
                  function: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, Login.route, (route) => false);
                  },
                  label: "Go to Login",
                  loadingLabel: "label",
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
