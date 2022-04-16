import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

import 'analytics.dart';
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

  @override
  String toString() => "StaticRouteContentProvider";
}

/// Static implementation of RouteContentProvider with static content
class HttpRouteContentProvider implements RouteContentProvider {
  final String _url;
  final Map<String, dynamic>? data;

  const HttpRouteContentProvider(this._url, {this.data});

  @override
  Future<String> getContent() async => Http.getInstance().post(_url, data);

  @override
  String toString() => "StaticRouteContentProvider(url=$_url)";
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
  static Map<int, String?> statusCodeRoutes = {};
  static final List<String> _history = [];

  final RouteContentProvider provider;
  final PageController? pageController;
  late Future<String> content;
  SDUIWidget? sduiWidget;

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
    content = provider.getContent();
  }

  @override
  Widget build(BuildContext context) =>
      Center(
          child: FutureBuilder<String>(
              future: content,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  sduiWidget =
                      SDUIParser.getInstance().fromJson(
                          jsonDecode(snapshot.data!));
                  sduiWidget?.attachPageController(pageController);
                  _push(sduiWidget?.id);
                  return sduiWidget!.toWidget(context);
                } else if (snapshot.hasError) {
                  // Log
                  var error = snapshot.error;
                  if (error is ClientException) {
                    int? statusCode = int.tryParse(error.message);
                    if (statusCode != null) {
                      String? route = statusCodeRoutes[statusCode];
                      if (route != null) {
                        _logger.e('status=$statusCode route=$route', error,
                            snapshot.stackTrace);
                        Navigator.pushReplacementNamed(context, route);
                      }
                    }
                  }

                  // Error State
                  _logger.e('provider=$provider', error, snapshot.stackTrace);
                  return sduiErrorState(context, error);
                }

                // Loading state
                return sduiLoadingState(context);
              }));

  void _push(String? pageId) {
    if (pageId != null && pageId != _peek()) {
      _history.add(pageId);
      _logger.i('...push($pageId) - history=$_history');

      _notifyAnalytics();
    }
  }

  void _pop() {
    if (_history.isNotEmpty) {
      _history.removeAt(_history.length - 1);
      _logger.i('...pop() - history=$_history');

      _notifyAnalytics();
    }
  }

  String? _peek() => _history.isEmpty ? null : _history.last;


  @override
  void didPush() {
    _logger.i('didPush() - widget.id=${sduiWidget?.id} - peek=${_peek()}');
    super.didPush();

    _notifyAnalytics();
  }

  @override
  void didPushNext() {
    _logger.i('didPushNext() - widget.id=${sduiWidget?.id} - peek=${_peek()}');
    super.didPush();

    // _push(sduiWidget?.id);
  }

  @override
  void didPop() {
    _logger.i('didPop() - widget.id=${sduiWidget?.id} - peek=${_peek()}');
    super.didPop();
  }

  @override
  void didPopNext() {
    _logger.i('didPopNext() - widget.id=${sduiWidget?.id} - peek=${_peek()}');
    super.didPopNext();

    if (_history.isEmpty || _peek() != sduiWidget?.id) {
      _logger.i('... Reloading the page');
      _pop();

      // Force refresh of the page
      setState(() {
        _reload();
      });
    }
  }

  void _notifyAnalytics() {
    try {
      String? id = sduiWidget?.id;
      if (id != null) {
        sduiAnalytics.onRoute(id);
      }
    } catch (e) {
      _logger.w("Unable to push event to Analytics", e);
    }
  }
}
