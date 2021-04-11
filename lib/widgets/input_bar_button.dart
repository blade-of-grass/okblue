import 'package:flutter/material.dart';

class InputBarButton extends StatelessWidget {
  final Widget child;
  final Color color;
  final Color highlightColor;
  final bool isBorder;
  final Function onTap;

  static _calcHighlight(Color color) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness(hsl.lightness * 0.69).toColor();
  }

  InputBarButton({
    @required this.child,
    @required this.color,
    @required this.onTap,
    this.isBorder = false,
  }) : highlightColor = isBorder ? color : _calcHighlight(color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0),
      child: SizedBox(
        width: 48,
        height: 48,
        child: RawMaterialButton(
          fillColor: isBorder ? Colors.transparent : this.color,
          onPressed: this.onTap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
            side: isBorder
                ? BorderSide(color: this.color, width: 2.0)
                : BorderSide.none,
          ),
          splashColor: this.highlightColor,
          highlightColor: isBorder
              ? Colors.transparent
              : this.highlightColor.withOpacity(0.33),
          child: Padding(padding: EdgeInsets.all(12.0), child: this.child),
        ),
      ),
    );
  }
}
