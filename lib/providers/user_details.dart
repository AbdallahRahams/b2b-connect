import 'package:b2b_connect/models/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

class UserDetailsProvider extends ChangeNotifier {
  User? _user;
  User? get user => _user;
  UserDetailsProvider() {
    setUserDetails();
  }

  setUserDetails() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    int? userId = preferences.getInt("id");
    String firebaseMessageToken = "";

    User userFromSharedPreference = User(
      id: userId,
      firstname: preferences.getString("first_name"),
      middlename: preferences.getString("middle_name"),
      lastname: preferences.getString("last_name"),
      username: preferences.getString("username"),
      email: preferences.getString("email"),
      dob: preferences.getString("dob"),
      gender: preferences.getString("gender"),
      phoneNumber: preferences.getString("phone"),
      // age: preferences.getString("age"),
      status: preferences.getString("status"),
      profileImage: preferences.getString("profile_image"),
      imageStorage: preferences.getString("image_storage"),
      createdAt: preferences.getString("created_at"),
      isValidNumber: preferences.getBool("is_valid_number"),
      isValidEmail: preferences.getBool("is_valid_email"),
      firebaseMessageToken: firebaseMessageToken,
    );
    _user = userFromSharedPreference;
    notifyListeners();
  }
}
