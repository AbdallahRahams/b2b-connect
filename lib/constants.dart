import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';

///
/// Application
///
const String appName = "B2BConnect";
const String packageName = 'com.b2b_connect.application';
const String buildVersion = "1.0.0";

/// Urls
const String baseURL = "https://usersb2b.aisafrica.org";
const String wholesalersURL = "http://b2bconnect.aisafrica.org";

///
/// Colors
///
const Color cPrimary = Color(0xff23312C);
// const Color cPrimary = Color(0xff006cc4); //NEW
const Color cSecondary = Color(0xff2D4C42);
const Color secondaryTextColor = Color(0xFF8D8D8E);
const Color cError = Colors.redAccent;
const Color cWarning = Colors.deepOrange;
const Color bgColor = Color(0xfffafafa);
const Color bgIconColor = Color(0x45465A);
const Color cTransparent = Colors.transparent;
const Color cSuccess = Color(0xFF43A047);
const Color cWhite = Colors.white;

///
Color cText1 = Colors.grey.shade800;
Color cText2 = Colors.grey.shade700;
Color cText3 = Colors.grey.shade600;
Color cText4 = Colors.grey.shade500;
Color cText5 = Colors.grey.shade400;
Color link = cPrimary;
Color divider1 = Colors.grey.shade700;
Color divider2 = Colors.grey.shade500;
Color divider3 = Colors.grey.shade200;
Color divider4 = Colors.grey.shade300;
Color error = Colors.redAccent.shade700;

/// AppBar
const bool centerTitle = false;
const bool floating = true;
const bool pinned = true;

/// Navigation
Color iconUnselected = Colors.grey.shade400;
Color iconSelected = Colors.indigoAccent.shade400;
Color likedIconColor = Colors.redAccent.shade100;

/// Toast colors
Color cToastSuccess = Colors.greenAccent.shade700;
Color cToastError = Colors.redAccent.shade400;
Color cToastDefault = cPrimary;
Color cToastNetwork = Colors.grey.shade700;

/// Ratings star colors
const starColor = const Color(0xffFCBC05);

/// Widgets Padding
const double p1 = 4;
const double p2 = 8;
const double p3 = 12;
const double p4 = 16;
const double p5 = 24;
const double p6 = 32;
const double p23 = 10;

/// Page content padding
const double pagePadding = 16;
const double defaultPadding = 16.0;
const double defaultBorderRadius = 12.0;

/// Button radius
const double btnRadius = 4;

///
const double mediaQueryBreakpoint = 365;

/// OTP form input decoration
UnderlineDecoration underlineDecoration = UnderlineDecoration(
  textStyle: TextStyle(fontSize: 20, color: cPrimary),
  colorBuilder: PinListenColorBuilder(
    cPrimary.withOpacity(0.2),
    cPrimary.withOpacity(0.6),
  ),
  bgColorBuilder: PinListenColorBuilder(
    cPrimary.withOpacity(0.05),
    cPrimary.withOpacity(0.1),
  ),
  gapSpace: 50,
  lineHeight: 50,
);
