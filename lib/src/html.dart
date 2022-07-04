import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widget.dart';

/// Descriptor of an [Html]
class SDUIHtml extends SDUIWidget {
  String? data;

  @override
  Widget toWidget(BuildContext context) => Html(
      data: data ?? '',
      onLinkTap: (url, _, __, ___) async {
        if (url != null && await canLaunch(url)) {
          await launch(url);
        }
      });

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    data = json?["data"];
    return this;
  }
}
