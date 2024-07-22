import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:b2b_connect/components/string_functions.dart';
import 'package:b2b_connect/constants.dart';
import 'package:b2b_connect/models/authenticate_details.dart';
import 'package:b2b_connect/models/change_password_details.dart';
import 'package:b2b_connect/models/position_dummy.dart';
import 'package:b2b_connect/models/registration_details.dart';
import 'package:b2b_connect/models/report_problem.dart';
import 'package:b2b_connect/models/reset_password_new_password_details.dart';
import 'package:b2b_connect/models/response.dart';
import 'package:b2b_connect/models/social_authenticate_details.dart';
import 'package:b2b_connect/models/social_registration_details_.dart';
import 'package:b2b_connect/models/update_profile_details.dart';
import 'package:b2b_connect/models/user.dart';
import 'package:b2b_connect/models/verify_phone_details.dart';
import 'package:b2b_connect/models/verify_reset_password_otp.dart';
import 'package:b2b_connect/providers/user_details.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_information/device_information.dart';

class AuthenticationProvider with ChangeNotifier {
  ///
  /// Variable
  ///
  bool _isLoading = false;
  bool _sessionSent = false;
  bool get isLoading => _isLoading;
  bool get isSessionSent => _sessionSent;
  AuthenticationProvider() {

  }

