import 'dart:async';
import 'package:b2b_connect/components/custom_button.dart';
import 'package:b2b_connect/components/custom_dialog.dart';
import 'package:b2b_connect/models/response.dart';
import 'package:b2b_connect/models/verify_phone_details.dart';
import 'package:b2b_connect/providers/authentication_provider.dart';
import 'package:b2b_connect/providers/user_details.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../constants.dart';
import '../home_pages/home.dart';

class VerifyOTP extends StatefulWidget {
  static const String route = '/verifyOTP';

  const VerifyOTP({Key? key}) : super(key: key);

  @override
  _VerifyOTPState createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  late Timer _timer;
  ValueNotifier<String> _waitingTime = ValueNotifier("");
  TextEditingController _textEditingController = TextEditingController();
  String _code = "";
  String appSignature = "{{ app signature }}";
  String phone = "";
  CustomMaterialButton materialButton = CustomMaterialButton();
  CustomTextButton textButton = CustomTextButton();
  CustomLoadingStateDialog loadingDialog = CustomLoadingStateDialog();
  bool _verifying = false;
  bool _resending = false;
  bool _canResend = false;
  @override
  void initState() {
    _resendOTPTimer();
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

  void _resendOTPTimer() {
    int _start = 300;
    String minutes = "";
    String seconds = "";
    setState(() {
      _canResend = false;
    });
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (!mounted) {
          return;
        }
        if (_start > 59) {
          minutes = (_start / 60).floor().toString();
          var s = _start % 60;
          if (s > 9) {
            seconds = s.toString();
          } else {
            seconds = ("0$s").toString();
          }
          _start--;

          _waitingTime.value = "0$minutes:${seconds}s";
          _waitingTime.notifyListeners();
        } else {
          if (_start > 9) {
            seconds = _start.toString();
          } else {
            seconds = ("0$_start").toString();
          }
          _start--;

          _waitingTime.value = "00:${seconds}s";
          _waitingTime.notifyListeners();
        }
        if (_start == 0) {
          _timer.cancel();
          timer.cancel();
          _waitingTime.value = "00:00s";
          _waitingTime.notifyListeners();
          setState(() {
            _canResend = true;
          });
          return;
        }
      },
    );
  }

  _getUserDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    phone = preferences.getString("phone")!;
    if (phone == "") {
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
    VerifyPhoneDetails verifyPhoneDetails = VerifyPhoneDetails(
      phone: phone,
      otp: _textEditingController.text,
    );

    /// Show loading dialog
    loadingDialog.createDialog(context);
    ResponseMessage responseMessage;
    setState(() {
      _verifying = true;
    });
    responseMessage = await AuthenticationProvider()
        .verifyPhone(verifyPhoneDetails: verifyPhoneDetails);

    /// Close loading dialog
    Navigator.of(context, rootNavigator: true).pop();

    /// Refresh user details
    await context.read<UserDetailsProvider>().setUserDetails();
    if (responseMessage.error == false) {
      // Fluttertoast.cancel();
      // Fluttertoast.showToast(
      //   msg: responseMessage.message,
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.SNACKBAR,
      //   fontSize: 12,
      //   backgroundColor: cPrimary,
      //   timeInSecForIosWeb: 2,
      // );
      Navigator.of(context).pushNamedAndRemoveUntil(Home.route, (_) => false);
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

  _resend() async {
    setState(() {
      _resending = true;
    });

    /// Show loading dialog
    loadingDialog.createDialog(context);
    ResponseMessage responseMessage;
    responseMessage = await AuthenticationProvider().resendOTPCode(phone: phone);

    /// Close loading dialog
    Navigator.of(context, rootNavigator: true).pop();
    if (responseMessage.error == false) {
      _resendOTPTimer();
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: "OTP code sent",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        fontSize: 12,
        backgroundColor: cSuccess,
        timeInSecForIosWeb: 2,
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
            title: "Resend failed",
            content: Text(responseMessage.message),
          );
        },
      );
    }

    setState(() {
      _resending = false;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _textEditingController.dispose();
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
                title: const Text("Verify OTP"),
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
                        height: p2,
                      ),
                      ValueListenableBuilder(
                        valueListenable: _waitingTime,
                        builder: (context, String time, _) {
                          return RichText(
                            textAlign: TextAlign.center,
                            textScaleFactor:
                                MediaQuery.textScaleFactorOf(context),
                            text: TextSpan(
                              text: "Resend in ",
                              style: Theme.of(context).textTheme.bodySmall,
                              children: [
                                TextSpan(
                                  text: "$time",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(color: cPrimary),
                                ),
                              ],
                            ),
                          );
                        },
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
                          controller: _textEditingController,
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
                            gapSpace: p4,
                            lineHeight: 2,
                          ),
                          codeLength: 4,
                          onCodeSubmitted: (code) {},
                          onCodeChanged: (code) {
                            _code = _textEditingController.text;
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
                            if (_textEditingController.text == "" ||
                                _textEditingController.text.length != 4) {
                            } else {
                              _verify();
                            }
                          },
                          label: "Verify OTP",
                          loadingLabel: "Verifying ...",
                          loading: _verifying,
                        ),
                      ),
                      const SizedBox(
                        height: p1,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: pagePadding,
                        ),
                        child: textButton.createSmallTextButton(
                          function: _canResend ? _resend : () {},
                          label: "Resend OTP code",
                          loadingLabel: "Resending ...",
                          loading: _resending,
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
