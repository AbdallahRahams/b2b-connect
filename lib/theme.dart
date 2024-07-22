import 'package:b2b_connect/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData theme = lightTheme;

final lightTheme = ThemeData(
  primaryColor: cPrimary,
  brightness: Brightness.light,
  fontFamily: GoogleFonts.roboto().fontFamily,
  dividerColor: Colors.white54,
  appBarTheme: appBarTheme,
  splashColor: Colors.transparent,
  canvasColor: const Color(0xffffffff),
  scaffoldBackgroundColor: const Color(0xffffffff),
  dialogBackgroundColor: const Color(0xffffffff),
  highlightColor: const Color(0x09000000),
  scrollbarTheme: ScrollbarThemeData(
    thumbColor: MaterialStateProperty.all(
      Color(0x40404040),
    ),
  ),
  inputDecorationTheme: inputDecorationTheme,
  textTheme: TextTheme(
    bodyLarge: TextStyle(
      color: cText1,
      fontSize: 17,
    ),
    bodyMedium: TextStyle(
      color: cText2,
      fontSize: 14,
    ),
    bodySmall: TextStyle(
      color: cText3,
      fontSize: 12,
    ),
    headlineSmall: TextStyle(
      fontSize: 22,
    ),
    titleLarge: TextStyle(
      fontSize: 20,
      color: cText2,
    ),
    headlineMedium: TextStyle(
      fontSize: 26,
      color: ThemeData.light().textTheme.headlineSmall?.color,
    ),
  ), colorScheme: ThemeData(
    colorScheme: ColorScheme.fromSwatch()
        .copyWith(secondary: cPrimary.withOpacity(0.05)),
  ).colorScheme.copyWith(primary: cSecondary).copyWith(background: const Color(0xFFE5E5E9)),
);
InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
  isDense: true,

  contentPadding: EdgeInsets.symmetric(
    horizontal: p3,
    vertical: p23,
  ),
  labelStyle: TextStyle(
    fontSize: 14,
    height: 1,
  ),
  border: OutlineInputBorder(
    borderSide: BorderSide(
      color: cPrimary,
      width: 1,
    ),
    // borderRadius: BorderRadius.circular(btnRadius),
  ),
  // fillColor: cPrimary.withOpacity(0.03),
  // filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey.shade400,
      width: 1,
    ),
    // borderRadius: BorderRadius.circular(btnRadius),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: cPrimary,
      width: 1,
    ),
    // borderRadius: BorderRadius.circular(btnRadius),
  ),

  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: cError,
      width: 1,
    ),
    // borderRadius: BorderRadius.circular(btnRadius),
  ),
);
AppBarTheme appBarTheme = AppBarTheme(
  elevation: 0,
  backgroundColor: cPrimary,
  systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: cPrimary),
);
