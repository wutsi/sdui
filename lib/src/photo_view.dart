import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import 'widget.dart';

/// Descriptor of a [PhotoView]
///
/// ### JSON Attributes
/// - **url**: URL of the image
class SDUIPhotoView extends SDUIWidget {
  String? url;

  @override
  Widget toWidget(BuildContext context) => PhotoView(
        imageProvider: url == null ? null : CachedNetworkImageProvider(url!),
      );

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    url = json?["url"];
    return this;
  }
}
