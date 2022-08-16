import 'package:flutter/material.dart';
import 'package:sdui/sdui.dart';

/// Descriptor of an [CircleAvatar].
///
/// ### JSON Attributes
/// - **radius**: Radius
/// - **backgroundColor**: Radius
class SDUICircleAvatar extends SDUIWidget {
  double? radius;
  String? backgroundColor;

  @override
  Widget toWidget(BuildContext context) => GestureDetector(
      onTap: () => _onTap(context),
      child: CircleAvatar(
        key: id == null ? null : Key(id!),
        radius: radius,
        backgroundColor: toColor(backgroundColor),
        child: ClipRRect(
          borderRadius: radius != null ? BorderRadius.circular(radius!) : null,
          child: child()?.toWidget(context),
        ),
      ));

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    radius = json?["radius"];
    backgroundColor = json?["backgroundColor"];
    return super.fromJson(json);
  }

  void _onTap(BuildContext context) {
    action
        .execute(context, null)
        .then((value) => action.handleResult(context, value));
  }
}
