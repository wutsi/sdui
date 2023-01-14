import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'logger.dart';
import 'widget.dart';

/// Descriptor of a [CachedNetworkImage]
class SDUIImage extends SDUIWidget {
  static final Logger _logger = LoggerFactory.create('SDUIImage');
  String? url;
  double? width;
  double? height;
  String? fit;

  @override
  Widget toWidget(BuildContext context) => url == null
      ? Container()
      : CachedNetworkImage(
          key: id == null ? null : Key(id!),
          imageUrl: url!,
          width: width,
          height: height,
          fit: toBoxFit(fit),
          placeholder: (context, url) => Container(
              alignment: Alignment.center,
              width: 16.0,
              height: 16.0,
              child: const CircularProgressIndicator()),
          errorWidget: (context, url, error) {
            _logger.w('Error while downloading $url', error);
            return const Icon(Icons.error);
          });

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    url = json?["url"] ?? '';
    width = json?["width"];
    height = json?["height"];
    fit = json?["fit"];
    return super.fromJson(json);
  }
}
