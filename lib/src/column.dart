import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widget.dart';

class SDUIColumn extends SDUIComposite {
  @override
  Widget toWidget(BuildContext context) => Column(
        children: childrenWidgets(context),
      );
}
