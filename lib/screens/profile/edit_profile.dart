import 'package:b2b_connect/components/custom_button.dart';
import 'package:b2b_connect/components/custom_dialog.dart';
import 'package:b2b_connect/components/string_functions.dart';
import 'package:b2b_connect/constants.dart';
import 'package:b2b_connect/models/response.dart';
import 'package:b2b_connect/models/update_profile_details.dart';
import 'package:b2b_connect/providers/authentication_provider.dart';
import 'package:b2b_connect/providers/user_details.dart';
import 'package:b2b_connect/screens/authentication/verify_otp.dart';
import 'package:b2b_connect/utils/validators.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditUserProfile extends StatefulWidget {
  static const String route = '/EditUserProfile';

  const EditUserProfile({Key? key}) : super(key: key);

  @override
  _EditUserProfileState createState() => _EditUserProfileState();
}

class _EditUserProfileState extends State<EditUserProfile> {
  CustomMaterialButton materialButton = CustomMaterialButton();
  CustomOutlineButton outlineButton = CustomOutlineButton();
  bool _isUpdating = false;

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
  String initialDate = "";
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

  CustomLoadingStateDialog loadingDialog = CustomLoadingStateDialog();

  /// PageController
  late PageController _pageController;

  @override
  initState() {
    _pageController = PageController(
      initialPage: 0,
    );
    _getUserDetails();
    super.initState();
  }

  _getUserDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _firstName.text = preferences.getString("first_name")!.capitalize();
    _middleName.text = preferences.getString("middle_name")! == "---"
        ? ""
        : preferences.getString("middle_name")!.capitalize();
    _lastName.text = preferences.getString("last_name")!.capitalize();
    _dob.text = preferences.getString("dob")!;
    initialDate = _dob.text.initialDateInput();
    selectedGender = preferences.getString("gender")!;
    _email.text = preferences.getString("email")!;
    _username.text = preferences.getString("username")!;
    _phoneNumber.text = preferences.getString("phone")!.substring(3);
    setState(() {});
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
    _isUpdating = true;
    setState(() {});
    String dob = "";
    if (_dob.text.contains("-")) {
      List<String> dobList = _dob.text.split("-");
      dob = dobList[2] + "/" + dobList[1] + "/" + dobList[0];
    } else {
      dob = _dob.text;
    }
    String middleName = _middleName.text == "" ? "---" : _middleName.text;
    String phone = "255" + _phoneNumber.text;
    UpdateProfileDetails updateProfileDetails = UpdateProfileDetails(
      firstName: _firstName.text,
      middleName: middleName,
      lastName: _lastName.text,
      dob: dob,
      gender: selectedGender,
      username: _username.text,
      email: _email.text,
      phone: phone,
    );

    /// Show loading dialog
    loadingDialog.createDialog(context);

    ResponseMessage responseMessage;
    responseMessage = await AuthenticationProvider()
        .updateProfile(updateProfileDetails: updateProfileDetails);

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
        /// Navigate to previous screen
        ///
        Fluttertoast.cancel();
        Fluttertoast.showToast(
          msg: "Updated successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          fontSize: 12,
          backgroundColor: cToastSuccess,
          timeInSecForIosWeb: 2,
        );
        print(responseMessage.message);
        if (responseMessage.message.toLowerCase().contains("phone")) {
          // preferences.setBool("is_valid_number", false);
          preferences.setString("phone", updateProfileDetails.phone);
          Navigator.of(context).pop(false);
          Navigator.of(context).pushNamed(VerifyOTP.route);
        } else {
          Navigator.of(context).pop(true);
        }
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
            title: "Update failed",
            content: Text(responseMessage.message),
          );
        },
      );
    }
    _isUpdating = false;
    setState(() {});
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
            title: const Text("Edit profile details"),
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
          index == 2
              ? Flexible(
                  child: materialButton.createButtonSmall(
                    function: () {
                      bool _hasError = _validate(index: index);
                      if (!_hasError) {
                        _submit();
                      }
                    },
                    label: "Update",
                    loadingLabel: "Updating ...",
                    loading: _isUpdating,
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
            validator: (value) {
              if (value!.isEmpty) {
                return "First name is required";
              }
              if (value.length < 3) {
                return "First name too short";
              }
              return null;
            },
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
            validator: (value) {
              if (value!.isNotEmpty && value.length < 3) {
                return "Last name too short";
              }
              return null;
            },
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
            validator: (value) {
              if (value!.isEmpty) {
                return "Last name is required";
              }
              if (value.length < 3) {
                return "Last name too short";
              }
              return null;
            },
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
              if (_dob.text.contains("-")) {
                initialDate = _dob.text;
              }
              DateTime? pickedDate = await showDatePicker(
                context: context,
                helpText: "Select your date of birth",
                initialDate: DateTime.parse(initialDate),
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
            validator: (value) => Validators.validateEmail(value!),
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
