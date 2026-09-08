import 'package:flutter/material.dart';

//Wrap tab bodies (1200) or reading columns (700) with this.
class ConstrainedWidth extends StatelessWidget {
  const ConstrainedWidth({
    super.key,
    required this.child,
    this.maxWidth = 1200,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
