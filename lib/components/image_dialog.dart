import 'dart:io';
import 'package:b2b_connect/icon_fonts/b2b_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class CustomImageDialog extends StatelessWidget {
  final String? imageURL;
  final bool fullImage;
  const CustomImageDialog({
    Key? key,
    this.imageURL,
    this.fullImage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: fullImage ? EdgeInsets.zero : EdgeInsets.all(p5),
      content: InteractiveViewer(
        panEnabled: true,
        scaleEnabled: true,
        child: fullImage
            ? CachedNetworkImage(
                imageUrl: imageURL!,
                fit: BoxFit.fill,
                placeholder: (context, url) =>
                    Icon(B2B.logo_svg, size: 32, color: cText3),
                errorWidget: (context, url, error) =>
                    Icon(B2B.logo_svg, size: 32, color: cText4),
              )
            : AspectRatio(
                aspectRatio: 1.1,
                child: CachedNetworkImage(
                  imageUrl: imageURL!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Icon(B2B.logo_svg, size: 32, color: cText3),
                  errorWidget: (context, url, error) =>
                      Icon(B2B.logo_svg, size: 32, color: cText4),
                ),
              ),
      ),
      scrollable: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      contentPadding: EdgeInsets.zero,
    );
  }
}

class CustomSendImageDialog extends StatelessWidget {
  final File? imageURL;
  final bool fullImage;
  final Widget action;
  const CustomSendImageDialog({
    Key? key,
    this.imageURL,
    required this.action,
    this.fullImage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: fullImage ? EdgeInsets.zero : EdgeInsets.all(p5),
      content: Image.file(
        imageURL!,
        fit: BoxFit.contain,
      ),
      scrollable: true,
      title: const SizedBox(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(p2)),
      contentPadding: EdgeInsets.zero,
      actionsPadding: const EdgeInsets.all(0),
      actions: [
        Container(
            padding: const EdgeInsets.symmetric(vertical: p2),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: divider3, width: 0.5),
              ),
            ),
            child: action)
      ],
    );
  }
}
