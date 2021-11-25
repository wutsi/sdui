import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

import 'error.dart';
import 'http.dart';
import 'loading.dart';
import 'logger.dart';
import 'parser.dart';
import 'widget.dart';

/// Route observer to track route navigation so that we can reload screens when poped.
/// See DynamicRouteState.didPopNext().
/// IMPORTANT: This route observer must be added to the application
final RouteObserver<ModalRoute> sduiRouteObserver = RouteObserver<ModalRoute>();

/// Returns the content of a route
abstract class RouteContentProvider {
  Future<String> getContent();
}

/// Static implementation of RouteContentProvider with static content
class StaticRouteContentProvider implements RouteContentProvider {
  final String _json;

  const StaticRouteContentProvider(this._json);

  @override
  Future<String> getContent() {
    return Future(() => _json);
  }
}

/// Static implementation of RouteContentProvider with static content
class HttpRouteContentProvider implements RouteContentProvider {
  final String _url;

  const HttpRouteContentProvider(this._url);

  @override
  Future<String> getContent() async => Http.getInstance().post(_url, null);
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
  String? id;

  DynamicRouteState(this.provider, this.pageController);

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      sduiRouteObserver.subscribe(this, ModalRoute.of(context)!);
    });

    super.initState();
    content = provider.getContent();
  }

  @override
  void dispose() {
    sduiRouteObserver.unsubscribe(this);

    super.dispose();
  }

  void _reload() {
    _logger.i('id=$id status=reloading');

    content = provider.getContent();
  }

  @override
  Widget build(BuildContext context) => Center(
      child: FutureBuilder<String>(
          future: content,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              SDUIWidget widget =
                  SDUIParser.getInstance().fromJson(jsonDecode(snapshot.data!));
              id = widget.id;
              widget.attachPageController(pageController);

              return widget.toWidget(context);
            } else if (snapshot.hasError) {
              // Log
              var error = snapshot.error;
              if (error is ClientException) {
                _logger.e('${error.uri} - ${error.message}', error,
                    snapshot.stackTrace);
              } else {
                _logger.e(
                    'Unable to download content', error, snapshot.stackTrace);
              }

              // Error State
              return sduiErrorState(context, error);
            }

            // Loading state
            return sduiLoadingState(context);
          }));

  @override
  void didPopNext() {
    super.didPopNext();

    // Force refresh of the page
    setState(() {
      _reload();
    });
  }
}
