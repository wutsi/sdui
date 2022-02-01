import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'widget.dart';

/// Descriptor of a [CarouselSlider]
class SDUICarouselSlider extends SDUIWidget {
  double? aspectRatio;
  double? height;
  double? viewportFraction;
  bool? enableInfiniteScroll;
  bool? reverse;

  @override
  Widget toWidget(BuildContext context) => CarouselSlider(
      items: childrenWidgets(context),
      options: CarouselOptions(
          aspectRatio: aspectRatio ?? 16 / 9,
          height: height,
          enableInfiniteScroll: enableInfiniteScroll ?? false,
          reverse: reverse ?? true,
          viewportFraction: viewportFraction ?? .8));

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    aspectRatio = json?["aspectRatio"];
    height = json?["height"];
    enableInfiniteScroll = json?["enableInfiniteScroll"];
    reverse = json?["reverse"];
    viewportFraction = json?["viewportFraction"];
    return super.fromJson(json);
  }
}

class _CarouselSliderWidget extends StatefulWidget {
  final SDUICarouselSlider delegate;

  const _CarouselSliderWidget(this.delegate, {Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _CarouselSliderState(delegate);
}

class _CarouselSliderState extends State<_CarouselSliderWidget> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  final SDUICarouselSlider delegate;

  _CarouselSliderState(this.delegate);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CarouselSlider(
        items: delegate.childrenWidgets(context),
        options: CarouselOptions(
            aspectRatio: delegate.aspectRatio ?? 16 / 9,
            height: delegate.height,
            enableInfiniteScroll: delegate.enableInfiniteScroll ?? false,
            reverse: delegate.reverse ?? true,
            viewportFraction: delegate.viewportFraction ?? .8,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            }),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: delegate.children.asMap().entries.map((entry) {
          return GestureDetector(
            onTap: () => _controller.animateToPage(entry.key),
            child: Container(
              width: 12.0,
              height: 12.0,
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black)
                      .withOpacity(_current == entry.key ? 0.9 : 0.4)),
            ),
          );
        }).toList(),
      )
    ]);
  }
}
