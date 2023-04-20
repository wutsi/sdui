import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

import 'widget.dart';

/// Descriptor of a [Badge]
class SDUIBadge extends SDUIWidget {
  String? shape;
  String? color;
  String? backgroundColor;
  double? borderRadius;
  String? position;
  double? elevation;
  String? caption;
  double? fontSize;
  double? padding;

  @override
  Widget toWidget(BuildContext context) => Badge(
        key: id == null ? null : Key(id!),
        badgeStyle: BadgeStyle(
          elevation: elevation ?? 2,
          badgeColor: toColor(backgroundColor) ?? Colors.red,
          borderRadius: borderRadius == null
              ? BorderRadius.zero
              : BorderRadius.all(Radius.circular(borderRadius!)),
          shape: _toBadgeShape(shape),
          padding: EdgeInsets.all(padding ?? 5.0),
        ),
        position: _toBadgePosition(position),
        badgeContent: caption != null
            ? Text(
                caption!,
                style: TextStyle(
                    color: toColor(color) ?? Colors.white, fontSize: fontSize),
              )
            : null,
        child: child()?.toWidget(context),
      );

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    shape = json?["shape"];
    backgroundColor = json?["backgroundColor"];
    color = json?["color"];
    caption = json?["caption"];
    borderRadius = json?["borderRadius"];
    position = json?["position"];
    elevation = json?["elevation"];
    fontSize = json?["fontSize"];
    padding = json?["padding"];

    return super.fromJson(json);
  }

  BadgeShape _toBadgeShape(String? shape) {
    if (shape?.toLowerCase() == "square") {
      return BadgeShape.square;
    }
    return BadgeShape.circle;
  }

  BadgePosition? _toBadgePosition(String? position) {
    switch (position?.toLowerCase()) {
      case "center":
        return BadgePosition.center();
      case "topend":
        return BadgePosition.topEnd();
      case "topstart":
        return BadgePosition.topStart();
      case "bottomend":
        return BadgePosition.bottomEnd();
      case "bottomstart":
        return BadgePosition.bottomStart();
    }
    return null;
  }
}
