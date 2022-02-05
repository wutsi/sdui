import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widget.dart';

/// Descriptor of a [Stack]
class SDUIStack extends SDUIWidget {
  @override
  Widget toWidget(BuildContext context) =>
      Stack(children: childrenWidgets(context));
}
