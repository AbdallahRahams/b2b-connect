import 'package:b2b_connect/constants.dart';
import 'package:flutter/material.dart';

class TextDescription extends StatelessWidget {
  final String title;
  final String description;

  const TextDescription(
      {Key? key, required this.title, required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: p2,
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(
          height: p3,
        ),
        Text(
          description,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(
          height: p4,
        ),
      ],
    );
  }
}
