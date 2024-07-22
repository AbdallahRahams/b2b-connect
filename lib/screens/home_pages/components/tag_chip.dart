import 'package:flutter/material.dart';
import '../../../constants.dart';

class TagChip extends StatelessWidget {
  const TagChip({
    Key? key,
    required this.label,
    this.onTap,
  }) : super(key: key);

  final String label;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(defaultBorderRadius),
      onTap: onTap ?? () {},
      child: Chip(
        label: Text(label),
      ),
    );
  }
}
