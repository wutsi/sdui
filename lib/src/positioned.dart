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

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    top = json?["top"];
    bottom = json?["bottom"];
    right = json?["right"];
    left = json?["left"];
    width = json?["width"];
    height = json?["height"];

    return super.fromJson(json);
  }
}
