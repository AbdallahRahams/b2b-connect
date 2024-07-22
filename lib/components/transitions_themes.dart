import 'package:flutter/material.dart';

class RotationFadeTransitionBuilder extends PageTransitionsBuilder {
  const RotationFadeTransitionBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return _RotationFadeTransitionBuilder(
        routeAnimation: animation, key: null, child: child);
  }
}

class _RotationFadeTransitionBuilder extends StatelessWidget {
  _RotationFadeTransitionBuilder({
    required Key? key,
    required Animation<double> routeAnimation,
    required this.child,
  })  : _turnsAnimation = routeAnimation.drive(_linearToEaseOut),
        _opacityAnimation = routeAnimation.drive(_easeInTween),
        super(key: key);

  static final Animatable<double> _linearToEaseOut =
      CurveTween(curve: Curves.linearToEaseOut);
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);

  final Animation<double> _turnsAnimation;
  final Animation<double> _opacityAnimation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _turnsAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: child,
      ),
    );
  }
}

class ZoomSlideUpTransitionsBuilder extends PageTransitionsBuilder {
  const ZoomSlideUpTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return _ZoomSlideUpTransitionsBuilder(
        routeAnimation: animation, key: null, child: child);
  }
}

class _ZoomSlideUpTransitionsBuilder extends StatelessWidget {
  _ZoomSlideUpTransitionsBuilder({
    required Key? key,
    required Animation<double> routeAnimation,
    required this.child,
  })  : _scaleAnimation = CurvedAnimation(
          parent: routeAnimation,
          curve: Curves.linear,
        ).drive(_scaleTween),
        _slideAnimation = CurvedAnimation(
          parent: routeAnimation,
          curve: Curves.linear,
        ).drive(_kBottomUpTween),
        super(key: key);

  final Animation<Offset> _slideAnimation;
  final Animation<double> _scaleAnimation;

  static final Animatable<double> _scaleTween =
      Tween<double>(begin: 0.0, end: 1);
  static final Animatable<Offset> _kBottomUpTween = Tween<Offset>(
    begin: const Offset(0.0, 1.0),
    end: const Offset(0.0, 0.0),
  );

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: child,
      ),
    );
  }
}

class CustomRoute extends MaterialPageRoute {
  CustomRoute({required WidgetBuilder builder}) : super(builder: builder);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 700);
}
