import 'package:b2b_connect/components/custom_button.dart';
import 'package:b2b_connect/components/custom_dialog.dart';
import 'package:b2b_connect/components/string_functions.dart';
import 'package:b2b_connect/models/registration_details.dart';
import 'package:b2b_connect/models/response.dart';
import 'package:b2b_connect/providers/authentication_provider.dart';
import 'package:b2b_connect/screens/authentication/verify_otp.dart';
import 'package:b2b_connect/utils/validators.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

class Register extends StatefulWidget {
  static const String route = '/register';

  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  CustomMaterialButton materialButton = CustomMaterialButton();
  CustomOutlineButton outlineButton = CustomOutlineButton();

  /// Full names
  TextEditingController _firstName = TextEditingController();
  TextEditingController _middleName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  FocusNode _firstNameFN = FocusNode();
  FocusNode _middleNameFN = FocusNode();
  FocusNode _lastNameFN = FocusNode();
  final _firstNameFieldKey = GlobalKey<FormFieldState>();
  final _middleNameFieldKey = GlobalKey<FormFieldState>();
  final _lastNameFieldKey = GlobalKey<FormFieldState>();

  /// DOB and gender
  TextEditingController _dob = TextEditingController();
  FocusNode _dobFN = FocusNode();
  final _dobFieldKey = GlobalKey<FormFieldState>();
  late List<String> gender = ["MALE", "FEMALE"];
  late bool genderError = false;
  late String selectedGender = "";

  /// Account credentials
  TextEditingController _username = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _phoneNumber = TextEditingController();
  FocusNode _usernameFN = FocusNode();
  FocusNode _emailFN = FocusNode();
  FocusNode _phoneNumberFN = FocusNode();
  final _usernameFieldKey = GlobalKey<FormFieldState>();
  final _emailFieldKey = GlobalKey<FormFieldState>();
  final _phoneNumberFieldKey = GlobalKey<FormFieldState>();

  late String phoneNumber = "";
  late String completeNumber = "";

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

  ///
  late PageController _pageController;

  @override
  initState() {
    _pageController = PageController(
      initialPage: 0,
    );
    super.initState();
  }

  _nextPage() {
    _pageController.nextPage(
        duration: const Duration(milliseconds: 700), curve: Curves.ease);
  }

  _previousPage() {
    _pageController.previousPage(
        duration: const Duration(milliseconds: 700), curve: Curves.ease);
  }

