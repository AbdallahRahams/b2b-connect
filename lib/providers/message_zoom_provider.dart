import 'package:flutter/material.dart';

class ZoomMessages with ChangeNotifier {
  double _scale = 1.0;
  double minScale = 0.9;
  double maxScale = 2.0;
  double get scale => _scale;
  double _endScale = 1.0;
  updateScale({required double scale}) {
    _scale = _endScale * scale;
    if (_scale < minScale) {
      _scale = minScale;
    }
    if (_scale > maxScale) {
      _scale = maxScale;
    }
    notifyListeners();
  }

  endScale() {
    _endScale = _scale;
  }
}
