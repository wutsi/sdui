import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:sdui/sdui.dart';
import 'package:sdui/src/logger.dart';

import 'http.dart';
import 'parser.dart';

/// Route observer to track route navigation so that we can reload screens when poped.
/// See DynamicRouteState.didPopNext().
/// IMPORTANT: This route observer must be added to the application
final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

/// Returns the content of a route
abstract class RouteContentProvider {
  Future<String> getContent();
}

/// Static implementation of RouteContentProvider with static content
class StaticRouteContentProvider implements RouteContentProvider {
  String json;

  StaticRouteContentProvider(this.json);

  @override
  Future<String> getContent() {
    return Future(() => json);
  }
}

/// Static implementation of RouteContentProvider with static content
class HttpRouteContentProvider implements RouteContentProvider {
  String url;

  HttpRouteContentProvider(this.url);

  @override
  Future<String> getContent() async => Http.getInstance().post(url, null);
}

/// Dynamic Route
class DynamicRoute extends StatefulWidget {
  final RouteContentProvider provider;
  final PageController? pageController;

  const DynamicRoute({Key? key, this.pageController, required this.provider})
      : super(key: key);

  @override
  DynamicRouteState createState() =>
      // ignore: no_logic_in_create_state
      DynamicRouteState(provider, pageController);
}

class DynamicRouteState extends State<DynamicRoute> with RouteAware {
  static final Logger _logger = LoggerFactory.create('DynamicRouteState');
  final RouteContentProvider provider;
  final PageController? pageController;
  late Future<String> content;

  DynamicRouteState(this.provider, this.pageController);

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      routeObserver.subscribe(this, ModalRoute.of(context)!);
    });

    super.initState();
    content = provider.getContent();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Center(
      child: FutureBuilder<String>(
          future: content,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              SDUIWidget widget =
                  SDUIParser.getInstance().fromJson(jsonDecode(snapshot.data!));
              widget.attachPageController(pageController);
              return widget.toWidget(context);
            } else if (snapshot.hasError) {
              var error = snapshot.error;
              if (error is ClientException) {
                _logger.e('${error.uri} - ${error.message}', error,
                    snapshot.stackTrace);
              } else {
                _logger.e(
                    'Unable to download content', error, snapshot.stackTrace);
              }
              return const Icon(Icons.error);
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          }));

  @override
  void didPopNext() {
    super.didPopNext();

    // Force refresh of the page
    setState(() {});
  }
}
