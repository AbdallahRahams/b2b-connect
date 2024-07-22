import 'package:flutter/material.dart';
import '../../../constants.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    Key? key,
    required this.label,
    required this.isActive,
    this.onTap,
  }) : super(key: key);

  final String label;
  final bool isActive;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius:
      const BorderRadius.all(Radius.circular(defaultBorderRadius)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: isActive ? cPrimary : secondaryTextColor,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
