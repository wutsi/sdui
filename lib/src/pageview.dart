import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sdui/sdui.dart';

/// Descriptor of a [PageView].
///
/// ### JSON Attributes
/// - **direction**: Scroll direction. The supported values are:
///   - `horizontal` (Default)
///   - `vertical`
class SDUIPageView extends SDUIWidget {
  String direction = 'horizontal';

  @override
  Widget toWidget(BuildContext context) => _PageViewWidgetStateful(this);

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    super.fromJson(json);
    direction = json?['direction'] ?? 'horizontal';
    return this;
  }
}

class _PageViewWidgetStateful extends StatefulWidget {
  final SDUIPageView delegate;

  const _PageViewWidgetStateful(this.delegate, {Key? key}) : super(key: key);

  @override
  _PageViewWidgetState createState() => _PageViewWidgetState(delegate);
}

class _PageViewWidgetState extends State<_PageViewWidgetStateful> {
  SDUIPageView delegate;
  PageController controller = PageController();

  _PageViewWidgetState(this.delegate);

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < delegate.children.length; i++) {
      _attach(delegate.children[i]);
    }
  }

  @override
  Widget build(BuildContext context) => PageView(
        scrollDirection: _toScrollDirection(),
        controller: controller,
        children: delegate.childrenWidgets(context),
      );

  Axis _toScrollDirection() {
    switch (delegate.direction.toLowerCase()) {
      case 'vertical':
        return Axis.vertical;
      default:
        return Axis.horizontal;
    }
  }

  void _attach(SDUIWidget widget) {
    widget.action.pageController = controller;
    for (var i = 0; i < widget.children.length; i++) {
      _attach(widget.children[i]);
    }
  }
}