  @override
  dispose() {
    /// Dispose controller
    _firstName.dispose();
    _middleName.dispose();
    _lastName.dispose();
    _username.dispose();
    _email.dispose();
    _phoneNumber.dispose();
    _dob.dispose();
    _password.dispose();
    _confirmPassword.dispose();

    /// dispose FocusNode
    _firstNameFN.dispose();
    _middleNameFN.dispose();
    _lastNameFN.dispose();
    _usernameFN.dispose();
    _emailFN.dispose();
    _phoneNumberFN.dispose();
    _dobFN.dispose();
    _passwordFN.dispose();
    _confirmPasswordFN.dispose();

    /// dispose PageController
    _pageController.dispose();

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
    List<String> dobList = _dob.text.split("-");
    String dob = dobList[2] + "/" + dobList[1] + "/" + dobList[0];
    String middleName = _middleName.text == "" ? "---" : _middleName.text;
    String phone = "255" + _phoneNumber.text;
    Registration authenticateDetails = Registration(
      firstName: _firstName.text.capitalize(),
      middleName: middleName.capitalize(),
      lastName: _lastName.text.capitalize(),
      dob: dob,
      gender: selectedGender,
      username: _username.text,
      email: _email.text,
      phone: phone,
      password: _password.text,
    );

    /// Show loading dialog
    loadingDialog.createDialog(context);

    ResponseMessage responseMessage;
    responseMessage = await AuthenticationProvider()
        .registerUser(registrationDetails: authenticateDetails);

    /// Close loading dialog
    Navigator.of(context, rootNavigator: true).pop();

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

  _exitPage() {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        content: Text(
            "Exit this page will clear all details filled on the form fields"),
        dismissText: "Cancel",
        actionBtnText: "Exit",
        actionFunction: () {
          Navigator.of(context).pop();
        },
      ),
    ).then(
      (value) {
        return true;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: WillPopScope(
        onWillPop: () async {
          if (_pageController.page != 0) {
            _exitPage();
            return false;
          }
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Create new account"),
          ),
          body: Consumer<AuthenticationProvider>(
            builder: (context, auth, _) {
              return PageView(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  stepFullNameFormFields(index: 0),
                  stepPersonalDetailsFormFields(index: 1),
                  stepAccountDetailsFormFields(index: 2),
                  stepPasswordFormFields(index: 3),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget controls({required int index}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: p5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          index == 0
              ? const SizedBox()
              : Flexible(
                  child: outlineButton.createButtonSmall(
                    function: _previousPage,
                    label: "Previous",
                    loadingLabel: "",
                  ),
                ),
          index == 0
              ? const SizedBox()
              : const SizedBox(
                  width: p3,
                ),
          index == 3
              ? Flexible(
                  child: materialButton.createButtonSmall(
                    function: () {
                      bool _hasError = _validate(index: index);
                      if (!_hasError) {
                        _submit();
                      }
                    },
                    label: "Register",
                    loadingLabel: "",
                  ),
                )
              : Flexible(
                  child: materialButton.createButtonSmall(
                    function: () {
                      bool _hasError = _validate(index: index);
                      if (!_hasError) {
                        _nextPage();
                      }
                    },
                    label: "Next",
                    loadingLabel: "",
                  ),
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

  Widget stepFullNameFormFields({required int index}) {
    return SingleChildScrollView(
      key: Key("stepFullNameFormFields"),
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
          TextFormField(
            key: _firstNameFieldKey,
            controller: _firstName,
            focusNode: _firstNameFN,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            inputFormatters: [
              FilteringTextInputFormatter.deny(new RegExp(r"\s\b|\b\s"))
            ],
            decoration: InputDecoration(
              labelText: "First name",
              suffixIcon: const Icon(Icons.person_rounded),
            ),
            validator: (value) => Validators.validateName(
                value!, "First name is required", "First name is too short"),
          ),
          const SizedBox(
            height: p5,
          ),
          TextFormField(
            key: _middleNameFieldKey,
            controller: _middleName,
            focusNode: _middleNameFN,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            inputFormatters: [
              FilteringTextInputFormatter.deny(new RegExp(r"\s\b|\b\s"))
            ],
            validator: (value) => Validators.validateMiddlename(value!),
            decoration: InputDecoration(
              labelText: "Middle name",
              suffixIcon: const Icon(Icons.person_rounded),
            ),
          ),
          const SizedBox(
            height: p5,
          ),
          TextFormField(
            key: _lastNameFieldKey,
            controller: _lastName,
            focusNode: _lastNameFN,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.go,
            inputFormatters: [
              FilteringTextInputFormatter.deny(new RegExp(r"\s\b|\b\s"))
            ],
            decoration: InputDecoration(
              labelText: "Last name",
              suffixIcon: const Icon(Icons.person_rounded),
            ),
            validator: (value) => Validators.validateName(
                value!, "Last name is required", "Last name is too short"),
          ),
          controls(index: index),
        ],
      ),
    );
  }

  Widget stepPersonalDetailsFormFields({required int index}) {
    return SingleChildScrollView(
      key: Key("stepPersonalDetailsFormFields"),
      padding: const EdgeInsets.symmetric(
        horizontal: pagePadding,
        vertical: pagePadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: p2,
          ),
          Text(
            "When is your birthday?",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(
            height: p2,
          ),
          TextFormField(
            key: _dobFieldKey,
            controller: _dob,
            focusNode: _dobFN,
            keyboardType: TextInputType.datetime,
            textInputAction: TextInputAction.go,
            readOnly: true,
            validator: (value) =>
                Validators.validateInputWithCustomErrorMessage(
                    value!, "Date of birth is required"),
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
          genderError
              ? Padding(
                  padding: const EdgeInsets.only(
                    left: p2,
                    top: p2,
                  ),
                  child: Text(
                    "Select gender",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                )
              : const SizedBox(),
          controls(index: index),
        ],
      ),
    );
  }

  Widget stepAccountDetailsFormFields({required int index}) {
    return SingleChildScrollView(
      key: Key("stepAccountDetailsFormFields"),
      padding: const EdgeInsets.symmetric(
        horizontal: pagePadding,
        vertical: pagePadding,
      ),
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
            validator: (value) => Validators.validateName(
                value!, "Username is required", "Username is too short"),
          ),
          const SizedBox(
            height: p5,
          ),
          TextFormField(
              key: _emailFieldKey,
              controller: _email,
              focusNode: _emailFN,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: "Email",
                suffixIcon: const Icon(Icons.mail),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.deny(new RegExp(r"\s\b|\b\s"))
              ],
              validator: (value) => Validators.validateEmail(value!)),
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
            validator: (phone) => Validators.validatePhoneNumber(phone!),
            inputFormatters: [
              FilteringTextInputFormatter.deny(new RegExp(r"\s\b|\b\s")),
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
          controls(index: index),
        ],
      ),
    );
  }

  Widget stepPasswordFormFields({required int index}) {
    return SingleChildScrollView(
      key: Key("stepPasswordFormFields"),
      padding: const EdgeInsets.symmetric(
        horizontal: pagePadding,
        vertical: pagePadding,
      ),
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
            validator: (value) => Validators.validateSignupPassword(value!),
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
            validator: (value) =>
                Validators.validateConfirmPassword(value!, _password.text),
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
          _termsServices(),
          controls(index: index),
        ],
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

  bool _validate({required int index}) {
    if (index == 0) {
      if (!_firstNameFieldKey.currentState!.validate()) {
        _firstNameFN.requestFocus();
        return true;
      }
      if (!_middleNameFieldKey.currentState!.validate()) {
        _middleNameFN.requestFocus();
        return true;
      }
      if (!_lastNameFieldKey.currentState!.validate()) {
        _lastNameFN.requestFocus();
        return true;
      }
    }
    if (index == 1) {
      if (!_dobFieldKey.currentState!.validate()) {
        _dobFN.requestFocus();
        return true;
      }
      if (selectedGender == "") {
        setState(() {
          genderError = true;
        });
        return true;
      }
    }
    if (index == 2) {
      if (!_usernameFieldKey.currentState!.validate()) {
        _usernameFN.requestFocus();
        return true;
      }
      if (!_emailFieldKey.currentState!.validate()) {
        _emailFN.requestFocus();
        return true;
      }
      if (!_phoneNumberFieldKey.currentState!.validate()) {
        _phoneNumberFN.requestFocus();
        return true;
      }
    }
    if (index == 3) {
      if (!_passwordFieldKey.currentState!.validate()) {
        _passwordFN.requestFocus();
        return true;
      }
      if (!_confirmPasswordFieldKey.currentState!.validate()) {
        _confirmPasswordFN.requestFocus();
        return true;
      }
    }
    return false;
  }
}
