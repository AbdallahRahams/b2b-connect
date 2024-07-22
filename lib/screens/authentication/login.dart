import 'package:b2b_connect/components/custom_button.dart';
import 'package:b2b_connect/components/custom_dialog.dart';
import 'package:b2b_connect/constants.dart';
import 'package:b2b_connect/models/authenticate_details.dart';
import 'package:b2b_connect/models/response.dart';
import 'package:b2b_connect/providers/authentication_provider.dart';
import 'package:b2b_connect/providers/user_details.dart';
import 'package:b2b_connect/screens/authentication/reset_password.dart';
import 'package:b2b_connect/screens/authentication/verify_otp.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/validators.dart';
import '../home_pages/home.dart';

class Login extends StatefulWidget {
  static const String route = '/login';

  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

enum FormEnum {
  email,
  phone,
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  CustomMaterialButton materialButton = CustomMaterialButton();
  CustomOutlineButton outlineButton = CustomOutlineButton();
  ValueNotifier<FormEnum> _isEmailForm = ValueNotifier(FormEnum.email);
  CustomLoadingStateDialog loadingDialog = CustomLoadingStateDialog();

  /// Login credentials
  TextEditingController _username = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _phoneNumber = TextEditingController();
  TextEditingController _passwordEmail = TextEditingController();
  TextEditingController _passwordPhone = TextEditingController();
  final _emailFieldKey = GlobalKey<FormFieldState>();
  final _phoneNumberFieldKey = GlobalKey<FormFieldState>();
  final _passwordEmailFieldKey = GlobalKey<FormFieldState>();
  final _passwordPhoneFieldKey = GlobalKey<FormFieldState>();

  FocusNode _usernameFN = FocusNode();
  FocusNode _emailFN = FocusNode();
  FocusNode _phoneNumberFN = FocusNode();
  FocusNode _passwordEmailFN = FocusNode();
  FocusNode _passwordPhoneFN = FocusNode();
  late String phoneNumber = "";
  late String completeNumber = "";

  ///
  late PageController _pageController;
  bool _signing = false;

  @override
  initState() {
    _pageController = PageController(
      initialPage: 0,
    );
    super.initState();
  }

  @override
  dispose() {
    /// Dispose controllers
    _isEmailForm.dispose();
    _email.dispose();
    _username.dispose();
    _phoneNumber.dispose();
    _passwordEmail.dispose();
    _passwordPhone.dispose();

    /// Dispose FocusNodes
    _emailFN.dispose();
    _usernameFN.dispose();
    _phoneNumberFN.dispose();
    _passwordPhoneFN.dispose();
    _passwordEmailFN.dispose();

    ///
    super.dispose();
  }

  _changeForm(FormEnum value) {
    _isEmailForm.value = value;
  }

  _changeFormPage({required int pageIndex}) {
    if (pageIndex != _pageController.page) {
      _pageController.animateToPage(pageIndex,
          duration: const Duration(milliseconds: 300), curve: Curves.linear);
    }
  }

