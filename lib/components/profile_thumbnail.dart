import 'package:b2b_connect/constants.dart';
import 'package:b2b_connect/icon_fonts/b2b_icons.dart';
import 'package:b2b_connect/providers/user_details.dart';
import 'package:b2b_connect/screens/profile/profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileThumbnail extends StatefulWidget {
  const ProfileThumbnail({Key? key}) : super(key: key);

  @override
  State<ProfileThumbnail> createState() => _ProfileThumbnailState();
}

class _ProfileThumbnailState extends State<ProfileThumbnail> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDetailsProvider>(builder: (context, provider, _) {
      return provider.user == null
          ? const SizedBox()
          : GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(UserProfile.route);
              },
              child: AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(56),
                  child: CachedNetworkImage(
                    imageUrl: provider.user!.profileImage!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Icon(B2B.logo_svg, size: 24, color: cText3),
                    errorWidget: (context, url, error) =>
                        Icon(B2B.logo_svg, size: 24, color: cText4),
                  ),
                ),
              ),
            );
    });
  }
}
