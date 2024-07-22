import 'package:b2b_connect/components/custom_button.dart';
import 'package:b2b_connect/components/custom_dialog.dart';
import 'package:b2b_connect/components/text_description.dart';
import 'package:b2b_connect/constants.dart';
import 'package:b2b_connect/models/response.dart';
import 'package:b2b_connect/providers/authentication_provider.dart';
import 'package:b2b_connect/screens/authentication/reset_password_otp.dart';
import 'package:b2b_connect/utils/validators.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResetPasswordWithNumber extends StatefulWidget {
  static const String route = '/resetPasswordWithNumber';

  const ResetPasswordWithNumber({Key? key}) : super(key: key);

  @override
  _ResetPasswordWithNumberState createState() =>
      _ResetPasswordWithNumberState();
}

class _ResetPasswordWithNumberState extends State<ResetPasswordWithNumber> {
  CustomMaterialButton materialButton = CustomMaterialButton();
  CustomLoadingStateDialog loadingDialog = CustomLoadingStateDialog();
  TextEditingController _controller = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  bool _sending = false;

  @override
  initState() {
    super.initState();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

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
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _sending = true;
    });

    /// Show loading dialog
    loadingDialog.createDialog(context);

    ResponseMessage responseMessage;
    responseMessage = await AuthenticationProvider()
        .generateForgetPasswordOTPCode(phone: "255${_controller.text}");

    /// Close loading dialog
    Navigator.of(context, rootNavigator: true).pop();

    print(responseMessage.error);
    print(responseMessage.message);
    if (responseMessage.error == false) {
      if (preferences.getInt("user_id") != null ||
          preferences.getInt("user_id") != 0) {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(
          ResetPasswordOTP.route,
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
            title: "Failed",
            content: Text(responseMessage.message),
          );
        },
      );
    }
    setState(() {
      _sending = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Reset password"),
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
                title: 'Enter your phone number',
                description:
                    "Enter phone number associated with your account and we will send a code to reset your password",
              ),
              const SizedBox(
                height: p4,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _controller,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.go,
                      maxLength: 9,
                      validator: (phone) =>
                          Validators.validatePhoneNumber(phone!),
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(
                            new RegExp(r"\s\b|\b\s")),
                        FilteringTextInputFormatter.digitsOnly,
                        FilteringTextInputFormatter.allow(
                          RegExp(r"^[1-9][0-9]*$"),
                        ),
                      ],
                      decoration: InputDecoration(
                        labelText: "Phone number",
                        suffixIcon: const Icon(Icons.phone_iphone),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: p3,
                        ),
                        prefixIcon: InkWell(
                          onTap: () {
                            // _showCountriesDialog(context);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: p3,
                                ),
                                child: Text("+255"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: p5,
                    ),
                    materialButton.createButton(
                      function: () {
                        _submit();
                      },
                      label: 'Send code',
                      loadingLabel: "Sending code ...",
                      loading: _sending,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
