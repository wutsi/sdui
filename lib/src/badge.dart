import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

import 'widget.dart';

/// Descriptor of a [Badge]
class SDUIBadge extends SDUIWidget {
  String? shape;
  String? color;
  double? borderRadius;
  String? position;
  double? elevation;

  @override
  Widget toWidget(BuildContext context) => Badge(
        elevation: elevation ?? 2,
        badgeColor: toColor(color) ?? Colors.red,
        borderRadius: borderRadius == null
            ? BorderRadius.zero
            : BorderRadius.all(Radius.circular(borderRadius!)),
        shape: _toBadgeShape(shape),
        position: _toBadgePosition(position),
        child: child()?.toWidget(context),
      );

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    shape = json?["shape"];
    color = json?["color"];
    borderRadius = json?["borderRadius"];
    position = json?["position"];
    elevation = json?["elevation"];

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
      case "topEnd":
        return BadgePosition.topEnd();
      case "topStart":
        return BadgePosition.topStart();
      case "bottomEnd":
        return BadgePosition.bottomEnd();
      case "bottomStart":
        return BadgePosition.bottomStart();
    }
    return null;
  }
}
