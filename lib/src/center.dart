import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widget.dart';

/// Descriptor of a [Center]
class SDUICenter extends SDUIWidget {
  @override
  Widget toWidget(BuildContext context) => Center(
        child: child()?.toWidget(context),
      );
}
