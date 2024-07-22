import 'package:b2b_connect/components/custom_button.dart';
import 'package:b2b_connect/components/custom_dialog.dart';
import 'package:b2b_connect/models/response.dart';
import 'package:b2b_connect/models/social_data.dart';
import 'package:b2b_connect/models/social_registration_details_.dart';
import 'package:b2b_connect/providers/authentication_provider.dart';
import 'package:b2b_connect/providers/user_details.dart';
import 'package:b2b_connect/screens/authentication/verify_otp.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';

class CompleteDetailsSocialRegister extends StatefulWidget {
  static const String route = '/completeDetailsSocialRegister';
  final SocialDataRegistration socialDataRegistration;

  const CompleteDetailsSocialRegister({
    Key? key,
    required this.socialDataRegistration,
  }) : super(key: key);

  @override
  State<CompleteDetailsSocialRegister> createState() =>
      _CompleteDetailsSocialRegisterState();
}

class _CompleteDetailsSocialRegisterState
    extends State<CompleteDetailsSocialRegister> {
  DateTime? currentBackPressTime;
  CustomLoadingStateDialog loadingDialog = CustomLoadingStateDialog();
  CustomMaterialButton materialButton = CustomMaterialButton();
  final _formKey = GlobalKey<FormState>();

  /// DOB and gender
  TextEditingController _dob = TextEditingController();
  TextEditingController _username = TextEditingController();
  TextEditingController _phoneNumber = TextEditingController();

  final _dobFieldKey = GlobalKey<FormFieldState>();
  final _phoneNumberFieldKey = GlobalKey<FormFieldState>();
  final _usernameFieldKey = GlobalKey<FormFieldState>();
  FocusNode _phoneNumberFN = FocusNode();
  FocusNode _usernameFN = FocusNode();
  FocusNode _dobFN = FocusNode();

  late List<String> gender = ["MALE", "FEMALE"];
  late bool genderError = false;
  late String selectedGender = "";
  late String phoneNumber = "";
  late String completeNumber = "";

  _submit() async {
    /// Check connectivity

    var connectivityResult = await Connectivity().checkConnectivity();
    if (!_usernameFieldKey.currentState!.validate()) {
      _usernameFN.requestFocus();
      return;
    }
    if (!_phoneNumberFieldKey.currentState!.validate()) {
      _phoneNumberFN.requestFocus();
      return;
    }
    if (!_dobFieldKey.currentState!.validate()) {
      _dobFN.requestFocus();
      return;
    }
    if (selectedGender == "") {
      setState(() {
        genderError = true;
      });
      return;
    }
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
    List<String> dobList = _dob.text.split("-");
    String dob = dobList[2] + "/" + dobList[1] + "/" + dobList[0];
    String phone = "255" + _phoneNumber.text;

    SocialRegistration socialRegistration = SocialRegistration(
      firstName: widget.socialDataRegistration.firstName,
      middleName: widget.socialDataRegistration.middleName,
      lastName: widget.socialDataRegistration.lastName,
      email: widget.socialDataRegistration.email,
      uid: widget.socialDataRegistration.uid,
      type: widget.socialDataRegistration.type,
      phone: phone,
      dob: dob,
      gender: selectedGender,
      username: _username.text,
    );

    /// Show loading dialog
    loadingDialog.createDialog(context);

    ResponseMessage responseMessage = await AuthenticationProvider()
        .socialRegisterUser(socialRegistration: socialRegistration);

    /// Close loading dialog
    Navigator.of(context, rootNavigator: true).pop();

    /// Refresh user details
    await context.read<UserDetailsProvider>().setUserDetails();
    if (responseMessage.error == false) {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      if (preferences.getString("access_token")!.isNotEmpty &&
          preferences.getString("phone")!.isNotEmpty) {
        ///
        /// Navigate to OTP Screen
        ///
        Navigator.pushNamed(context, VerifyOTP.route);
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
            title: "Registration failed",
            content: Text(responseMessage.message),
          );
        },
      );
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: SizedBox(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Complete to register "),
          ),
          body: SingleChildScrollView(
            key: Key("stepPasswordFormFields"),
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
                    key: _usernameFieldKey,
                    controller: _username,
                    focusNode: _usernameFN,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: "Username",
                      suffixIcon: const Icon(Icons.person_rounded),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(new RegExp(r"\s\b|\b\s"))
                    ],
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Username is required";
                      }
                      if (value.length < 3) {
                        return "Username is too short";
                      }
                    },
                  ),
                  const SizedBox(
                    height: p5,
                  ),
                  TextFormField(
                    key: _phoneNumberFieldKey,
                    controller: _phoneNumber,
                    focusNode: _phoneNumberFN,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.go,
                    maxLength: 9,
                    validator: (phone) {
                      if (phone == null || phone.isEmpty) {
                        return "Phone number is required";
                      }
                      if (phone.startsWith("0")) {
                        return "Should not start with 0";
                      }
                      if (phone.length < 9) {
                        return "Incomplete phone number";
                      }
                      return null;
                    },
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
                          children: const [
                            Padding(
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
                  TextFormField(
                    key: _dobFieldKey,
                    controller: _dob,
                    focusNode: _dobFN,
                    keyboardType: TextInputType.datetime,
                    textInputAction: TextInputAction.go,
                    readOnly: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Date of birth required";
                      }
                    },
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        helpText: "Select your date of birth",
                        initialDate: DateTime(1990),
                        firstDate: DateTime(1930),
                        lastDate: DateTime.now(),
                        cancelText: "Cancel",
                        confirmText: "SELECT",
                      );

                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        setState(() {
                          _dob.text = formattedDate;
                        });
                      } else {
                        /// print("Date is not selected");
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "yyyy-mm-dd",
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                  const SizedBox(
                    height: p5,
                  ),
                  getGenderWidget(),
                  const SizedBox(
                    height: p5,
                  ),
                  _termsServices(),
                  const SizedBox(
                    height: p5,
                  ),
                  materialButton.createButton(
                    function: () {
                      _submit();
                    },
                    label: "Register",
                    loadingLabel: "",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getGenderWidget() {
    return Container(
      key: Key("getGenderWidget"),
      padding: const EdgeInsets.symmetric(
        vertical: p1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select your gender",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(
            height: p1,
          ),
          Row(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    genderError = false;
                    selectedGender = gender[0];
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: genderError
                              ? Colors.red
                              : selectedGender == gender[0]
                                  ? Theme.of(context).primaryColor
                                  : divider2,
                          shape: BoxShape.circle,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(2),
                          child: Container(
                            decoration: BoxDecoration(
                              color: selectedGender == gender[0]
                                  ? Theme.of(context).primaryColor
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: p2),
                        child: Text(
                          "Male",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    genderError = false;
                    selectedGender = gender[1];
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: genderError
                              ? Colors.red
                              : selectedGender == gender[1]
                                  ? Theme.of(context).primaryColor
                                  : divider2,
                          shape: BoxShape.circle,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(2),
                          child: Container(
                            decoration: BoxDecoration(
                              color: selectedGender == gender[1]
                                  ? Theme.of(context).primaryColor
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "Female",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _termsServices() {
    TextStyle? style = Theme.of(context).textTheme.bodySmall!;
    return RichText(
      textAlign: TextAlign.center,
      textScaleFactor: MediaQuery.textScaleFactorOf(context),
      text: TextSpan(
        text: "By continuing, you agree to our ",
        style: style,
        children: [
          TextSpan(
            text: "Terms and Service",
            style: style.copyWith(color: cPrimary),
            recognizer: TapGestureRecognizer()..onTap = () {},
          ),
          TextSpan(
            text: " and acknowledge that you have read our ",
          ),
          TextSpan(
            text: "Privacy policy",
            style: style.copyWith(color: cPrimary),
            recognizer: TapGestureRecognizer()..onTap = () {},
          ),
          TextSpan(
            text: " to learn how we collect, use and share your data",
          ),
        ],
      ),
    );
  }
}
