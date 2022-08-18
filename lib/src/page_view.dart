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
  bool scrollOnUserInput = false;

  @override
  Widget toWidget(BuildContext context) => _PageViewWidgetStateful(this);

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    super.fromJson(json);
    direction = json?['direction'] ?? 'horizontal';
    scrollOnUserInput = json?['scrollOnUserInput'] ?? false;
    return this;
  }
}

/// Descriptor of the children of [SDUIPageView]
///
/// ### JSON Attributes
/// - **id**: Unique ID of the page
/// - **url**: URL of the page content.
class SDUIPage extends SDUIWidget {
  String? url;

  @override
  Widget toWidget(BuildContext context) => DynamicRoute(
      provider: HttpRouteContentProvider(url ?? ''),
      pageController: action.pageController);

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    url = json?['url'];
    return super.fromJson(json);
  }
}

class _PageViewWidgetStateful extends StatefulWidget {
  final SDUIPageView delegate;

  const _PageViewWidgetStateful(this.delegate, {Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _PageViewWidgetState createState() => _PageViewWidgetState(delegate);
}

class _PageViewWidgetState extends State<_PageViewWidgetStateful> {
  SDUIPageView delegate;
  PageController controller = PageController();

  _PageViewWidgetState(this.delegate);

  @override
  void initState() {
    super.initState();

    delegate.attachPageController(controller);
  }

  @override
  Widget build(BuildContext context) => PageView.builder(
        key: delegate.id == null ? null : Key(delegate.id!),
        scrollDirection: _toScrollDirection(),
        controller: controller,
        physics: _toScrollPhysics(),
        itemBuilder: (context, index) =>
            delegate.children[index].toWidget(context),
      );

  Axis _toScrollDirection() {
    switch (delegate.direction.toLowerCase()) {
      case 'vertical':
        return Axis.vertical;
      default:
        return Axis.horizontal;
    }
  }

  ScrollPhysics _toScrollPhysics() => delegate.scrollOnUserInput
      ? const RangeMaintainingScrollPhysics()
      : const NeverScrollableScrollPhysics();
}
