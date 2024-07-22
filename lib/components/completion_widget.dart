import 'package:flutter/material.dart';

class CompletionWidget extends StatefulWidget {
  final int completionLevel;
  final int fullCompletion;
  final double? height;
  final bool? invert;
  const CompletionWidget({
    Key? key,
    required this.completionLevel,
    required this.fullCompletion,
    this.height = 12,
    this.invert = false,
  }) : super(key: key);

  @override
  State<CompletionWidget> createState() => _CompletionWidgetState();
}

class _CompletionWidgetState extends State<CompletionWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.height!),
        child: Row(
          children: [
            Flexible(
              flex: widget.completionLevel,
              child: Container(
                color: widget.invert!
                    ? Colors.white60
                    : Theme.of(context).primaryColor,
              ),
            ),
            Flexible(
              flex: widget.fullCompletion - widget.completionLevel,
              child: Container(
                color: widget.invert!
                    ? Colors.white24
                    : Theme.of(context).primaryColor.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
