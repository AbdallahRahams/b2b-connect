import 'package:b2b_connect/components/custom_button.dart';
import 'package:b2b_connect/components/custom_dialog.dart';
import 'package:b2b_connect/models/change_password_details.dart';
import 'package:b2b_connect/models/response.dart';
import 'package:b2b_connect/providers/authentication_provider.dart';
import 'package:b2b_connect/utils/validators.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../constants.dart';

class ChangePassword extends StatefulWidget {
  static const String route = '/ChangePassword';

  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  var _formKey = GlobalKey<FormState>();

  CustomMaterialButton materialButton = CustomMaterialButton();
  CustomLoadingStateDialog loadingDialog = CustomLoadingStateDialog();

  /// Password and confirm password
  TextEditingController _password = TextEditingController();
  TextEditingController _oldPassword = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();
  FocusNode _passwordFN = FocusNode();
  FocusNode _oldPasswordFN = FocusNode();
  FocusNode _confirmPasswordFN = FocusNode();
  final _oldPasswordFieldKey = GlobalKey<FormFieldState>();
  final _passwordFieldKey = GlobalKey<FormFieldState>();
  final _confirmPasswordFieldKey = GlobalKey<FormFieldState>();
  bool _oldPasswordV = true;
  bool _passwordV = true;
  bool _confirmPasswordV = true;
  bool _setting = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _submit({required ChangePasswordDetails changePasswordDetails}) async {
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

    /// Show loading dialog
    setState(() {
      _setting = true;
    });
    loadingDialog.createDialog(context);
    ResponseMessage responseMessage;

    responseMessage = await AuthenticationProvider()
        .changePassword(changePasswordDetails: changePasswordDetails);

    /// Close loading dialog
    Navigator.of(context, rootNavigator: true).pop();
    setState(() {
      _setting = false;
    });

    ///
    if (responseMessage.error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
            title: "Failed",
            content: Text(responseMessage.message),
          );
        },
      );
    } else {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: "Password changed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        fontSize: 12,
        backgroundColor: cToastSuccess,
        timeInSecForIosWeb: 2,
      );
      Navigator.of(context).pop(false);
    }
  }

  @override
  void dispose() {
    /// Dispose FocusNodes
    _oldPasswordFN.dispose();
    _passwordFN.dispose();
    _confirmPasswordFN.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Change password"),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: pagePadding,
            vertical: pagePadding,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: p4,
                ),
                TextFormField(
                  key: _oldPasswordFieldKey,
                  controller: _oldPassword,
                  focusNode: _oldPasswordFN,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.next,
                  obscureText: _oldPasswordV,
                  validator: (value) => Validators.validateInputWithCustomErrorMessage(
                      value!, "Old password is required"),
                  decoration: InputDecoration(
                    labelText: "Old password",
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          _oldPasswordV = !_oldPasswordV;
                        });
                      },
                      child: Icon(_oldPasswordV
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded),
                    ),
                  ),
                ),
                const SizedBox(
                  height: p5,
                ),
                TextFormField(
                  key: _passwordFieldKey,
                  controller: _password,
                  focusNode: _passwordFN,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.next,
                  obscureText: _passwordV,
                  validator: (value) =>
                      Validators.validateSignupPassword(value!),
                  decoration: InputDecoration(
                    labelText: "New password",
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
                  validator: (value) => Validators.validateConfirmPassword(
                      value!, _password.text),
                  decoration: InputDecoration(
                    labelText: "Re-enter new password",
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
                    if (_formKey.currentState!.validate()) {
                      ChangePasswordDetails changePasswordDetails =
                          ChangePasswordDetails(
                        oldPassword: _oldPassword.text,
                        newPasswordConfirm: _password.text,
                        newPassword: _confirmPassword.text,
                      );
                      print(changePasswordDetails);
                      _submit(changePasswordDetails: changePasswordDetails);
                    }
                  },
                  label: "Set new password",
                  loadingLabel: "Setting ...",
                  loading: _setting,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
