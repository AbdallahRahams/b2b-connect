import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../components/image_dialog.dart';
import '../../../../constants.dart';

class CoverImagesWidget extends StatefulWidget {
  final String coverImage;

  const CoverImagesWidget({
    Key? key,
    required this.coverImage,
  }) : super(key: key);

  @override
  State<CoverImagesWidget> createState() => _CoverImagesWidgetState();
}

class _CoverImagesWidgetState extends State<CoverImagesWidget>
    with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(defaultPadding)),
        child: InkWell(
          onTap: () {
            showDialog(
                context: context,
                barrierColor: Colors.black87,
                builder: (context) {
                  return CustomImageDialog(
                    imageURL: widget.coverImage,
                    fullImage: true,
                  );
                });
          },
          child: CachedNetworkImage(
            imageUrl: widget.coverImage,
            fit: BoxFit.cover,
            placeholder: (context, url) => AspectRatio(
              aspectRatio: 1.1,
              child: Container(
                color: divider3,
              ),
            ),
            errorWidget: (context, url, error) => AspectRatio(
              aspectRatio: 1.1,
              child: Container(
                color: divider3,
                child:
                    Icon(Icons.info_outline_rounded, size: 24, color: cText4),
              ),
            ),
          ),
        ));
  }
}
