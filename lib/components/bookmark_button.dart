import 'package:flutter/material.dart';

import '../constants.dart';

class BookmarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    Paint paint = Paint();
    paint
      ..color = cText2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square
      ..strokeJoin = StrokeJoin.miter
      ..strokeWidth = 1.5;

    Paint paint1 = Paint();
    paint1
      ..color = Colors.transparent
      ..style = PaintingStyle.fill
      ..strokeWidth = 0;

    double width = size.width;
    double height = size.height;

    Path path = Path();
    path.lineTo(0, height);
    path.lineTo(width * 0.5, 0.75 * height);
    path.lineTo(width, height);
    path.lineTo(width, 0);
    path.close();
    canvas.drawPath(path, paint1);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
