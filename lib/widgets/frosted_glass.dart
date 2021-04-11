import 'dart:ui';

import 'package:flutter/widgets.dart';

class FrostedGlass extends StatelessWidget {
  final Widget child;
  final double blur;

  FrostedGlass({double blur, @required this.child}) : this.blur = blur ?? 5.0;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: this.blur, sigmaY: this.blur),
        child: this.child,
      ),
    );
  }
}
