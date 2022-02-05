import 'package:flutter/cupertino.dart';

import 'widget.dart';

class SDUIPositioned extends SDUIWidget {
  double? top;
  double? bottom;
  double? right;
  double? left;
  double? width;
  double? height;

  @override
  Widget toWidget(BuildContext context) => Positioned(
      top: top,
      bottom: bottom,
      right: right,
      left: left,
      width: width,
      height: height,
      child: child()?.toWidget(context) ?? Container());
}
