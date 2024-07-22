import 'package:b2b_connect/screens/authentication/complete_details_social_register.dart';
import 'package:b2b_connect/screens/authentication/reset_password_otp.dart';
import 'package:b2b_connect/screens/authentication/verify_otp.dart';
import 'package:b2b_connect/screens/profile/change_password.dart';
import 'package:b2b_connect/screens/profile/edit_profile.dart';
import 'package:b2b_connect/screens/home_pages/home.dart';
import 'package:b2b_connect/screens/authentication/login.dart';
import 'package:b2b_connect/screens/authentication/register.dart';
import 'package:b2b_connect/screens/others/pre_splash.dart';
import 'package:b2b_connect/screens/profile/profile.dart';
import 'package:b2b_connect/screens/others/splash.dart';
import 'package:b2b_connect/screens/others/terms_and_conditions.dart';
import 'package:b2b_connect/screens/others/welcome.dart';
import 'package:b2b_connect/screens/authentication/reset_password.dart';
import 'package:b2b_connect/screens/report_problem.dart';
import 'package:flutter/material.dart';
import 'models/social_data.dart';

Map<String, Widget Function(BuildContext)> routes = {
  "/": (context) => const PreSplashScreen(),
  PreSplashScreen.route: (context) => const PreSplashScreen(),
  Splash.route: (context) => const Splash(),
  Welcome.route: (context) => const Welcome(),

  /// Authentication routes
  Login.route: (context) => const Login(),
  Register.route: (context) => const Register(),
  ResetPasswordWithNumber.route: (content) => const ResetPasswordWithNumber(),
  ResetPasswordOTP.route: (context) => const ResetPasswordOTP(),
  VerifyOTP.route: (context) => const VerifyOTP(),

  /// Main routes
  Home.route: (context) => const Home(),
  TermsAndConditions.route: (context) => const TermsAndConditions(),
  UserProfile.route: (context) => const UserProfile(),
  EditUserProfile.route: (context) => const EditUserProfile(),
  ChangePassword.route: (context) => const ChangePassword(),
  ReportProblem.route: (context) => const ReportProblem(),
};
final onGenerateRoute = (RouteSettings settings) {
  if (settings.name == CompleteDetailsSocialRegister.route) {
    final args = settings.arguments as SocialDataRegistration;
    return MaterialPageRoute(
      builder: (context) {
        return CompleteDetailsSocialRegister(
          socialDataRegistration: args,
        );
      },
    );
  }
  return null;
};
