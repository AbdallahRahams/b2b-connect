import 'package:flutter/material.dart';

class ButtonLoadingIndicator extends StatelessWidget {
  const ButtonLoadingIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 24,
      width: 24,
      child: CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 2,
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  final double size;
  final double stroke;
  final Color? color;
  const LoadingIndicator({
    Key? key,
    this.size = 32.0,
    this.stroke = 3.0,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: CircularProgressIndicator(
        color: Theme.of(context).primaryColor,
        strokeWidth: stroke,
        valueColor:
            color != null ? new AlwaysStoppedAnimation<Color>(color!) : null,
      ),
    );
  }
}