  _submit({required AuthenticateDetails authenticateDetails}) async {
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

    /// Show loading dialog
    setState(() {
      _signing = true;
    });
    loadingDialog.createDialog(context);
    ResponseMessage responseMessage;

    responseMessage = await AuthenticationProvider()
        .authenticate(authenticateDetails: authenticateDetails);

    if (responseMessage.error == false) {
      /// Refresh user details
      await context.read<UserDetailsProvider>().setUserDetails();
    }

    /// Close loading dialog
    Navigator.of(context, rootNavigator: true).pop();
    setState(() {
      _signing = false;
    });

    ///
    if (responseMessage.error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
            title: "Login failed",
            content: Text(responseMessage.message),
          );
        },
      );
    } else {
      if (preferences.getBool("is_valid_number") == true) {
        Navigator.of(context).pushNamedAndRemoveUntil(Home.route, (_) => false);
      } else {
        /// Verify phone number
        String phone = preferences.getString("phone")!;
        AuthenticationProvider().resendOTPCode(phone: phone);
        Navigator.of(context).pushNamed(VerifyOTP.route);
      }
    }
  }

  bool _isObscureEmail = true;
  bool _isObscurePhone = true;
  var _formKeyEmail = GlobalKey<FormState>();
  var _formKeyPhone = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ValueListenableBuilder(
              valueListenable: _isEmailForm,
              builder: (context, FormEnum isEmailForm, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          _changeForm(FormEnum.email);
                          _changeFormPage(pageIndex: 0);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: FormEnum.email == isEmailForm
                                    ? divider1
                                    : divider3,
                                width: 1,
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: p3,
                          ),
                          child: Text(
                            "Email",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          _changeForm(FormEnum.phone);
                          _changeFormPage(pageIndex: 1);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: FormEnum.phone == isEmailForm
                                    ? divider1
                                    : divider3,
                                width: 1,
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: p3,
                          ),
                          child: Text(
                            "Phone",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Form(
                    key: _formKeyEmail,
                    child: SingleChildScrollView(
                      padding:
                          const EdgeInsets.symmetric(horizontal: pagePadding),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: p5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: p2),
                            child: TextFormField(
                              key: _emailFieldKey,
                              controller: _email,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(
                                    new RegExp(r"\s\b|\b\s"))
                              ],
                              validator: (value) =>
                                  Validators.validateEmail(value!),
                              decoration: InputDecoration(
                                labelText: "Email",
                                suffixIcon: Icon(
                                  Icons.mail_sharp,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: p5,
                          ),
                          TextFormField(
                            key: _passwordEmailFieldKey,
                            controller: _passwordEmail,
                            validator: (value) =>
                                Validators.validateInputWithCustomErrorMessage(
                                    value!, "Password is required"),
                            obscureText: _isObscureEmail,
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.go,
                            decoration: InputDecoration(
                              labelText: "Password",
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    _isObscureEmail = !_isObscureEmail;
                                  });
                                },
                                child: Icon(
                                  _isObscureEmail
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: p5,
                          ),
                          materialButton.createButton(
                            function: () {
                              if (_formKeyEmail.currentState!.validate()) {
                                _submit(
                                  authenticateDetails: AuthenticateDetails(
                                    username: _email.text,
                                    password: _passwordEmail.text,
                                  ),
                                );
                              }
                            },
                            label: "Sign in",
                            loadingLabel: "Authenticating ...",
                            loading: _signing,
                          ),
                          const SizedBox(
                            height: p3,
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            textScaleFactor:
                                MediaQuery.textScaleFactorOf(context),
                            text: TextSpan(
                                text: "Forget your password?",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: cPrimary),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).pushNamed(
                                        ResetPasswordWithNumber.route);
                                    // _showResetPasswordSelectionModal(context);
                                  }),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Form(
                    key: _formKeyPhone,
                    child: SingleChildScrollView(
                      padding:
                          const EdgeInsets.symmetric(horizontal: pagePadding),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: p5,
                          ),
                          TextFormField(
                            key: _phoneNumberFieldKey,
                            controller: _phoneNumber,
                            maxLength: 9,
                            validator: (phone) =>
                                Validators.validatePhoneNumber(phone!),
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              FilteringTextInputFormatter.allow(
                                RegExp(r"^[1-9][0-9]*$"),
                              ),
                            ],
                            decoration: InputDecoration(
                              labelText: "Phone number",
                              suffixIcon: const Icon(Icons.phone_iphone),
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
                          TextFormField(
                            key: _passwordPhoneFieldKey,
                            controller: _passwordPhone,
                            validator: (value) =>
                                Validators.validateInputWithCustomErrorMessage(
                                    value!, "Password is required"),
                            obscureText: _isObscurePhone,
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              labelText: "Password",
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    _isObscurePhone = !_isObscurePhone;
                                  });
                                },
                                child: Icon(
                                  _isObscurePhone
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: p5,
                          ),
                          materialButton.createButton(
                            function: () {
                              if (_formKeyPhone.currentState!.validate()) {
                                String phone = "255${_phoneNumber.text}";
                                _submit(
                                  authenticateDetails: AuthenticateDetails(
                                    username: phone,
                                    password: _passwordPhone.text,
                                  ),
                                );
                              }
                            },
                            label: "Sign in",
                            loadingLabel: "Authenticating ...",
                            loading: _signing,
                          ),
                          const SizedBox(
                            height: p2,
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                text: "Forget your password?",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: cPrimary),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).pushNamed(
                                        ResetPasswordWithNumber.route);
                                    // _showResetPasswordSelectionModal(context);
                                  }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
