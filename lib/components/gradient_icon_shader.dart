import 'package:b2b_connect/constants.dart';
import 'package:flutter/material.dart';

class RadiantGradientMask extends StatelessWidget {
  RadiantGradientMask({required this.child, this.stops, this.begin, this.end});
  final Widget child;
  final List<double>? stops;
  final AlignmentGeometry? begin;
  final AlignmentGeometry? end;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        begin: begin == null ? Alignment.topRight : begin!,
        end: end == null ? Alignment.bottomLeft : end!,
        tileMode: TileMode.clamp,
        colors: [
          iconSelected,
          cPrimary,
        ],
      ).createShader(bounds),
      child: child,
    );
  }
}
