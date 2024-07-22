import 'package:flutter/material.dart';
import '../constants.dart';
import 'countries.dart';

class CustomDialog extends StatelessWidget {
  final String? title;
  final Widget? content;
  final String? dismissText;
  final String? actionBtnText;
  final Color? color;
  final VoidCallback? actionFunction;
  const CustomDialog({
    Key? key,
    this.title,
    this.color,
    this.content,
    this.dismissText,
    this.actionBtnText,
    this.actionFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(p5),
      titleTextStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.bold,
            color: cText1,
            fontSize: 18,
          ),
      title: title != null
          ? Container(
              width: MediaQuery.of(context).size.width,
              child: Text(title!),
            )
          : null,
      contentTextStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: cText1,
            fontSize: 15,
          ),
      content: content != null ? content : null,
      scrollable: true,
      actions: <Widget>[
        MaterialButton(
          elevation: 0,
          minWidth: 50,
          focusElevation: 0,
          highlightElevation: 0,
          height: 30,
          // color: Colors.grey.shade50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            dismissText ?? "OK",
            style: TextStyle(
              color: cPrimary,
              fontSize: 15,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        actionBtnText != null
            ? MaterialButton(
                minWidth: 50,
                elevation: 0,
                focusElevation: 0,
                highlightElevation: 0,
                height: 30,
                color: color ?? cPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                textColor: Colors.white,
                child: Text(
                  actionBtnText!,
                  style: TextStyle(fontSize: 15),
                ),
                onPressed: actionFunction != null
                    ? () {
                        actionFunction!.call();
                        Navigator.of(context).pop(true);
                      }
                    : () {
                        Navigator.of(context).pop(false);
                      },
              )
            : const SizedBox(),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(btnRadius),
      ),
      contentPadding: EdgeInsets.only(
        top: title != null ? p3 / 2 : p4,
        left: p4,
        right: p4,
      ),
      titlePadding: const EdgeInsets.only(
        top: p4,
        left: p4,
        right: p4,
      ),
      actionsPadding: const EdgeInsets.only(
        left: p3,
        right: p3,
      ),
    );
  }
}

class CustomDialogWithOptions extends StatelessWidget {
  final String? title;
  final List<Widget> optionList;
  final String? dismissText;
  final String? actionBtnText;
  final VoidCallback? actionFunction;
  const CustomDialogWithOptions({
    Key? key,
    this.title,
    required this.optionList,
    this.dismissText,
    this.actionBtnText,
    this.actionFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(p5),
      titleTextStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.bold,
            color: cText1,
          ),
      title: title != null
          ? Container(
              width: MediaQuery.of(context).size.width,
              child: Text(title!),
            )
          : null,
      content: Column(
        children: optionList,
      ),
      scrollable: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(btnRadius),
      ),
      titlePadding: EdgeInsets.only(
        top: p3,
        left: p4,
        right: p4,
      ),
      contentPadding: EdgeInsets.only(
        top: title != null ? p4 / 2 : p3,
        left: 0,
        right: 0,
        bottom: p3,
      ),
      actionsPadding: EdgeInsets.only(
        left: p4,
        right: p4 / 2,
      ),
    );
  }
}

class CustomDialogLongList extends StatelessWidget {
  final String? title;
  final String? dismissText;
  final String? actionBtnText;
  final VoidCallback? actionFunction;
  const CustomDialogLongList({
    Key? key,
    this.title,
    this.dismissText,
    this.actionBtnText,
    this.actionFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(p5),
      titleTextStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.bold,
            color: cText1,
          ),
      title: title != null
          ? Container(
              width: MediaQuery.of(context).size.width,
              child: Text(title!),
            )
          : null,
      content: Column(
        children: List.generate(
          countries.length,
          (i) => Padding(
            padding: const EdgeInsets.symmetric(vertical: p3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/flags/${countries[i].code.toLowerCase()}.png',
                  width: 24,
                ),
                const SizedBox(
                  width: p2,
                ),
                Expanded(
                  child: Text(
                    countries[i].name,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                const SizedBox(
                  width: p2,
                ),
                Text(
                  "+" + countries[i].dialCode,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
      scrollable: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(btnRadius),
      ),
      titlePadding: EdgeInsets.only(
        top: p3,
        left: p4,
        right: p4,
      ),
      contentPadding: EdgeInsets.only(
        top: title != null ? p4 / 2 : p3,
        left: p4,
        right: p4,
        bottom: p4,
      ),
      actionsPadding: EdgeInsets.only(
        left: p4,
        right: p4 / 2,
      ),
    );
  }
}

class CustomDialogCountriesList extends StatelessWidget {
  final String? title;

  const CustomDialogCountriesList({
    Key? key,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(p5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(
              vertical: p4,
              horizontal: p4,
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search a country ...",
                suffixIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search,
                      color: divider1,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: cPrimary.withOpacity(0.1),
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    countries.length,
                    (i) => InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: p4,
                          horizontal: p4,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/flags/${countries[i].code.toLowerCase()}.png',
                              width: 24,
                            ),
                            const SizedBox(
                              width: p4,
                            ),
                            Expanded(
                              child: Text(
                                countries[i].name,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                            const SizedBox(
                              width: p2,
                            ),
                            Text(
                              "+" + countries[i].dialCode,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              alignment: Alignment.center,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: p3),
              child: Text(
                "DISMISS",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: cPrimary,
                    ),
              ),
            ),
          )
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
    );
  }
}

class OptionItem extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final Widget? prefix;
  const OptionItem({
    Key? key,
    required this.onTap,
    required this.label,
    this.prefix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        onTap();
      },
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: p4,
              vertical: p3,
            ),
            child: Row(
              children: [
                prefix != null ? prefix! : const SizedBox(),
                prefix != null
                    ? const SizedBox(
                        width: p4,
                      )
                    : const SizedBox(),
                Text(label),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomLoadingStateDialog {
  CustomLoadingStateDialog();

  createDialog(
    BuildContext context,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Material(
            color: Colors.black12,
            child: Center(
              child: Container(
                height: 60,
                width: 60,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: CircularProgressIndicator(
                  color: cPrimary,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
