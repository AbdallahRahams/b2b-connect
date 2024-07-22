import 'dart:async';
import 'package:b2b_connect/components/custom_toast.dart';
import 'package:b2b_connect/components/full_screen_image_viewer.dart';
import 'package:b2b_connect/components/string_functions.dart';
import 'package:b2b_connect/components/custom_button.dart';
import 'package:b2b_connect/components/custom_dialog.dart';
import 'package:b2b_connect/constants.dart';
import 'package:b2b_connect/icon_fonts/b2b_icons.dart';
import 'package:b2b_connect/models/response.dart';
import 'package:b2b_connect/providers/authentication_provider.dart';
import 'package:b2b_connect/providers/google_sign_in_provider.dart';
import 'package:b2b_connect/providers/user_details.dart';
import 'package:b2b_connect/screens/home_pages/more_page.dart';
import 'package:b2b_connect/screens/others/welcome.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'change_password.dart';
import 'edit_profile.dart';

import 'package:http/http.dart' as http;

class UserProfile extends StatefulWidget {
  static const String route = '/profile';

  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  // The reference to the navigator
  late NavigatorState _navigator;

  CustomTextButton customTextButton = CustomTextButton();
  CustomLoadingStateDialog loadingDialog = CustomLoadingStateDialog();

  /// User details
  String? phone;
  int? userID;
  String? email;
  String? firstname;
  String? middlename;
  String? lastname;
  String? username;
  String? gender;
  String? dob;

  /// Profile image
  final ImagePicker _picker = ImagePicker();
  String? _profileImageURL;

  @override
  initState() {
    _getUserDetails();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _navigator = Navigator.of(context);
    super.didChangeDependencies();
  }

