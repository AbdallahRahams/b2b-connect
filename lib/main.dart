import 'dart:async';
import 'package:b2b_connect/providers/authentication_provider.dart';
import 'package:b2b_connect/providers/google_sign_in_provider.dart';
import 'package:b2b_connect/providers/user_details.dart';
import 'package:b2b_connect/providers/wholesalers_provider.dart';
import 'package:b2b_connect/routes.dart';
import 'package:b2b_connect/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'firebase_options.dart';
import 'providers/products_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);

  runZonedGuarded(() {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => AuthenticationProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => UserDetailsProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => GoogleSignInProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => WholesalersProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => ProductsProvider(),
          ),
        ],
        child: MyApp(),
      ),
    );
  }, (error, stack) {
    // Handle errors here
  });
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage("assets/images/bg.png"), context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      color: Colors.white,
      theme: theme,
      initialRoute: '/',
      routes: routes,
      onGenerateRoute: onGenerateRoute,
    );
  }
}