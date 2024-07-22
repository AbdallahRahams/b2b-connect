import 'package:b2b_connect/components/button_loading_indicator.dart';
import 'package:b2b_connect/constants.dart';
import 'package:flutter/material.dart';

const double buttonHeight = 42;
const double buttonHeightSmall = 38;
const double btnFontSize = 15;
const double btnFontSizeSmall = 13;

class CustomMaterialButton {
  CustomMaterialButton();
  createButton(
      {required VoidCallback function,
      required String label,
      required String loadingLabel,
      bool loading = false}) {
    return MaterialButton(
      child: loading
          ? false
              ? LoadingIndicator(
                  size: btnFontSize,
                  stroke: 2,
                )
              : Text(
                  loadingLabel,
                  style: TextStyle(
                    fontSize: btnFontSize,
                    fontWeight: FontWeight.w400,
                  ),
                )
          : Text(
              label,
              style: TextStyle(
                fontSize: btnFontSize,
                fontWeight: FontWeight.w400,
              ),
            ),
      onPressed: loading ? null : function,
      minWidth: double.infinity,
      height: buttonHeight,
      textTheme: ButtonTextTheme.normal,
      disabledTextColor: Colors.white,
      textColor: Colors.white,
      color: cPrimary,
      elevation: 0,
      focusElevation: 5,
      highlightElevation: 5,
      disabledColor: cPrimary.withOpacity(0.6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(btnRadius),
      ),
    );
  }

  createCancelButton(
      {required VoidCallback function,
      required String label,
      required String loadingLabel,
      bool loading = false}) {
    return MaterialButton(
      child: loading
          ? Text(
              loadingLabel,
              style: TextStyle(
                fontSize: btnFontSize,
                fontWeight: FontWeight.w400,
              ),
            )
          : Text(
              label,
              style: TextStyle(
                fontSize: btnFontSize,
                fontWeight: FontWeight.w400,
              ),
            ),
      onPressed: loading ? null : function,
      minWidth: double.infinity,
      height: buttonHeight,
      textTheme: ButtonTextTheme.normal,
      disabledTextColor: Colors.white,
      textColor: cPrimary,
      color: cPrimary.withOpacity(0.05),
      elevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      disabledColor: cPrimary.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(btnRadius),
      ),
    );
  }

  createButtonSmall(
      {required VoidCallback function,
      required String label,
      required String loadingLabel,
      bool loading = false}) {
    return MaterialButton(
      child: loading
          ? Text(
              loadingLabel,
              style: TextStyle(
                fontSize: btnFontSizeSmall,
                fontWeight: FontWeight.w400,
              ),
            )
          : Text(
              label,
              style: TextStyle(
                fontSize: btnFontSizeSmall,
                fontWeight: FontWeight.w400,
              ),
            ),
      onPressed: loading ? null : function,
      textTheme: ButtonTextTheme.normal,
      disabledTextColor: Colors.white,
      textColor: Colors.white,
      color: cPrimary,
      elevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      disabledColor: cPrimary.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(btnRadius),
      ),
    );
  }

  createCancelButtonSmall(
      {required VoidCallback function,
      required String label,
      required String loadingLabel,
      bool loading = false}) {
    return MaterialButton(
      child: loading
          ? Text(
              loadingLabel,
              style: TextStyle(
                fontSize: btnFontSizeSmall,
                fontWeight: FontWeight.w400,
              ),
            )
          : Text(
              label,
              style: TextStyle(
                fontSize: btnFontSizeSmall,
                fontWeight: FontWeight.w400,
              ),
            ),
      onPressed: loading ? null : function,
      minWidth: double.infinity,
      height: buttonHeightSmall,
      textTheme: ButtonTextTheme.normal,
      disabledTextColor: Colors.white,
      textColor: cPrimary,
      color: cPrimary.withOpacity(0.1),
      elevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      disabledColor: cPrimary.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(btnRadius),
      ),
    );
  }

  createIconTextButtonSmall(
      {required VoidCallback function,
      required IconData icon,
      required String label,
      required String loadingLabel,
      bool loading = false}) {
    return MaterialButton(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Column(
          children: [
            Icon(icon),
            const SizedBox(
              height: 8,
            ),
            loading
                ? Text(
                    loadingLabel,
                    style: TextStyle(
                      fontSize: btnFontSizeSmall,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                : Text(
                    label,
                    style: TextStyle(
                      fontSize: btnFontSizeSmall,
                      fontWeight: FontWeight.w400,
                    ),
                  )
          ],
        ),
      ),
      onPressed: loading ? null : function,
      height: buttonHeightSmall,
      textTheme: ButtonTextTheme.normal,
      disabledTextColor: Colors.white,
      textColor: Colors.white,
      color: cPrimary,
      elevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      disabledColor: cPrimary.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(btnRadius),
      ),
    );
  }
}

