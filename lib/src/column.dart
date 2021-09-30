import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widget.dart';

/// Descriptor of a [Column]
class SDUIColumn extends SDUIWidget {
  @override
  Widget toWidget(BuildContext context) => Column(
        children: childrenWidgets(context),
      );
}