  ///
  /// Registration
  ///
  Future<ResponseMessage> registerUser(
      {required Registration registrationDetails}) async {
    late ResponseMessage responseMessage;
    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> registerUserData = {
      "first_name": registrationDetails.firstName,
      "middle_name": registrationDetails.middleName,
      "last_name": registrationDetails.lastName,
      "date_of_birth": registrationDetails.dob,
      "gender": registrationDetails.gender,
      "username": registrationDetails.username,
      "email": registrationDetails.email,
      "phone_number": registrationDetails.phone,
      "password": registrationDetails.password,
    };
    try {
      late http.Response responseForRegisteringUser;
      responseForRegisteringUser = await http.post(
          Uri.parse('$baseURL/api/register/user'),
          body: json.encode(registerUserData),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          });

      /// Successful request
      if (responseForRegisteringUser.statusCode == 200) {
        responseMessage = ResponseMessage(
            error: false,
            unauthorized: false,
            message: "Successful created an account");

        /// Auto Authenticate After Registration
        return authenticate(
          authenticateDetails: AuthenticateDetails(
            username: registrationDetails.phone,
            password: registrationDetails.password,
          ),
        );
      } else {
        /// Bad request
        if (responseForRegisteringUser.statusCode == 400) {
          String? message;
          final Map<String, dynamic> responseData =
              json.decode(responseForRegisteringUser.body);
          if (responseData.containsKey("username")) {
            message = " • Username is not available";
          }
          if (responseData.containsKey("email")) {
            message =
                "${message == null ? "" : "$message\n"} • Email is already used";
          }
          if (responseData.containsKey("phone_number")) {
            message =
                "${message == null ? "" : "$message\n"} • Phone number is already used";
          }

          responseMessage = ResponseMessage(
              error: true,
              unauthorized: false,
              message:
                  message == null ? "Failed to create a new account" : message);
        }

        /// Internal Server error
        if (responseForRegisteringUser.statusCode == 500) {
          responseMessage = ResponseMessage(
              error: true,
              unauthorized: false,
              message: "Internal server error");
        }
      }

      _isLoading = false;
      notifyListeners();
      return responseMessage;
    } catch (e) {
      responseMessage = ResponseMessage(
          error: true, unauthorized: false, message: "Something went wrong");
      _isLoading = false;
      notifyListeners();
      return responseMessage;
    }
  }

  ///
  /// Registration Social
  /// TODO
  Future<ResponseMessage> socialRegisterUser(
      {required SocialRegistration socialRegistration}) async {
    late ResponseMessage responseMessage;
    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> socialRegisterUserData = {
      "first_name": socialRegistration.firstName.toString().capitalize(),
      "middle_name": socialRegistration.middleName.toString().capitalize(),
      "last_name": socialRegistration.lastName.toString().capitalize(),
      "date_of_birth": socialRegistration.dob,
      "gender": socialRegistration.gender,
      "username": socialRegistration.username,
      "email": socialRegistration.email,
      "uid": socialRegistration.uid,
      "phone_number": socialRegistration.phone,
      "type": socialRegistration.type,
    };
    try {
      late http.Response responseForRegisteringUser;
      responseForRegisteringUser = await http.post(
          Uri.parse(
              '$baseURL/api/v1/user/seed/social/network/authentication/details'),
          body: json.encode(socialRegisterUserData),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          });

      /// Successful request
      if (responseForRegisteringUser.statusCode == 200) {
        responseMessage = ResponseMessage(
            error: false,
            unauthorized: false,
            message: "Successful created an account");

        /// TODO
        /// Social Auto Authenticate After Registration
        return await socialAuthenticate(
          socialAuthenticateDetails: SocialAuthenticateDetails(
            uid: socialRegistration.uid,
            email: socialRegistration.email,
          ),
        );
      } else {
        /// Bad request
        if (responseForRegisteringUser.statusCode == 400) {
          String? message;
          final Map<String, dynamic> responseData =
              json.decode(responseForRegisteringUser.body);
          if (responseData.containsKey("username")) {
            message = " • Username is not available";
          }
          if (responseData.containsKey("email")) {
            message =
                "${message == null ? "" : "$message\n"} • Email is already used";
          }
          if (responseData.containsKey("phone_number")) {
            message =
                "${message == null ? "" : "$message\n"} • Phone number is already used";
          }

          responseMessage = ResponseMessage(
              error: true,
              unauthorized: false,
              message:
                  message == null ? "Failed to create a new account" : message);
        }

        /// Internal Server error
        if (responseForRegisteringUser.statusCode == 500) {
          responseMessage = ResponseMessage(
              error: true,
              unauthorized: false,
              message: "Internal server error");
        }
      }

      _isLoading = false;
      notifyListeners();
      return responseMessage;
    } catch (e) {
      responseMessage = ResponseMessage(
          error: true, unauthorized: false, message: "Something went wrong");
      _isLoading = false;
      notifyListeners();
      return responseMessage;
    }
  }

  ///
  /// Login/Authenticate
  /// TODO
  Future<ResponseMessage> authenticate(
      {required AuthenticateDetails authenticateDetails}) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    ResponseMessage responseMessage = ResponseMessage(
      error: true,
      unauthorized: false,
      message: "Something went wrong",
    );

    _isLoading = true;
    notifyListeners();
    late http.Response response;
    final Map<String, dynamic> authData = {
      'username': authenticateDetails.username,
      'password': authenticateDetails.password
    };
    try {
      response = await http.post(Uri.parse('$baseURL/oauth/token'),
          body: json.encode(authData),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          });
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('access_token')) {
          final DateTime now = DateTime.now();
          final DateTime expiryTime =
              now.add(Duration(seconds: responseData['expires_in']));
          preferences.setString('access_token', responseData['access_token']);
          preferences.setString('refresh_token', responseData['refresh_token']);
          preferences.setString('token_type', responseData['token_type']);

          /// Key for time to logout user after Expire
          preferences.setString('expiryTime', expiryTime.toIso8601String());

          ///
          /// Get user details after login
          ///
          try {
            http.Response userDetailsResponse;
            userDetailsResponse =
                await http.get(Uri.parse('$baseURL/api/user'), headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': '${responseData['token_type']} ' +
                  responseData['access_token'],
            });
            final Map<String, dynamic> userDetailsResponseData =
                json.decode(userDetailsResponse.body);
            final User user = User.fromJson(userDetailsResponseData);
            print(user.createdAt);
            preferences.setInt('id', userDetailsResponseData['ID']);
            preferences.setString('first_name',
                userDetailsResponseData['FNAME'].toString().capitalize());
            preferences.setString('middle_name',
                userDetailsResponseData['MNAME'].toString().capitalize());
            preferences.setString('last_name',
                userDetailsResponseData['LNAME'].toString().capitalize());
            preferences.setString(
                'username', userDetailsResponseData['USER_NAME']);
            preferences.setString(
                'phone', userDetailsResponseData['PHONE_NUMBER']);
            preferences.setString('gender', userDetailsResponseData['GENDER']);
            preferences.setString(
                'dob', userDetailsResponseData['DATE_OF_BIRTH']);
            preferences.setString('email', userDetailsResponseData['EMAIL']);
            preferences.setString('age', userDetailsResponseData['AGE']);
            preferences.setBool(
                'is_valid_email', userDetailsResponseData['IS_VALID_EMAIL']);
            preferences.setBool(
                'is_valid_number', userDetailsResponseData['IS_VALID_NUMBER']);
            preferences.setString(
                'profile_image', userDetailsResponseData['PROFILE_IMAGE']);
            preferences.setString(
                'image_storage', userDetailsResponseData['IMAGE_STORAGE']);
            preferences.setString('status', userDetailsResponseData['STATUS']);
            preferences.setString(
                'created_at', userDetailsResponseData['CREATED_AT']);
            if (userDetailsResponseData['STATUS'] != "ACTIVE") {
              responseMessage = ResponseMessage(
                error: true,
                unauthorized: false,
                message: "This account is disabled",
              );
              _isLoading = false;
              notifyListeners();
              return responseMessage;
            }
            if (userDetailsResponseData['IS_VALID_NUMBER'] == false) {
              responseMessage = ResponseMessage(
                error: false,
                unauthorized: false,
                message: "This account is not verified",
              );
              _isLoading = false;
              notifyListeners();
              return responseMessage;
            }
            await sessionDetails();
            responseMessage = ResponseMessage(
              error: false,
              unauthorized: false,
              message: "Successful logged in",
            );
          } catch (e) {
            responseMessage = ResponseMessage(
              error: true,
              unauthorized: false,
              message: "Failed to get user details $e",
            );
            _isLoading = false;
            notifyListeners();
            return responseMessage;
          }
        } else if (responseData.containsKey('ERROR') &&
            responseData.containsKey('MESSAGE')) {
          List<String> messages = responseData['MESSAGE'];
          messages.forEach((message) {
            responseMessage = ResponseMessage(
              error: responseData['ERROR'],
              message: message,
              unauthorized: false,
            );
          });
        } else {
          responseMessage = ResponseMessage(
            error: true,
            unauthorized: false,
            message: "Failed to create an account",
          );
        }
        _isLoading = false;
        notifyListeners();
        return responseMessage;
      } else if (response.statusCode == 400) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('ERROR') &&
            responseData.containsKey('MESSAGE')) {
          responseMessage = ResponseMessage(
            error: true,
            unauthorized: false,
            message: "Invalid email/phone number or password",
          );
        }
        _isLoading = false;
        notifyListeners();
        return responseMessage;
      } else if (response.statusCode == 401) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('ERROR') &&
            responseData.containsKey('MESSAGE')) {
          responseMessage = ResponseMessage(
            error: true,
            unauthorized: false,
            message: "Invalid email/phone number or password",
          );
        }
        _isLoading = false;
        notifyListeners();
        return responseMessage;
      } else if (response.statusCode == 500) {
        responseMessage = ResponseMessage(
          error: true,
          unauthorized: false,
          message: "Server error",
        );
        _isLoading = false;
        notifyListeners();
        return responseMessage;
      }
      _isLoading = false;
      notifyListeners();
      return responseMessage;
    } catch (e) {
      responseMessage = ResponseMessage(
        error: true,
        unauthorized: false,
        message: "Something went wrong, retry",
      );
      _isLoading = false;
      notifyListeners();
      return responseMessage;
    }
  }

  ///
  /// Login/Authenticate Social
  ///
  Future<ResponseMessage> socialAuthenticate(
      {required SocialAuthenticateDetails socialAuthenticateDetails}) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    ResponseMessage responseMessage = ResponseMessage(
      error: true,
      unauthorized: false,
      message: "Something went wrong",
    );

    _isLoading = true;
    notifyListeners();

    late http.Response response;

    final Map<String, dynamic> authData = {
      'uid': socialAuthenticateDetails.uid,
      'email': socialAuthenticateDetails.email
    };
    try {
      response = await http.post(
          Uri.parse('$baseURL/api/v1/user/social/network/login'),
          body: json.encode(authData),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          });
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('access_token')) {
          final DateTime now = DateTime.now();
          final DateTime expiryTime =
              now.add(Duration(seconds: responseData['expires_in']));
          preferences.setString('access_token', responseData['access_token']);
          preferences.setString('refresh_token', responseData['refresh_token']);
          preferences.setString('token_type', responseData['token_type']);

          /// Key for time to logout user after Expire
          preferences.setString('expiryTime', expiryTime.toIso8601String());

          ///
          /// Get user details after login
          ///
          try {
            http.Response userDetailsResponse;
            userDetailsResponse =
                await http.get(Uri.parse('$baseURL/api/user'), headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': '${responseData['token_type']} ' +
                  responseData['access_token'],
            });
            final Map<String, dynamic> userDetailsResponseData =
                json.decode(userDetailsResponse.body);

            preferences.setInt('id', userDetailsResponseData['ID']);
            preferences.setString('first_name',
                userDetailsResponseData['FNAME'].toString().capitalize());
            preferences.setString('middle_name',
                userDetailsResponseData['MNAME'].toString().capitalize());
            preferences.setString('last_name',
                userDetailsResponseData['LNAME'].toString().capitalize());
            preferences.setString(
                'username', userDetailsResponseData['USER_NAME']);
            preferences.setString(
                'phone', userDetailsResponseData['PHONE_NUMBER']);
            preferences.setString('gender', userDetailsResponseData['GENDER']);
            preferences.setString(
                'dob', userDetailsResponseData['DATE_OF_BIRTH']);
            preferences.setString('email', userDetailsResponseData['EMAIL']);
            preferences.setString('age', userDetailsResponseData['AGE']);
            preferences.setBool(
                'is_valid_email', userDetailsResponseData['IS_VALID_EMAIL']);
            preferences.setBool(
                'is_valid_number', userDetailsResponseData['IS_VALID_NUMBER']);
            preferences.setString(
                'profile_image', userDetailsResponseData['PROFILE_IMAGE']);
            preferences.setString(
                'image_storage', userDetailsResponseData['IMAGE_STORAGE']);
            preferences.setString('status', userDetailsResponseData['STATUS']);
            preferences.setString(
                'created_at', userDetailsResponseData['CREATED_AT']);
            if (userDetailsResponseData['STATUS'] != "ACTIVE") {
              responseMessage = ResponseMessage(
                error: true,
                unauthorized: false,
                message: "This account is disabled",
              );
              _isLoading = false;
              notifyListeners();
              return responseMessage;
            }
            if (userDetailsResponseData['IS_VALID_NUMBER'] == false) {
              responseMessage = ResponseMessage(
                error: false,
                unauthorized: false,
                message: "This account is not verified",
              );
              _isLoading = false;
              notifyListeners();
              return responseMessage;
            }
            await sessionDetails();
            responseMessage = ResponseMessage(
              error: false,
              unauthorized: false,
              message: "Successful logged in",
            );
          } catch (e) {
            responseMessage = ResponseMessage(
              error: true,
              unauthorized: false,
              message: "Failed to get user details",
            );
            _isLoading = false;
            notifyListeners();
            return responseMessage;
          }
        } else if (responseData.containsKey('ERROR') &&
            responseData.containsKey('MESSAGE')) {
          List<String> messages = responseData['MESSAGE'];
          messages.forEach((message) {
            responseMessage = ResponseMessage(
              error: responseData['ERROR'],
              message: message,
              unauthorized: false,
            );
          });
        } else {
          responseMessage = ResponseMessage(
            error: true,
            unauthorized: false,
            message: "Failed to create an account",
          );
        }
        _isLoading = false;
        notifyListeners();
        return responseMessage;
      } else if (response.statusCode == 400) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('ERROR') &&
            responseData.containsKey('MESSAGE')) {
          responseMessage = ResponseMessage(
            error: true,
            unauthorized: false,
            message: "Invalid email/phone number or password",
          );
        }
        _isLoading = false;
        notifyListeners();
        return responseMessage;
      } else if (response.statusCode == 401) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('ERROR') &&
            responseData.containsKey('MESSAGE')) {
          responseMessage = ResponseMessage(
            error: true,
            unauthorized: false,
            message: "Invalid email/phone number or password",
          );
        }
        _isLoading = false;
        notifyListeners();
        return responseMessage;
      } else if (response.statusCode == 500) {
        responseMessage = ResponseMessage(
          error: true,
          unauthorized: false,
          message: "Server error",
        );
        _isLoading = false;
        notifyListeners();
        return responseMessage;
      }
      _isLoading = false;
      notifyListeners();
      return responseMessage;
    } catch (e) {
      responseMessage = ResponseMessage(
        error: true,
        unauthorized: false,
        message: "Something went wrong, retry",
      );
      _isLoading = false;
      notifyListeners();
      return responseMessage;
    }
  }

  ///
  /// Get user details
  ///
  Future<ResponseMessage> updateLocalUserDetails() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    ResponseMessage responseMessage;

    String? tokenType = preferences.getString('token_type');
    String? accessToken = preferences.getString('access_token');

    ///
    /// Get user details after login
    ///
    try {
      http.Response userDetailsResponse;
      userDetailsResponse =
          await http.get(Uri.parse('$baseURL/api/user'), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': '$tokenType ' + '$accessToken',
      });
      final Map<String, dynamic> userDetailsResponseData =
          json.decode(userDetailsResponse.body);

      preferences.setInt('id', userDetailsResponseData['ID']);
      preferences.setString('first_name',
          userDetailsResponseData['FNAME'].toString().capitalize());
      preferences.setString('middle_name',
          userDetailsResponseData['MNAME'].toString().capitalize());
      preferences.setString('last_name',
          userDetailsResponseData['LNAME'].toString().capitalize());
      preferences.setString('username', userDetailsResponseData['USER_NAME']);
      preferences.setString('phone', userDetailsResponseData['PHONE_NUMBER']);
      preferences.setString('gender', userDetailsResponseData['GENDER']);
      preferences.setString('dob', userDetailsResponseData['DATE_OF_BIRTH']);
      preferences.setString('email', userDetailsResponseData['EMAIL']);
      preferences.setString('age', userDetailsResponseData['AGE']);
      preferences.setBool(
          'is_valid_email', userDetailsResponseData['IS_VALID_EMAIL']);
      preferences.setBool(
          'is_valid_number', userDetailsResponseData['IS_VALID_NUMBER']);
      preferences.setString(
          'profile_image', userDetailsResponseData['PROFILE_IMAGE']);
      preferences.setString(
          'image_storage', userDetailsResponseData['IMAGE_STORAGE']);
      preferences.setString('status', userDetailsResponseData['STATUS']);
      preferences.setString(
          'created_at', userDetailsResponseData['CREATED_AT']);

      /// AuthUserDetails
      if (userDetailsResponseData['STATUS'] != "ACTIVE") {
        responseMessage = ResponseMessage(
          error: true,
          unauthorized: false,
          message: "This account is disabled",
        );
        _isLoading = false;
        notifyListeners();
        return responseMessage;
      }
      if (userDetailsResponseData['IS_VALID_NUMBER'] == false) {
        responseMessage = ResponseMessage(
          error: false,
          unauthorized: false,
          message: "This phone number is not verified",
        );
        _isLoading = false;
        notifyListeners();
        return responseMessage;
      }

      responseMessage = ResponseMessage(
        error: false,
        unauthorized: false,
        message: "Successful",
      );
      _isLoading = false;
      notifyListeners();
      return responseMessage;
    } catch (e) {
      responseMessage = ResponseMessage(
        error: true,
        unauthorized: false,
        message: "Failed to get user details",
      );
      _isLoading = false;
      UserDetailsProvider().setUserDetails();
      notifyListeners();
      return responseMessage;
    }
  }

  /// Auto Authenticate
  ///
  Future<ResponseMessage> autoAuthenticate() async {
    late ResponseMessage responseMessage;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('access_token');
    String? status = preferences.getString('status');
    bool? isValidNumber = preferences.getBool('is_valid_number');
    String? expiryTimeString = preferences.getString('expiryTime');
    bool? sessionSent = preferences.getBool('is_session_sent');
    _isLoading = true;
    notifyListeners();
    if (token != null && expiryTimeString != null) {
      final DateTime now = DateTime.now();
      final parsedExpiryTime = DateTime.parse(expiryTimeString);
      if (parsedExpiryTime.isBefore(now) ||
          isValidNumber == false ||
          status != "ACTIVE") {
        /// Auto logout=
        logout();
        _isLoading = false;
        notifyListeners();
        responseMessage = ResponseMessage(
          error: true,
          unauthorized: false,
          message:
              "User token expired or phone number is not verified, login again",
        );
      } else {
        int tokenLifespan = parsedExpiryTime.difference(now).inSeconds;
        setAuthTimeout(tokenLifespan);
        if (sessionSent != true) {
          await sessionDetails();
        }
        responseMessage = ResponseMessage(
          error: false,
          unauthorized: false,
          message: "Active access token",
        );
      }

      _isLoading = false;
      notifyListeners();
      return responseMessage;
    } else {
      responseMessage = ResponseMessage(
        error: true,
        unauthorized: false,
        message: "Invalid access token, sign in",
      );
      _isLoading = false;
      notifyListeners();
      return responseMessage;
    }
  }

  ///
  ///  Auth Timeout
  ///

  void setAuthTimeout(int time) {
    Timer(Duration(seconds: time), logout);
  }

  ///
  /// Logout
  ///

  Future<bool> logout() async {
    _isLoading = true;
    notifyListeners();

    /// TODO
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    _isLoading = false;
    notifyListeners();
    return true;
  }

  ///
  /// Verify phone number
  /// OTP Code
  ///
  Future<ResponseMessage> verifyPhone(
      {required VerifyPhoneDetails verifyPhoneDetails}) async {
    late ResponseMessage responseMessage;
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    _isLoading = true;
    notifyListeners();
    try {
      String? tokenType = preferences.getString('token_type');
      String? accessToken = preferences.getString('access_token');
      final Map<String, dynamic> verifyDetails = {
        'otp': verifyPhoneDetails.otp,
        'phone_number': verifyPhoneDetails.phone
      };
      http.Response verifyPhoneResponse;
      if (tokenType != null &&
          accessToken != null &&
          tokenType != "" &&
          accessToken != "") {
        verifyPhoneResponse = await http.post(
            Uri.parse('$baseURL/api/verify/phone'),
            body: json.encode(verifyDetails),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': '$tokenType ' + accessToken,
            });
        if (verifyPhoneResponse.statusCode == 200) {
          final Map<String, dynamic> responseData =
              json.decode(verifyPhoneResponse.body);

          if (responseData.containsKey('ERROR') &&
              responseData.containsKey('MESSAGE')) {
            responseMessage = ResponseMessage(
              error: responseData['ERROR'],
              message: responseData['MESSAGE'],
              unauthorized: false,
            );
            if (responseData['ERROR'] == false) {
              /// Update Valid Number
              preferences.setBool('is_valid_number', true);
            }
          } else {
            responseMessage = ResponseMessage(
              error: true,
              unauthorized: false,
              message: "Failed to verify your phone number",
            );
          }
        } else if (verifyPhoneResponse.statusCode == 401) {
          responseMessage = ResponseMessage(
            error: true,
            message: "Unauthorized user",
            unauthorized: true,
          );
        } else {
          final Map<String, dynamic> responseData =
              json.decode(verifyPhoneResponse.body);
          if (responseData.containsKey('ERROR') &&
              responseData.containsKey('MESSAGE')) {
            List<dynamic> messages = responseData['MESSAGE'];
            messages.forEach((message) {
              responseMessage = ResponseMessage(
                error: responseData['ERROR'],
                message: message,
                unauthorized: false,
              );
            });
          } else {
            responseMessage = ResponseMessage(
              error: true,
              unauthorized: false,
              message: "Verification failed",
            );
          }
        }
      } else {
        /// No Access token or token type found
        responseMessage = ResponseMessage(
          error: true,
          unauthorized: false,
          message: "Invalid access token or token type",
        );
      }
      _isLoading = false;
      notifyListeners();
      return responseMessage;
    } catch (e) {
      responseMessage = ResponseMessage(
        error: true,
        unauthorized: false,
        message: "Something went wrong, retry",
      );
      _isLoading = false;
      notifyListeners();
      return responseMessage;
    }
  }

  ///
  /// Resend OTP Code
  ///
  Future<ResponseMessage> resendOTPCode({required String phone}) async {
    late ResponseMessage responseMessage;

    _isLoading = true;
    notifyListeners();
    try {
      http.Response resendOTPCodeResponse;
      final Map<String, dynamic> _phone = {'phone_number': phone};
      resendOTPCodeResponse = await http.post(
          Uri.parse('$baseURL/api/v1/resend/otp/code'),
          body: json.encode(_phone),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          });

      if (resendOTPCodeResponse.statusCode == 200) {
        final Map<String, dynamic> responseData =
            json.decode(resendOTPCodeResponse.body);

        if (responseData.containsKey('ERROR') &&
            responseData.containsKey('MESSAGE')) {
          responseMessage = ResponseMessage(
            error: responseData['ERROR'],
            message: responseData['MESSAGE'],
            unauthorized: false,
          );
        } else {
          responseMessage = ResponseMessage(
            error: true,
            unauthorized: false,
            message: "Failed to resend OTP",
          );
        }
      } else if (resendOTPCodeResponse.statusCode == 401) {
        responseMessage = ResponseMessage(
          error: true,
          message: "Unauthorized user",
          unauthorized: true,
        );
      } else {
        final Map<String, dynamic> responseData =
            json.decode(resendOTPCodeResponse.body);
        if (responseData.containsKey('ERROR') &&
            responseData.containsKey('MESSAGE')) {
          List<String> messages = responseData['MESSAGE'];
          messages.forEach((message) {
            responseMessage = ResponseMessage(
              error: responseData['ERROR'],
              message: message,
              unauthorized: false,
            );
          });
        } else {
          responseMessage = ResponseMessage(
            error: true,
            unauthorized: false,
            message: "Resend OTP failed",
          );
        }
      }
      _isLoading = false;
      notifyListeners();
      return responseMessage;
    } catch (e) {
      responseMessage = ResponseMessage(
        error: true,
        unauthorized: false,
        message: "Something went wrong, retry",
      );
      _isLoading = false;
      notifyListeners();
      return responseMessage;
    }
  }

  ///
  /// Forget password
  /// Generate forget password get OTP
  /// OTP code
  ///
  Future<ResponseMessage> generateForgetPasswordOTPCode(
      {required String phone}) async {
    late ResponseMessage responseMessage;
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    _isLoading = true;
    notifyListeners();
    try {
      http.Response resendOTPCodeResponse;
      final Map<String, dynamic> _phone = {'phone_number': phone};
      resendOTPCodeResponse = await http.post(
          Uri.parse('$baseURL/api/v1/generate/forgot/password/otp'),
          body: json.encode(_phone),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          });

      if (resendOTPCodeResponse.statusCode == 200) {
        final Map<String, dynamic> responseData =
            json.decode(resendOTPCodeResponse.body);

        if (responseData.containsKey('ERROR') &&
            responseData.containsKey('MESSAGE') &&
            responseData.containsKey('USER_ID')) {
          preferences.setString("phone", phone);
          preferences.setInt("user_id", responseData['USER_ID']);
          responseMessage = ResponseMessage(
            error: responseData['ERROR'],
            message: responseData['MESSAGE'],
            unauthorized: false,
          );
        } else {
          responseMessage = ResponseMessage(
            error: true,
            unauthorized: false,
            message: "Failed verify this phone number, retry",
          );
        }
      } else if (resendOTPCodeResponse.statusCode == 401) {
        responseMessage = ResponseMessage(
          error: true,
          message: "Unauthorized user",
          unauthorized: true,
        );
      } else if (resendOTPCodeResponse.statusCode == 400) {
        final Map<String, dynamic> responseData =
            json.decode(resendOTPCodeResponse.body);
        if (responseData.containsKey('ERROR') &&
            responseData.containsKey('MESSAGE')) {
          List<String> messages = responseData['MESSAGE'];
          messages.forEach((message) {
            responseMessage = ResponseMessage(
              error: responseData['ERROR'],
              message: message,
              unauthorized: false,
            );
          });
        } else {
          responseMessage = ResponseMessage(
            error: true,
            unauthorized: false,
            message: "Bad request, invalid phone number entered",
          );
        }
      } else {
        final Map<String, dynamic> responseData =
            json.decode(resendOTPCodeResponse.body);
        if (responseData.containsKey('ERROR') &&
            responseData.containsKey('MESSAGE')) {
          List<String> messages = responseData['MESSAGE'];
          messages.forEach((message) {
            responseMessage = ResponseMessage(
              error: responseData['ERROR'],
              message: message,
              unauthorized: false,
            );
          });
        } else {
          responseMessage = ResponseMessage(
            error: true,
            unauthorized: false,
            message: "Something went wrong, retry",
          );
        }
      }
      _isLoading = false;
      notifyListeners();
      return responseMessage;
    } catch (e) {
      responseMessage = ResponseMessage(
        error: true,
        unauthorized: false,
        message: "Something went wrong, retry",
      );
      _isLoading = false;
      notifyListeners();
      return responseMessage;
    }
  }

  ///
  /// Verify Reset Password OTP Code
  ///
  Future<ResponseMessage> verifyResetPasswordOTPCode(
      {required VerifyResetPasswordOTPDetails
          verifyResetPasswordOTPDetails}) async {
    late ResponseMessage responseMessage;
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    _isLoading = true;
    notifyListeners();
    try {
      final Map<String, dynamic> verifyDetails = {
        'otp': verifyResetPasswordOTPDetails.otp,
        'phone_number': verifyResetPasswordOTPDetails.phone,
        'user_id': verifyResetPasswordOTPDetails.userID
      };
      http.Response verifyPhoneResponse;
      verifyPhoneResponse = await http.post(
          Uri.parse('$baseURL/api/v1/verify/otp/reset/password'),
          body: json.encode(verifyDetails),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          });
      if (verifyPhoneResponse.statusCode == 200) {
        final Map<String, dynamic> responseData =
            json.decode(verifyPhoneResponse.body);

        if (responseData.containsKey('ERROR') &&
            responseData.containsKey('MESSAGE')) {
          responseMessage = ResponseMessage(
            error: responseData['ERROR'],
            message: responseData['MESSAGE'],
            unauthorized: false,
          );
          if (responseData['ERROR'] == false) {
            /// Update Valid Number
            preferences.setBool('is_valid_number', true);
          }
        } else {
          responseMessage = ResponseMessage(
            error: true,
            unauthorized: false,
            message: "Failed to verify your phone number",
          );
        }
      } else if (verifyPhoneResponse.statusCode == 401) {
        responseMessage = ResponseMessage(
          error: true,
          message: "Unauthorized user",
          unauthorized: true,
        );
      } else {
        final Map<String, dynamic> responseData =
            json.decode(verifyPhoneResponse.body);
        if (responseData.containsKey('ERROR') &&
            responseData.containsKey('MESSAGE')) {
          List<String> messages = responseData['MESSAGE'];
          messages.forEach((message) {
            responseMessage = ResponseMessage(
              error: responseData['ERROR'],
              message: message,
              unauthorized: false,
            );
          });
        } else {
          responseMessage = ResponseMessage(
            error: true,
            unauthorized: false,
            message: "Verification failed",
          );
        }
      }
      _isLoading = false;
      notifyListeners();
      return responseMessage;
    } catch (e) {
      responseMessage = ResponseMessage(
        error: true,
        unauthorized: false,
        message: "Something went wrong, retry",
      );
      _isLoading = false;
      notifyListeners();
      return responseMessage;
    }
  }

  ///
  /// Verify Reset Password OTP Code
  ///
  Future<ResponseMessage> resetPasswordSetNewPassword(
      {required ResetPasswordNewPasswordDetails
          resetPasswordNewPasswordDetails}) async {
    late ResponseMessage responseMessage;
    _isLoading = true;
    notifyListeners();
    try {
      final Map<String, dynamic> newPasswordDetails = {
        'otp_code': resetPasswordNewPasswordDetails.otp,
        'password': resetPasswordNewPasswordDetails.password,
        'user_id': resetPasswordNewPasswordDetails.userID
      };
      http.Response setNewPasswordResponse;
      setNewPasswordResponse = await http.post(
          Uri.parse('$baseURL/api/v1/update/password'),
          body: json.encode(newPasswordDetails),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          });
      if (setNewPasswordResponse.statusCode == 200) {
        final Map<String, dynamic> responseData =
            json.decode(setNewPasswordResponse.body);

        if (responseData.containsKey('ERROR') &&
            responseData.containsKey('MESSAGE')) {
          responseMessage = ResponseMessage(
            error: responseData['ERROR'],
            message: responseData['MESSAGE'],
            unauthorized: false,
          );
        } else {
          responseMessage = ResponseMessage(
            error: true,
            unauthorized: false,
            message: "Failed to set new password",
          );
        }
      } else if (setNewPasswordResponse.statusCode == 401) {
        responseMessage = ResponseMessage(
          error: true,
          message: "Unauthorized user",
          unauthorized: true,
        );
      } else {
        final Map<String, dynamic> responseData =
            json.decode(setNewPasswordResponse.body);
        if (responseData.containsKey('ERROR') &&
            responseData.containsKey('MESSAGE')) {
          List<String> messages = responseData['MESSAGE'];
          messages.forEach((message) {
            responseMessage = ResponseMessage(
              error: responseData['ERROR'],
              message: message,
              unauthorized: false,
            );
          });
        } else {
          responseMessage = ResponseMessage(
            error: true,
            unauthorized: false,
            message: "Failed to set new password",
          );
        }
      }
      _isLoading = false;
      notifyListeners();
      return responseMessage;
    } catch (e) {
      responseMessage = ResponseMessage(
        error: true,
        unauthorized: false,
        message: "Something went wrong, retry",
      );
      _isLoading = false;
      notifyListeners();
      return responseMessage;
    }
  }

  ///
  /// Edit profile
  ///
  Future<ResponseMessage> updateProfile(
      {required UpdateProfileDetails updateProfileDetails}) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    late ResponseMessage responseMessage;
    String? tokenType = preferences.getString('token_type');
    String? token = preferences.getString('access_token');
    _isLoading = true;
    notifyListeners();

    if (tokenType != null && token != null) {
      try {
        http.Response updateProfileResponse;
        updateProfileResponse = await http.post(
          Uri.parse('$baseURL/api/update/profile'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': '$tokenType ' + '$token',
          },
          body: json.encode({
            "first_name": updateProfileDetails.firstName,
            "middle_name": updateProfileDetails.middleName,
            "last_name": updateProfileDetails.lastName,
            "phone_number": updateProfileDetails.phone,
            "username": updateProfileDetails.username,
            "email": updateProfileDetails.email,
            "gender": updateProfileDetails.gender,
            "date_of_birth": updateProfileDetails.dob
          }),
        );
        if (updateProfileResponse.statusCode == 200) {
          await updateLocalUserDetails();

          final Map<String, dynamic> responseData =
              json.decode(updateProfileResponse.body);
          if (responseData.containsKey('ERROR') &&
              responseData.containsKey('MESSAGE')) {
            responseMessage = ResponseMessage(
              error: responseData['ERROR'],
              message: responseData['MESSAGE'],
              unauthorized: false,
            );
            _isLoading = false;
            notifyListeners();
            return responseMessage;
          } else {
            responseMessage = ResponseMessage(
              error: true,
              unauthorized: false,
              message: "Failed to update profile details",
            );
            _isLoading = false;
            notifyListeners();
            return responseMessage;
          }
        } else if (updateProfileResponse.statusCode == 401) {
          responseMessage = ResponseMessage(
            error: true,
            message: "Unauthorized user",
            unauthorized: true,
          );
          _isLoading = false;
          notifyListeners();
          return responseMessage;
        } else if (updateProfileResponse.statusCode == 400) {
          final Map<String, dynamic> responseData =
              json.decode(updateProfileResponse.body);
          if (responseData.containsKey('ERROR') &&
              responseData.containsKey('MESSAGE')) {
            List<dynamic> messages = responseData['MESSAGE'];
            messages.forEach((message) {
              responseMessage = ResponseMessage(
                error: responseData['ERROR'],
                message: message,
                unauthorized: false,
              );
            });
            _isLoading = false;
            notifyListeners();
            return responseMessage;
          } else {
            responseMessage = ResponseMessage(
              error: true,
              unauthorized: false,
              message: "Failed to update profile details",
            );
            _isLoading = false;
            notifyListeners();
            return responseMessage;
          }
        } else {
          responseMessage = ResponseMessage(
            error: true,
            unauthorized: false,
            message: "Something went wrong",
          );
          _isLoading = false;
          notifyListeners();
          return responseMessage;
        }
      } catch (e) {
        responseMessage = ResponseMessage(
          error: true,
          unauthorized: false,
          message: "Something went wrong, retry",
        );
        _isLoading = false;
        notifyListeners();
        return responseMessage;
      }
    } else {
      responseMessage = ResponseMessage(
        error: true,
        unauthorized: false,
        message: "Something went wrong, login again",
      );
      _isLoading = false;
      notifyListeners();
      return responseMessage;
    }
  }

  ///
  /// Register User Session
  /// TODO
  ///

  sessionDetails() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getBool("is_location_sent") == true) {
      print("return return return return");
      return;
    }

    ///
    /// Check if location permission is granted
    ///
    // bool serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (true) {
      sendUserSessionDetails(
          position: PositionDummy(
        longitude: 0.000000,
        latitude: 0.000000,
      ));
    } else {
    }
  }

  sendUserSessionDetails({required PositionDummy position}) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    late Map<String, dynamic> deviceData;
    String platformIMEI = "";

    if (preferences.getBool("is_location_sent") == true) {
      return;
    } else {
      var phonePermissionStatus = await Permission.phone.status;
      if (phonePermissionStatus == PermissionStatus.denied) {
        await Permission.phone.request();
      }

      try {
        /// Get device IMEI
        platformIMEI = await DeviceInformation.deviceIMEINumber;

        /// Read Android Build Data
        Map<String, dynamic> _readAndroidBuildData(
            AndroidDeviceInfo build, String platformIMEI) {
          return <String, dynamic>{
            "device": build.device,
            "operating_system": "---",
            "system_version": "---",
            "model": build.model,
            "localized_model": "---",
            "identifier_for_vendor": "---",
            "is_physical_device":
                build.isPhysicalDevice != null ? "true" : "false",
            "utsname_sysname": "---",
            "utsname_nodename": "---",
            "utsname_release": "---",
            "utsname_version": "---",
            "utsname_machine": "---",
            "type": "ANDROID",
            "version_security_patch": build.version.securityPatch,
            "version_sdk_int": build.version.sdkInt.toString(),
            "version_release": build.version.release,
            "version_preview_sdk_int": build.version.previewSdkInt.toString(),
            "version_incremental": build.version.incremental,
            "version_codename": build.version.codename,
            "version_base_os": '---',
            "board": build.board,
            "bootloader": build.bootloader,
            "display": build.display.toString(),
            "fingerprint": build.fingerprint,
            "hardware": build.hardware,
            "host": build.host,
            "build_id": build.id,
            "manufacturer": build.manufacturer,
            "product": build.product,
            "supported32BitAbis": json.encode(build.supported32BitAbis),
            "supported64BitAbis": json.encode(build.supported64BitAbis),
            "supportedAbis": json.encode(build.supportedAbis),
            "tags": build.tags,
            "build_type": build.type,
            "android_id": build.androidId,
            "system_features": '---',
            "imei": platformIMEI,
            "latitude": position.latitude,
            "longitude": position.longitude
          };
        }

        /// Read IOS Build Data
        Map<String, dynamic> _readIosDeviceInfo(
            IosDeviceInfo data, String platformIMEI) {
          return <String, dynamic>{
            "device": data.name,
            "operating_system": data.systemName,
            "system_version": data.systemVersion,
            "model": data.model,
            "localized_model": data.localizedModel,
            "identifier_for_vendor": data.identifierForVendor,
            "is_physical_device": data.isPhysicalDevice.toString(),
            "utsname_sysname": data.utsname.sysname,
            "utsname_nodename": data.utsname.nodename,
            "utsname_release": data.utsname.release,
            "utsname_version": data.utsname.version,
            "utsname_machine": data.utsname.machine,
            "type": "IOS",
            "version_security_patch": "---",
            "version_sdk_int": "sdk 1",
            "version_release": "release 1",
            "version_preview_sdk_int": "---",
            "version_incremental": "---",
            "version_codename": "---",
            "version_base_os": "---",
            "board": "---",
            "bootloader": "---",
            "display": "---",
            "fingerprint": "---",
            "hardware": "---",
            "host": "---",
            "build_id": "---",
            "manufacturer": "---",
            "product": "---",
            "supported32BitAbis": "---",
            "supported64BitAbis": "---",
            "supportedAbis": "---",
            "tags": "---",
            "build_type": "---",
            "android_id": "---",
            "system_features": "---",
            "imei": platformIMEI == "" ? "---" : platformIMEI,
            "latitude": position.latitude,
            "longitude": position.longitude
          };
        }

        /// Get data basing on Platform
        if (Platform.isAndroid) {
          deviceData = _readAndroidBuildData(
              await deviceInfoPlugin.androidInfo, platformIMEI);
        } else if (Platform.isIOS) {
          deviceData =
              _readIosDeviceInfo(await deviceInfoPlugin.iosInfo, platformIMEI);
        } else {
          throw "Invalid platform found";
        }

        String? tokenType = preferences.getString('token_type');
        String? token = preferences.getString('access_token');

        ///
        http.Response userSessionDetails = await http.post(
            Uri.parse('$baseURL/api/add/user/session/details'),
            body: json.encode(deviceData),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': '$tokenType ' + token!,
            });
        final Map<String, dynamic> responseData =
            json.decode(userSessionDetails.body);
        if (responseData.containsKey('MESSAGE') &&
            responseData.containsKey('ERROR')) {
          if (responseData['ERROR'] == false) {
            print("is_session_sent");
            preferences.setBool('is_session_sent', true);
          } else {}
        }
        if (preferences.getBool('is_session_sent') == true) {
          return;
        } else {
          Timer(Duration(seconds: 60), sessionDetails);
        }
      } catch (e) {
        var status = await Permission.phone.status;
        if (status.isDenied || status.isPermanentlyDenied) {
          // openAppSettings();
          // await phonePermission.request();
          print(_sessionSent);
          _sessionSent = !_sessionSent;
          notifyListeners();
        }
        Timer(Duration(seconds: 60), sessionDetails);
      }
    }
  }

  ///
  ///
  ///
  Future<ResponseMessage> changePassword(
      {required ChangePasswordDetails changePasswordDetails}) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    String? tokenType = preferences.getString('token_type');
    String? token = preferences.getString('access_token');
    late ResponseMessage responseMessage;
    _isLoading = true;
    notifyListeners();
    try {
      http.Response changePasswordResponse;
      changePasswordResponse = await http.post(
        Uri.parse('$baseURL/api/change/password'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': '$tokenType ' + '$token',
        },
        body: json.encode({
          "old_password": changePasswordDetails.oldPassword,
          "new_password": changePasswordDetails.newPassword,
          "confirm_new_password": changePasswordDetails.newPasswordConfirm,
        }),
      );

      print(changePasswordResponse.body);
      if (changePasswordResponse.statusCode == 200) {
        await updateLocalUserDetails();

        final Map<String, dynamic> responseData =
            json.decode(changePasswordResponse.body);
        if (responseData.containsKey('ERROR') &&
            responseData.containsKey('MESSAGE')) {
          responseMessage = ResponseMessage(
            error: responseData['ERROR'],
            message: responseData['MESSAGE'],
            unauthorized: false,
          );
          _isLoading = false;
          notifyListeners();
          return responseMessage;
        } else {
          responseMessage = ResponseMessage(
            error: true,
            unauthorized: false,
            message: "Failed to change password",
          );
          _isLoading = false;
          notifyListeners();
          return responseMessage;
        }
      } else if (changePasswordResponse.statusCode == 401) {
        responseMessage = ResponseMessage(
          error: true,
          message: "Unauthorized user",
          unauthorized: true,
        );
        _isLoading = false;
        notifyListeners();
        return responseMessage;
      } else if (changePasswordResponse.statusCode == 400) {
        final Map<String, dynamic> responseData =
            json.decode(changePasswordResponse.body);
        if (responseData.containsKey('ERROR') &&
            responseData.containsKey('MESSAGE')) {
          List<dynamic> messages = responseData['MESSAGE'];
          messages.forEach((message) {
            responseMessage = ResponseMessage(
              error: responseData['ERROR'],
              message: message,
              unauthorized: false,
            );
          });
          _isLoading = false;
          notifyListeners();
          return responseMessage;
        } else {
          responseMessage = ResponseMessage(
            error: true,
            unauthorized: false,
            message: "Failed to update profile details",
          );
          _isLoading = false;
          notifyListeners();
          return responseMessage;
        }
      } else {
        responseMessage = ResponseMessage(
          error: true,
          unauthorized: false,
          message: "Something went wrong",
        );
        _isLoading = false;
        notifyListeners();
        return responseMessage;
      }
    } catch (e) {
      responseMessage = ResponseMessage(
        error: true,
        unauthorized: false,
        message: "Something went wrong",
      );
      _isLoading = false;
      notifyListeners();
      return responseMessage;
    }
  }

  ///
  /// Update Profile Image
  ///
  Future<ResponseMessage> updateProfileImage({required File image}) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    String? tokenType = preferences.getString('token_type');
    String? token = preferences.getString('access_token');
    late ResponseMessage responseMessage;
    _isLoading = true;
    notifyListeners();
    try {
      MultipartRequest request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseURL/api/update/profile/image'),
      );
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
      request.headers.addAll({
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json',
        'Authorization': '$tokenType ' + '$token',
      });
      final streamedResponse = await request.send();
      if (streamedResponse.statusCode == 200) {
        responseMessage = ResponseMessage(
          error: false,
          unauthorized: false,
          message: "Successful updated profile image",
        );
        await updateLocalUserDetails();
        _isLoading = false;
        notifyListeners();
        return responseMessage;
      } else if (streamedResponse.statusCode == 401) {
        responseMessage = ResponseMessage(
          error: true,
          message: "Unauthorized user",
          unauthorized: true,
        );
        _isLoading = false;
        notifyListeners();
        return responseMessage;
      } else {
        print("Failed:" + await streamedResponse.stream.bytesToString());
        responseMessage = ResponseMessage(
          error: true,
          unauthorized: false,
          message: "Failed to update profile image",
        );
        _isLoading = false;
        notifyListeners();
        return responseMessage;
      }
    } catch (e) {
      responseMessage = ResponseMessage(
        error: true,
        unauthorized: false,
        message: "Something went wrong, retry",
      );
      return responseMessage;
    }
  }

  ///
  /// Problem report
  ///
  Future<ResponseMessage> problemReport(
      {required ReportProblemDetails reportProblemDetails}) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    late ResponseMessage responseMessage;
    _isLoading = true;
    notifyListeners();
    try {
      MultipartRequest request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseURL/api/v1/user/report/problem'),
      );
      request.fields.addAll({
        'user_id': reportProblemDetails.id,
        'title': reportProblemDetails.title,
        'description': reportProblemDetails.description
      });
      request.files.add(await http.MultipartFile.fromPath(
          'image', reportProblemDetails.image.path));
      request.headers.addAll({
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json',
      });
      final streamedResponse = await request.send();
      if (streamedResponse.statusCode == 200) {
        responseMessage = ResponseMessage(
          error: false,
          unauthorized: false,
          message: "Successful sent report problem",
        );
        await updateLocalUserDetails();
        _isLoading = false;
        notifyListeners();
        return responseMessage;
      } else if (streamedResponse.statusCode == 401) {
        responseMessage = ResponseMessage(
          error: true,
          message: "Unauthorized user",
          unauthorized: true,
        );
        _isLoading = false;
        notifyListeners();
        return responseMessage;
      } else {
        print("Failed:" + await streamedResponse.stream.bytesToString());
        responseMessage = ResponseMessage(
          error: true,
          unauthorized: false,
          message: "Failed to sent report problem",
        );
        _isLoading = false;
        notifyListeners();
        return responseMessage;
      }
    } catch (e) {
      responseMessage = ResponseMessage(
        error: true,
        unauthorized: false,
        message: "Something went wrong, retry",
      );
      _isLoading = false;
      notifyListeners();
      return responseMessage;
    }
  }
}
