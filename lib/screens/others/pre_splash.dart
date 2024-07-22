import 'package:b2b_connect/components/button_loading_indicator.dart';
import 'package:b2b_connect/components/custom_button.dart';
import 'package:b2b_connect/constants.dart';
import 'package:b2b_connect/models/response.dart';
import 'package:b2b_connect/providers/authentication_provider.dart';
import 'package:b2b_connect/providers/check_app_version.dart';
import 'package:b2b_connect/screens/home_pages/home.dart';
import 'package:b2b_connect/screens/others/splash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PreSplashScreen extends StatefulWidget {
  static const String route = '/preSplash';

  const PreSplashScreen({Key? key}) : super(key: key);

  @override
  _PreSplashScreenState createState() => _PreSplashScreenState();
}

class _PreSplashScreenState extends State<PreSplashScreen>
    with SingleTickerProviderStateMixin {
  CustomMaterialButton materialButton = CustomMaterialButton();

  late AnimationController _animationController;
  late Animation<double> _animation;
  bool? _isAuthenticatedError;
  bool? isApplicationVersionActive;
  bool loading = true;
  bool failedTovValidateVersion = false;
  @override
  void initState() {
    _validateVersion();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.0,
          1.0,
          curve: Curves.easeIn,
        ),
      ),
    );
    _animationController.forward();
    super.initState();
  }

  _autoAuthenticate() async {
    ResponseMessage autoAuthenticateResponse =
        await AuthenticationProvider().autoAuthenticate();
    if (mounted) {
      setState(() {
        _isAuthenticatedError = autoAuthenticateResponse.error;
      });
    }
  }

  _validateVersion() async {
    setState(() {
      loading = true;
    });
    var provider =
        await AppVersionProvider().verifyVersion(localVersion: buildVersion);
    setState(() {
      loading = false;
    });
    if (provider.message == "ACTIVE") {
      failedTovValidateVersion = false;
      await _autoAuthenticate();
      await _validate();
    } else if (provider.message == "DISABLED") {
      failedTovValidateVersion = false;
      ScaffoldMessenger.of(context).clearMaterialBanners();
      ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Update needed",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(
                height: p1,
              ),
              Text(
                "You are currently using an old version of $appName, update now to continue use the application",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0.5,
          padding: const EdgeInsets.only(
            top: p4,
            left: p4,
            right: p4,
            bottom: p2,
          ),
          forceActionsBelow: true,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: p2),
              child: materialButton.createButtonSmall(
                function: () async {

                },
                label: "Update",
                loadingLabel: "",
              ),
            )
          ],
        ),
      );

      /// Update application version
    } else {
      /// Failed to verify version
      failedTovValidateVersion = true;
      if (failedTovValidateVersion == true) {
        ScaffoldMessenger.of(context).clearMaterialBanners();
        ScaffoldMessenger.of(context).showMaterialBanner(
          MaterialBanner(
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Error",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(
                  height: p1,
                ),
                Text(
                  "Failed to validate this application build version, check your internet connection and retry",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0.5,
            padding: const EdgeInsets.only(
              top: p4,
              left: p4,
              right: p4,
              bottom: p2,
            ),
            forceActionsBelow: true,
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: p2),
                child: materialButton.createButtonSmall(
                  function: () {
                    ScaffoldMessenger.of(context).clearMaterialBanners();
                    _validateVersion();
                  },
                  label: "Retry",
                  loadingLabel: "",
                ),
              )
            ],
          ),
        );
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  _navigateLogin() {
    Navigator.of(context).pop();
    Navigator.of(context).pushNamed(Splash.route);
  }

  _navigateHome() {
    Navigator.of(context).pop();
    Navigator.of(context)
        .pushNamed(Home.route);
  }

  _validate() async {
    if (_isAuthenticatedError != null) {
      if (_isAuthenticatedError == true) {
        _navigateLogin();
      } else {
        _navigateHome();
      }
    } else {
      await _autoAuthenticate();
      await _validate();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) => Transform.translate(
                        offset: Offset(0, 80 * (1 - _animation.value)),
                        child: FadeTransition(
                          opacity: _animation,
                          child: child!,
                        ),
                      ),
                      child: Text(
                        appName,
                        style: TextStyle(
                          fontFamily: 'Gilroy',
                          fontSize: 48,
                          height: 1,
                          letterSpacing: -1,
                          color: cText2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: p2,
                left: p2,
                right: p2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "version $buildVersion",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                    loading
                        ? const SizedBox(
                            width: p2,
                          )
                        : const SizedBox(),
                    loading
                        ? LoadingIndicator(
                            size: 12,
                            stroke: 2,
                          )
                        : const SizedBox(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
