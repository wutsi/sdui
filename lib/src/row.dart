import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widget.dart';

class SDUIRow extends SDUIComposite {
  @override
  Widget toWidget(BuildContext context) => Row(
        children: childrenWidgets(context),
      );
}
