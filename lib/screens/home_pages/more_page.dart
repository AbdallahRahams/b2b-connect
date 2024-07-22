import 'package:b2b_connect/constants.dart';
import 'package:flutter/material.dart';
import '../profile/profile.dart';
import '../others/terms_and_conditions.dart';
import '../report_problem.dart';

class MorePage extends StatefulWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("More"),
        backgroundColor: Colors.white,
        titleTextStyle: Theme.of(context).textTheme.headlineMedium!,
        iconTheme: Theme.of(context).iconTheme,
        automaticallyImplyLeading: false,
        centerTitle: centerTitle,
        elevation: 0.5,
        shadowColor: divider4,
      ),
      body: ListView(
        children: const [
          MoreToPageLink(
            label: "Profile",
            routeName: UserProfile.route,
            icon: Icons.person_rounded,
          ),
          MoreToPageLink(
            label: "Report problem",
            routeName: ReportProblem.route,
            icon: Icons.report,
          ),
          MoreToPageLink(
            label: "Terms and conditions",
            routeName: TermsAndConditions.route,
            icon: Icons.article_rounded,
          ),
        ],
      ),
    );
  }
}

class MoreToPageLink extends StatelessWidget {
  const MoreToPageLink({
    Key? key,
    this.routeName,
    this.function,
    required this.label,
    this.icon,
    this.textColor,
  }) : super(key: key);
  final String? routeName;
  final VoidCallback? function;
  final String label;
  final IconData? icon;
  final Color? textColor;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (routeName != null) {
          Navigator.of(context).pushNamed(routeName!);
        }
        if (function != null) {
          function!();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: pagePadding,
          vertical: p4,
        ),
        child: Row(
          children: [
            icon == null
                ? const SizedBox()
                : Icon(
                    icon,
                    size: 22,
                    color: cText3,
                  ),
            icon == null
                ? const SizedBox()
                : const SizedBox(
                    width: p4,
                  ),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: textColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
