import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widget.dart';

/// Descriptor of a [Expanded]
class SDUIExpanded extends SDUIWidget {
  @override
  Widget toWidget(BuildContext context) => Expanded(
        child: child()?.toWidget(context) ?? Container(),
      );
}
