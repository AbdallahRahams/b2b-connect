import 'package:flutter/material.dart';
import '../constants.dart';

class CustomToggleSwitch extends StatefulWidget {
  final bool value;
  final bool loading;
  const CustomToggleSwitch({
    Key? key,
    required this.value,
    required this.loading,
  }) : super(key: key);

  @override
  _CustomToggleSwitchState createState() => _CustomToggleSwitchState();
}

class _CustomToggleSwitchState extends State<CustomToggleSwitch>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animationPosition;
  late Animation<Color?> _animationColor;
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animationPosition = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationColor =
        ColorTween(begin: Colors.grey.shade400, end: Colors.green.shade600)
            .animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  _toggleButton() {
    if (widget.value) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    _toggleButton();
    return GestureDetector(
      onTap: _toggleButton,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (ctx, _) {
          return Container(
            width: 44,
            height: 26,
            decoration: BoxDecoration(
              color: _animationColor.value,
              borderRadius: BorderRadius.circular(26),
            ),
            alignment: Alignment(_animationPosition.value, 0),
            padding: const EdgeInsets.all(p1 / 2),
            child: Container(
              width: 22,
              height: 22,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: widget.loading
                  ? Padding(
                      padding: const EdgeInsets.all(p1),
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }
}

class CustomToggleTileSwitch extends StatelessWidget {
  const CustomToggleTileSwitch({
    Key? key,
    this.padding,
    required this.onTap,
    required this.value,
    required this.title,
    this.subtitle,
    required this.loading,
  }) : super(key: key);
  final EdgeInsetsGeometry? padding;
  final VoidCallback onTap;
  final bool value;
  final String title;
  final String? subtitle;
  final bool loading;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: loading ? null : onTap,
      child: Opacity(
        opacity: 1,
        child: Container(
          padding: padding == null
              ? const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                )
              : padding,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    SizedBox(
                      height: subtitle != null ? p1 / 2 : 0,
                    ),
                    subtitle != null
                        ? Text(
                            subtitle!,
                            style: Theme.of(context).textTheme.bodyMedium,
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              CustomToggleSwitch(
                value: value,
                loading: loading,
              )
            ],
          ),
        ),
      ),
    );
  }
}