class CustomOutlineButton {
  CustomOutlineButton();
  createButton(
      {required VoidCallback function,
      required String label,
      required String loadingLabel,
      bool loading = false}) {
    return OutlinedButton(
      child: loading
          ? Text(
              loadingLabel,
              style: TextStyle(
                fontSize: btnFontSize,
                fontWeight: FontWeight.w400,
              ),
            )
          : Text(
              label,
              style: TextStyle(
                fontSize: btnFontSize,
                fontWeight: FontWeight.w400,
              ),
            ),
      onPressed: loading ? null : function,
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(
            horizontal: p4 * 2,
            vertical: p2,
          ),
        ),
        foregroundColor: MaterialStateProperty.all<Color?>(cPrimary),
        side: MaterialStateProperty.all<BorderSide?>(
          BorderSide(color: cPrimary),
        ),
        minimumSize: MaterialStateProperty.all<Size?>(
          Size(buttonHeight, buttonHeight),
        ),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(btnRadius),
            ),
          ),
        ),
      ),
    );
  }

  createButtonWithIcon(
      {required VoidCallback function,
      required String label,
      required String loadingLabel,
      required Widget child,
      bool loading = false}) {
    return OutlinedButton(
      child: loading
          ? Row(
              children: [
                child,
                Text(
                  loadingLabel,
                  style: TextStyle(
                    fontSize: btnFontSize,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                child,
                Expanded(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: btnFontSize,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
      onPressed: loading ? null : function,
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(
            horizontal: p4 * 2,
            vertical: p1,
          ),
        ),
        foregroundColor: MaterialStateProperty.all<Color?>(cPrimary),
        side: MaterialStateProperty.all<BorderSide?>(
          BorderSide(color: cPrimary),
        ),
        minimumSize: MaterialStateProperty.all<Size?>(
          Size(buttonHeight, buttonHeight),
        ),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(btnRadius),
            ),
          ),
        ),
      ),
    );
  }

  createButtonSmall(
      {required VoidCallback function,
      required String label,
      required String loadingLabel,
      bool loading = false}) {
    return OutlinedButton(
      child: loading
          ? Text(
              loadingLabel,
              style: TextStyle(
                fontSize: btnFontSizeSmall,
                fontWeight: FontWeight.w400,
              ),
            )
          : Text(
              label,
              style: TextStyle(
                fontSize: btnFontSizeSmall,
                fontWeight: FontWeight.w400,
              ),
            ),
      onPressed: loading ? null : function,
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(
            horizontal: p4,
            vertical: p1,
          ),
        ),
        foregroundColor: MaterialStateProperty.all<Color?>(cPrimary),
        side: MaterialStateProperty.all<BorderSide?>(
          BorderSide(color: cPrimary),
        ),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(btnRadius),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextButton {
  CustomTextButton();
  createTextButton(
      {required VoidCallback function,
      required String label,
      required String loadingLabel,
      bool loading = false}) {
    return TextButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
      ),
      child: loading
          ? Text(
              loadingLabel,
              style: TextStyle(
                fontSize: btnFontSize,
                fontWeight: FontWeight.w400,
              ),
            )
          : Text(
              label,
              style: TextStyle(
                fontSize: btnFontSize,
                fontWeight: FontWeight.w400,
              ),
            ),
      onPressed: loading ? null : function,
    );
  }

  createSmallTextButton(
      {required VoidCallback function,
      required String label,
      required String loadingLabel,
      bool loading = false}) {
    return TextButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
      ),
      child: loading
          ? Text(
              loadingLabel,
              style: TextStyle(
                fontSize: btnFontSizeSmall,
                fontWeight: FontWeight.w400,
              ),
            )
          : Text(
              label,
              style: TextStyle(
                fontSize: btnFontSizeSmall,
                fontWeight: FontWeight.w400,
              ),
            ),
      onPressed: loading ? null : function,
    );
  }
}
