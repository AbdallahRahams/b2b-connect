import 'package:b2b_connect/models/wholesaler.dart';
import 'package:b2b_connect/screens/home_pages/components/separator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import '../../../providers/wholesalers_provider.dart';
import 'network_image_loader.dart';

class WholesalerHorizontal extends StatelessWidget {
  const WholesalerHorizontal({
    Key? key,
    required this.wholesaler}) : super(key: key);

  final Wholesaler wholesaler;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.shortestSide / 4,
                // flex: 1,
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: NetworkImageWithLoader(
                    wholesaler.profileImagePath,
                  ),
                ),
              ),
              const SizedBox(width: defaultPadding),
              Expanded(
                // flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///
                    /// Channel name
                    ///
                    Text(
                      wholesaler.categoryName,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: p2),
                    Text(
                      wholesaler.name,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: p2),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            wholesaler.phone,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(width: p1),
                          const Icon(
                            Icons.circle,
                            size: 4,
                            color: secondaryTextColor,
                          ),
                          const SizedBox(width: defaultPadding / 2),
                          Text(
                            wholesaler.email,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              context
                                  .read<WholesalersProvider>()
                                  .setActiveWholesaler(wholesaler);
                            },
                            child: Text(
                              wholesaler.address,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                color: cPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        const Separator(),
      ],
    );
  }
}

class EngagementActions extends StatelessWidget {
  const EngagementActions({
    super.key,
    required this.count,
    required this.label,
    this.icon,
    this.isLarger = false,
    this.iconSize = 18,
    required this.onTap,
    this.activeIconColor,
  });

  final int count;
  final String label;
  final IconData? icon;
  final VoidCallback onTap;
  final bool isLarger;
  final double iconSize;
  final Color? activeIconColor;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const PageStorageKey("post"),
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            count.toString(),
            style: isLarger
                ? Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.bold,
            )
                : Theme.of(context).textTheme.bodySmall!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: p1),
          Text(
            label,
            style: isLarger
                ? Theme.of(context).textTheme.bodyMedium
                : Theme.of(context).textTheme.bodySmall,
          ),
          // Wrap(
          //   direction: Axis.horizontal,
          //   children: [
          //     icon != null
          //         ? InkWell(
          //             onTap: () => onTap(),
          //             child: Icon(
          //               icon,
          //               size: iconSize,
          //               color: activeIconColor,
          //             ),
          //           )
          //         : const SizedBox(),
          //     Text(
          //       label,
          //       style: isLarger
          //           ? Theme.of(context).textTheme.bodyMedium
          //           : Theme.of(context).textTheme.bodySmall,
          //     ),
          //   ],
          // )
        ],
      ),
    );
  }
}
