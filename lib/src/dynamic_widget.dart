import 'package:flutter/material.dart';

import 'route.dart';
import 'widget.dart';

/// SDUIRoute
class SDUIDynamicWidget extends SDUIWidget {
  String? url;

  @override
  Widget toWidget(BuildContext context) => DynamicRoute(
      provider: url != null
          ? HttpRouteContentProvider(url!)
          : const StaticRouteContentProvider("{}"));

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    super.fromJson(json);
    url = json?["url"];
    return this;
  }

}
