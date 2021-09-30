import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widget.dart';

/// Descriptor of a [Row]
class SDUIRow extends SDUIWidget {
  @override
  Widget toWidget(BuildContext context) => Row(
        children: childrenWidgets(context),
      );
}
