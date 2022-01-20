import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'widget.dart';

/// Descriptor of a [CachedNetworkImage]
class SDUIImage extends SDUIWidget {
  String? url;
  double? width;
  double? height;

  SDUIImage({this.url, this.width, this.height});

  @override
  Widget toWidget(BuildContext context) => CachedNetworkImage(
      imageUrl: url ?? '',
      width: width,
      height: height,
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error));

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    url = json?["url"] ?? '';
    width = json?["width"];
    height = json?["height"];
    return this;
  }
}
