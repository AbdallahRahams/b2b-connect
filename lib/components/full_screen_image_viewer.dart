import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'button_loading_indicator.dart';

class FullScreenImageViewer extends StatelessWidget {
  const FullScreenImageViewer({
    Key? key,
    required this.url,
  }) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, _) {
        return WillPopScope(
          onWillPop: () {
            return Future.value(true);
          },
          child: Material(
            color: Colors.black87,
            child: Stack(
              children: [
                const SizedBox(),
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: InteractiveViewer(
                    child: CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.low,
                      errorWidget: (context, _, __) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.error,
                              color: divider4,
                              size: 64,
                            ),
                          ],
                        );
                      },
                      placeholder: (context, _) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.image,
                              color: divider4,
                              size: 64,
                            ),
                            LoadingIndicator(
                              size: 16,
                              color: Colors.black38,
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  right: p2,
                  top: p2,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(p2),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(
                        Icons.clear_rounded,
                        color: Colors.white60,
                        size: 32,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