  _getUserDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    phone = "+" + preferences.getString("phone")!;
    email = preferences.getString("email")!;
    firstname = preferences.getString("first_name")!.capitalize();
    middlename = preferences.getString("middle_name")! == "---"
        ? ""
        : preferences.getString("middle_name")!.capitalize() + " ";
    lastname = preferences.getString("last_name")!.capitalize();
    username = preferences.getString("username")!;
    gender = preferences.getString("gender")!;
    dob = preferences.getString("dob")!.birthday();
    userID = preferences.getInt("id")!;
    _profileImageURL = preferences.getString("profile_image");
    if (mounted) {
      setState(() {});
    }
  }

  Future takePhoto(ImageSource source) async {
    await _picker
        .pickImage(
      source: source,
      imageQuality: 20,
      preferredCameraDevice: CameraDevice.rear,
    )
        .then((value) async {
      /// Check connectivity
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        CustomToast.normal("No internet connection");
      }
      if (value == null || value.path == "" || value.name == "") {
        return false;
      }

      /// Show loading dialog
      loadingDialog.createDialog(context);

      ResponseMessage responseMessage =
          await AuthenticationProvider().updateProfileImage(image: File(value.path));
      _getUserDetails();

      /// Close loading dialog
      Navigator.of(context, rootNavigator: true).pop();

      /// Refresh user details
      await context.read<UserDetailsProvider>().setUserDetails();
      if (responseMessage.error == false) {
        CustomToast.success("Profile image updated");
        _getUserDetails();
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog(
              title: "Failed",
              content: Text(responseMessage.message),
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Profile", style: TextStyle(color: Colors.white),),
          iconTheme: IconThemeData(color: Colors.white), // Change back arrow color
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SizedBox(
                      height: 80 + 2 * pagePadding,
                    ),
                    Container(
                      height: 40 + pagePadding,
                      color: cPrimary,
                    ),
                    Container(
                      padding: const EdgeInsets.all(pagePadding),
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          InkWell(
                            onTap: _profileImageURL != null
                                ? () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return FullScreenImageViewer(
                                          url: _profileImageURL!,
                                        );
                                      },
                                    );
                                  }
                                : () {},
                            child: SizedBox(
                              height: 80,
                              width: 80,
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: bgColor,
                                      spreadRadius: 3,
                                      blurRadius: 0,
                                    )
                                  ],
                                  shape: BoxShape.circle,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(80),
                                  child: _profileImageURL != null
                                      ? CachedNetworkImage(
                                          imageUrl: _profileImageURL!,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => Image.asset(
                                            "assets/images/logo.png",
                                            fit: BoxFit.cover,
                                            height: 32,
                                            color: divider2,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error, color: cText3),
                                        )
                                      : Image.asset(
                                    "assets/images/logo.png",
                                    fit: BoxFit.cover,
                                    height: 32,
                                    color: divider2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CustomDialogWithOptions(
                                        optionList: [
                                          OptionItem(
                                            onTap: () {
                                              takePhoto(ImageSource.gallery);
                                            },
                                            prefix: Icon(
                                              Icons.image_sharp,
                                              color: cText2,
                                            ),
                                            label: "Gallery",
                                          ),
                                          OptionItem(
                                            onTap: () {
                                              takePhoto(ImageSource.camera);
                                            },
                                            prefix: Icon(
                                              Icons.camera_alt_rounded,
                                              color: cText2,
                                            ),
                                            label: "Camera",
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(p1),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).canvasColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.camera_alt_rounded,
                                  color: cText3,
                                  size: 20,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: p2,
                ), // const Spacer(),
                ProfileDetails(label: "Username", data: username),
                ProfileDetails(
                    label: "Full name",
                    data: "$firstname " + "$middlename" + "$lastname"),
                ProfileDetails(label: "Email", data: email),
                ProfileDetails(label: "Phone number", data: phone),
                ProfileDetails(label: "Gender", data: gender),
                ProfileDetails(label: "Birthday", data: dob),
                Divider(
                  color: divider1,
                  thickness: 0.5,
                  height: p5,
                ),
                StreamBuilder(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, AsyncSnapshot<User?> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox();
                    } else if (snapshot.hasData) {
                      return const SizedBox();
                    } else if (!snapshot.hasData) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MoreToPageLink(
                            label: "Edit profile",
                            function: () {
                              Navigator.of(context)
                                  .pushNamed(EditUserProfile.route)
                                  .then(
                                (value) {
                                  if (value == true) {
                                    _getUserDetails();
                                  }
                                },
                              );
                            },
                          ),
                          MoreToPageLink(
                            label: "Change password",
                            function: () {
                              Navigator.of(context)
                                  .pushNamed(ChangePassword.route);
                            },
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text("Error occurred"),
                      );
                    } else {
                      return const Center(
                        child: Text("No data"),
                      );
                    }
                  },
                ),
                MoreToPageLink(
                  label: "Delete Account",
                  function: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomDialog(
                            title: "Delete Account",
                            content: Text(
                                "This will delete your account permanently. Do you want to continue to delete your account?"),
                            dismissText: "Cancel",
                            actionBtnText: "Yes",
                            color: Colors.red.shade600,
                            actionFunction: () async {
                              // TODO !!!
                              //  delete account implementation
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              String? token = prefs.getString("access_token");
                              String? tokenType = prefs.getString("token_type");
                              try {
                                final http.Response response = await http.delete(
                                  Uri.parse("$baseURL/api/delete/account"),
                                  headers: {
                                    "Content-Type": "application/json",
                                    "Authorization": "$tokenType $token",
                                  },
                                );
                                if(response.statusCode == 200){
                                  /// Remove all routes below
                                  _navigator.pushNamedAndRemoveUntil(
                                      Welcome.route, (_) => false);
                                }
                              } catch (e) {
                                print(e);
                              }
                              // print("delete account");
                            },
                          );
                        });
                  },
                ),
                MoreToPageLink(
                  label: "LOG OUT",
                  function: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomDialog(
                          title: "Log out",
                          content: Text(
                              "This will remove your credentials on this device. Do you want to continue with log out?"),
                          dismissText: "Cancel",
                          actionBtnText: "Yes",
                          actionFunction: () async {
                            final provider = Provider.of<GoogleSignInProvider>(
                                context,
                                listen: false);
                            await provider.googleLogout();
                            await AuthenticationProvider().logout();
                            /// Remove all routes below
                            _navigator.pushNamedAndRemoveUntil(
                                Welcome.route, (_) => false);
                          },
                        );
                      },
                    );
                  },
                  textColor: Colors.red.shade700,
                ),
                const SizedBox(height: p5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileDetails extends StatelessWidget {
  final String label;
  final String? data;

  const ProfileDetails({
    Key? key,
    required this.label,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: p2,
          horizontal: pagePadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              label,
              style:
                  Theme.of(context).textTheme.bodySmall!.copyWith(color: cText3),
            ),
            const SizedBox(
              height: p1 / 2,
            ),
            Text(
              data == null ? "" : data!,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
