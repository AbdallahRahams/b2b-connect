
import 'package:b2b_connect/components/custom_button.dart';
import 'package:b2b_connect/components/custom_dialog.dart';
import 'package:b2b_connect/constants.dart';
import 'package:b2b_connect/models/response.dart';
import 'package:b2b_connect/models/set_new_password_arguments.dart';
import 'package:b2b_connect/models/verify_reset_password_otp.dart';
import 'package:b2b_connect/providers/authentication_provider.dart';
import 'package:b2b_connect/screens/authentication/reset_password_new_password.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';

class ResetPasswordOTP extends StatefulWidget {
  static const String route = '/resetPasswordOTP';

  const ResetPasswordOTP({Key? key}) : super(key: key);

  @override
  State<ResetPasswordOTP> createState() => _ResetPasswordOTPState();
}

class _ResetPasswordOTPState extends State<ResetPasswordOTP> {
  // late Timer _timer;
  TextEditingController _controller = TextEditingController();
  String _code = "";
  String appSignature = "{{ app signature }}";
  String phone = "";
  int userID = 0;
  CustomMaterialButton materialButton = CustomMaterialButton();
  CustomTextButton textButton = CustomTextButton();
  CustomLoadingStateDialog loadingDialog = CustomLoadingStateDialog();
  ValueNotifier<String> _waitingTime = ValueNotifier("");

  bool _verifying = false;
  bool _resending = false;
  bool _canResend = false;
  @override
  void initState() {
    _getUserDetails();
    SmsAutoFill().listenForCode();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      SmsAutoFill().getAppSignature.then((signature) {
        setState(() {
          signature = signature;
        });
      });
    });
    super.initState();
  }

  _getUserDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    phone = preferences.getString("phone")!;
    userID = preferences.getInt("user_id")!;
    if (phone == "" || userID == 0) {
      /// todo
      /// phone number is not available
      return;
    }
    setState(() {});
  }

  _verify() async {
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
      _verifying = true;
    });
    VerifyResetPasswordOTPDetails verifyResetPasswordOTPDetails =
        VerifyResetPasswordOTPDetails(
      otp: _controller.text,
      phone: phone,
      userID: userID,
    );

    /// Show loading dialog
    loadingDialog.createDialog(context);
    ResponseMessage responseMessage;

    responseMessage = await AuthenticationProvider().verifyResetPasswordOTPCode(
        verifyResetPasswordOTPDetails: verifyResetPasswordOTPDetails);

    /// Close loading dialog
    Navigator.of(context, rootNavigator: true).pop();
    if (responseMessage.error == false) {
      Navigator.of(context).pop();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SetNewPassword(
            arguments: SetNewPasswordArguments(
              otp: verifyResetPasswordOTPDetails.otp,
              userID: verifyResetPasswordOTPDetails.userID,
            ),
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
            title: "Verification failed",
            content: Text(responseMessage.message),
          );
        },
      );
    }
    setState(() {
      _verifying = false;
    });
  }

  // void _resendOTPTimer() {
  //   int _start = 300;
  //   String minutes = "";
  //   String seconds = "";
  //   setState(() {
  //     _canResend = false;
  //   });
  //   const oneSec = const Duration(seconds: 1);
  //   _timer = Timer.periodic(
  //     oneSec,
  //     (Timer timer) {
  //       if (!mounted) {
  //         return;
  //       }
  //       if (_start > 59) {
  //         minutes = (_start / 60).floor().toString();
  //         var s = _start % 60;
  //         if (s > 9) {
  //           seconds = s.toString();
  //         } else {
  //           seconds = ("0$s").toString();
  //         }
  //         _start--;
  //
  //         _waitingTime.value = "0$minutes:${seconds}s";
  //         _waitingTime.notifyListeners();
  //       } else {
  //         if (_start > 9) {
  //           seconds = _start.toString();
  //         } else {
  //           seconds = ("0$_start").toString();
  //         }
  //         _start--;
  //
  //         _waitingTime.value = "00:${seconds}s";
  //         _waitingTime.notifyListeners();
  //       }
  //       if (_start == 0) {
  //         _timer.cancel();
  //         timer.cancel();
  //         _waitingTime.value = "00:00s";
  //         _waitingTime.notifyListeners();
  //         setState(() {
  //           _canResend = true;
  //         });
  //         return;
  //       }
  //     },
  //   );
  // }

  @override
  void dispose() {
    _controller.dispose();
    // _timer.cancel();
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Consumer(
        builder: (BuildContext context, auth, Widget? child) {
          return SizedBox(
            child: Scaffold(
              appBar: AppBar(
                title: const Text("Reset password verify OTP"),
                centerTitle: true,
                automaticallyImplyLeading: false,
              ),
              body: SingleChildScrollView(
                child: Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: p5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: p4,
                        ),
                        child: phone == ""
                            ? const SizedBox()
                            : RichText(
                                textAlign: TextAlign.center,
                                textScaleFactor:
                                    MediaQuery.textScaleFactorOf(context),
                                text: TextSpan(
                                  text:
                                      "Enter the OTP code we sent to your phone number: ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: cText2),
                                  children: [
                                    TextSpan(
                                      text: "+$phone",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: cText2,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    TextSpan(
                                      text: " and verify",
                                    ),
                                  ],
                                ),
                              ),
                      ),
                      const SizedBox(
                        height: p5,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: p5,
                          horizontal: p4,
                        ),
                        child: PinFieldAutoFill(
                          controller: _controller,
                          currentCode: _code,
                          decoration: UnderlineDecoration(
                            textStyle: TextStyle(
                              fontSize: 28,
                              color: cText1,
                              height: 0,
                            ),
                            colorBuilder: PinListenColorBuilder(
                              cText1.withOpacity(0.2),
                              cPrimary.withOpacity(0.6),
                            ),
                            errorText: true ? null : "fdff",
                            gapSpace: p4,
                            lineHeight: 2,
                          ),
                          codeLength: 4,
                          onCodeSubmitted: (code) {
                            print(code.length);
                          },
                          onCodeChanged: (code) {
                            _code = _controller.text;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: p4,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: pagePadding,
                        ),
                        child: materialButton.createButton(
                          function: () {
                            if (_controller.text == "" ||
                                _controller.text.length != 4) {
                            } else {
                              _verify();
                            }
                          },
                          label: "Verify OTP",
                          loadingLabel: "Verifying ...",
                          loading: _verifying,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
